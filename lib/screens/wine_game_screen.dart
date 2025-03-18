import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';
import '../data/wine_data.dart';

class WineGameScreen extends StatefulWidget {
  final GameMode gameMode;
  final Municipality? selectedMunicipality; // Easy mode用

  const WineGameScreen({
    Key? key,
    required this.gameMode,
    this.selectedMunicipality,
  }) : super(key: key);

  @override
  _WineGameScreenState createState() => _WineGameScreenState();
}

class _WineGameScreenState extends State<WineGameScreen> {
  late List<Wine> _allWines;
  final List<Wine> _placedWines = [];
  late List<Classification> _classifications;
  late List<Municipality> _municipalities;
  late List<List<List<Wine>>> _targetMatrix;
  
  // Timer variables
  Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;
  int _elapsedTimeInSeconds = 0;
  
  // Game state
  bool _gameCompleted = false;

  @override
  void initState() {
    super.initState();
    _classifications = getAllClassifications();
    if (widget.gameMode == GameMode.Easy) {
      _municipalities = [widget.selectedMunicipality!];
      _allWines = getWineData()
          .where((wine) => wine.municipality == widget.selectedMunicipality)
          .toList();
    } else {
      _municipalities = getAllMunicipalities();
      _allWines = getWineData();
    }
    _allWines.shuffle();
    _initializeTargetMatrix();
    
    // Start the timer
    _startTimer();
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }

  void _startTimer() {
    _stopwatch.start();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedTimeInSeconds = _stopwatch.elapsed.inSeconds;
      });
    });
  }

  void _stopTimer() {
    _stopwatch.stop();
    _timer?.cancel();
  }

  void _resetTimer() {
    _stopwatch.reset();
    _elapsedTimeInSeconds = 0;
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void _saveTime() async {
    final prefs = await SharedPreferences.getInstance();
    String timeKey;
    
    if (widget.gameMode == GameMode.Easy) {
      // For easy mode, use municipality name as part of the key
      timeKey = 'best_time_easy_${widget.selectedMunicipality!.name}';
    } else {
      // For standard mode
      timeKey = 'best_time_standard';
    }
    
    // Get the current best time, if any
    int? currentBestTime = prefs.getInt(timeKey);
    
    // Save only if it's better than the previous best time or if there's no previous best time
    if (currentBestTime == null || _elapsedTimeInSeconds < currentBestTime) {
      await prefs.setInt(timeKey, _elapsedTimeInSeconds);
      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('New best time: ${_formatTime(_elapsedTimeInSeconds)}!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _initializeTargetMatrix() {
    _targetMatrix = List.generate(
      _classifications.length,
      (_) => List.generate(_municipalities.length, (_) => []),
    );
  }

  void _initializeWines() {
    setState(() {
      if (widget.gameMode == GameMode.Easy) {
        _allWines = getWineData()
            .where((wine) => wine.municipality == widget.selectedMunicipality)
            .toList();
      } else {
        _allWines = getWineData();
      }
      _allWines.shuffle();
      for (var wine in _allWines) {
        wine.isPlaced = false;
      }
      _placedWines.clear();
      _initializeTargetMatrix();
      
      // Reset game state
      _gameCompleted = false;
      
      // Reset and restart timer
      _resetTimer();
      _startTimer();
    });
  }

  void _placeWine(Wine wine, int classIndex, int areaIndex) {
    setState(() {
      wine.isPlaced = true;
      _targetMatrix[classIndex][areaIndex].add(wine);
      _placedWines.add(wine);
      
      // Check if game is completed
      if (_placedWines.length == _allWines.length) {
        _gameCompleted = true;
        _stopTimer();
        _saveTime();
        _showGameCompletionDialog();
      }
    });
  }

  void _returnWineToHand(Wine wine) {
    setState(() {
      wine.isPlaced = false;
      for (var row in _targetMatrix) {
        for (var cell in row) {
          cell.remove(wine);
        }
      }
      _placedWines.remove(wine);
      
      // Game is no longer complete
      _gameCompleted = false;
    });
  }

  void _showGameCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Congratulations!'),
          content: Text('You completed the game in ${_formatTime(_elapsedTimeInSeconds)}!'),
          actions: [
            TextButton(
              child: Text('Play Again'),
              onPressed: () {
                Navigator.of(context).pop();
                _initializeWines();
              },
            ),
            TextButton(
              child: Text('Back to Menu'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Go back to previous screen
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Médoc 61 Fan Tan (1855) - ${widget.gameMode == GameMode.Easy ? "Easy Mode" : "Standard Mode"}'),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Time: ${_formatTime(_elapsedTimeInSeconds)}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _initializeWines,
          ),
        ],
      ),
      body: Column(
        children: [
          // ゲームボードエリア
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildMatrix(),
            ),
          ),
          // プレイヤーのワインカードエリア
          Container(
            height: 120,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: assortColor,
              border: Border(top: BorderSide(width: 2, color: accentColor)),
            ),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: _allWines
                  .where((wine) => !wine.isPlaced)
                  .map((wine) => _buildWineCard(wine))
                  .toList(),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMatrix() {
    return Column(
      children: [
        // 市名ヘッダー行
        Row(
          children: [
            Container(
              width: 100,
              height: 50,
              alignment: Alignment.center,
              child: const Text(''),
            ),
            ..._municipalities.map((municipality) {
              return Expanded(
                child: Container(
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
                  child: Text(
                    municipality.displayName,
                    style: const TextStyle(fontWeight: FontWeight.bold, color: assortColor),
                  ),
                ),
              );
            }).toList(),
          ],
        ),
        // 分類ごとのドロップターゲット行
        Expanded(
          child: ListView.builder(
            itemCount: _classifications.length,
            itemBuilder: (context, classIndex) {
              Classification classification = _classifications[classIndex];
              return SizedBox(
                height: 80,
                child: Row(
                  children: [
                    Container(
                      width: 100,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        color: assortColor.withOpacity(0.1),
                      ),
                      child: Text(
                        classification.displayName,
                        style: const TextStyle(fontWeight: FontWeight.bold, color: assortColor),
                      ),
                    ),
                    ...List.generate(_municipalities.length, (areaIndex) {
                      return Expanded(
                        child: Container(
                          margin: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            border: Border.all(color: accentColor),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: DragTarget<Wine>(
                            builder: (context, candidateData, rejectedData) {
                              return Container(
                                color: candidateData.isNotEmpty
                                    ? accentColor.withOpacity(0.3)
                                    : Colors.transparent,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: _targetMatrix[classIndex][areaIndex]
                                      .map((wine) => _buildPlacedWineCard(wine))
                                      .toList(),
                                ),
                              );
                            },
                            onWillAccept: (wine) {
                              return wine != null &&
                                  wine.classification == classification &&
                                  wine.municipality == _municipalities[areaIndex];
                            },
                            onAccept: (wine) {
                              _placeWine(wine, classIndex, areaIndex);
                            },
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildWineCard(Wine wine) {
    return Draggable<Wine>(
      data: wine,
      feedback: Material(
        elevation: 4,
        child: Container(
          width: 120,
          height: 120,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: accentColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Château',
                style: TextStyle(fontSize: 8, color: assortColor),
                textAlign: TextAlign.center,
              ),
              Text(
                wine.name.substring(wine.name.indexOf('Château ') + 8),
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: assortColor),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      childWhenDragging: Container(
        width: 120,
        height: 120,
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[400]!),
        ),
      ),
      child: Container(
        width: 120,
        height: 120,
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: accentColor,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Château',
              style: TextStyle(fontSize: 8, color: assortColor),
              textAlign: TextAlign.center,
            ),
            Text(
              wine.name.substring(wine.name.indexOf('Château ') + 8),
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: assortColor),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlacedWineCard(Wine wine) {
    return GestureDetector(
      onTap: () => _returnWineToHand(wine),
      child: Container(
        width: 120,
        height: 100,
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: accentColor,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                const TextSpan(
                  text: 'Château ',
                  style: TextStyle(fontSize: 8, color: assortColor),
                ),
                TextSpan(
                  text: wine.name.substring(wine.name.indexOf('Château ') + 8),
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: assortColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}