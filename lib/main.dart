import 'package:flutter/material.dart';
import 'wine_data.dart';

void main() {
  runApp(const MedocFanTanApp());
}

// Define our custom color constants.
const Color baseColor = Color(0xFF5E2129);    // 60% usage – background.
const Color accentColor = Color(0xFF2C3E50);  // 10% usage – accent elements.
const Color assortColor = Color(0xFFFAF3E0);  // 30% usage – main buttons, app bar, text, etc.

enum GameMode { Easy, Standard }

class MedocFanTanApp extends StatelessWidget {
  const MedocFanTanApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = ThemeData(
      // Create a color scheme that uses our custom colors.
      colorScheme: ColorScheme(
        brightness: Brightness.dark,
        primary: assortColor,
        onPrimary: baseColor,
        secondary: accentColor,
        onSecondary: assortColor,
        background: baseColor,
        onBackground: assortColor,
        surface: assortColor,
        onSurface: baseColor,
        error: Colors.red,
        onError: Colors.white,
      ),
      // Set the scaffold (background) color.
      scaffoldBackgroundColor: baseColor,
      // Configure the AppBar.
      appBarTheme: AppBarTheme(
        backgroundColor: assortColor,
        foregroundColor: baseColor,
        iconTheme: IconThemeData(color: accentColor),
        titleTextStyle: const TextStyle(
          color: baseColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      // Style ElevatedButtons.
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          primary: assortColor,
          onPrimary: baseColor,
        ),
      ),
      // Set a text theme so that default text uses assortColor.
      textTheme: const TextTheme(
        bodyText1: TextStyle(color: assortColor),
        bodyText2: TextStyle(color: assortColor),
      ),
      fontFamily: 'Georgia',
    );

    return MaterialApp(
      title: 'Médoc 61 Fan Tan (1855)',
      theme: theme,
      home: const StartScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// --------------------
// Start Screen
// --------------------
class StartScreen extends StatelessWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The AppBar now uses the updated theme.
      appBar: AppBar(title: const Text('Médoc 61 Fan Tan (1855)')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              child: const Text('Standard Mode'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const WineGameScreen(gameMode: GameMode.Standard),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('Easy Mode'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const EasyModeCommuneSelectionScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// --------------------
// Easy Mode Commune Selection Screen
// --------------------
class EasyModeCommuneSelectionScreen extends StatelessWidget {
  const EasyModeCommuneSelectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use all municipalities defined in your wine_data.dart.
    List<Municipality> communes = getAllMunicipalities();
    return Scaffold(
      appBar: AppBar(title: const Text('Select a Commune for Easy Mode')),
      body: ListView.builder(
        itemCount: communes.length,
        itemBuilder: (context, index) {
          Municipality commune = communes[index];
          return ListTile(
            title: Text(
              commune.displayName,
              style: const TextStyle(color: assortColor),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => WineGameScreen(
                    gameMode: GameMode.Easy,
                    selectedMunicipality: commune,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// --------------------
// Modified Wine Game Screen
// --------------------
class WineGameScreen extends StatefulWidget {
  final GameMode gameMode;
  final Municipality? selectedMunicipality; // used only in Easy mode

  const WineGameScreen({
    Key? key,
    required this.gameMode,
    this.selectedMunicipality,
  }) : super(key: key);

  @override
  _WineGameScreenState createState() => _WineGameScreenState();
}

class _WineGameScreenState extends State<WineGameScreen> {
  late List<Wine> _allWines; // Wine deck for the game
  final List<Wine> _placedWines = []; // Wines placed on the board
  late List<Classification> _classifications;
  late List<Municipality> _municipalities;
  late List<List<List<Wine>>> _targetMatrix; // target matrix (grid)

  @override
  void initState() {
    super.initState();
    _classifications = getAllClassifications();
    // For Easy mode, we only use the chosen commune; otherwise, all communes.
    if (widget.gameMode == GameMode.Easy) {
      _municipalities = [widget.selectedMunicipality!];
      // Optionally, filter the wine deck to include only wines from the chosen commune.
      _allWines = getWineData()
          .where((wine) => wine.municipality == widget.selectedMunicipality)
          .toList();
    } else {
      _municipalities = getAllMunicipalities();
      _allWines = getWineData();
    }
    _allWines.shuffle();
    _initializeTargetMatrix();
  }

  // Create the target matrix based on classifications and municipalities.
  void _initializeTargetMatrix() {
    _targetMatrix = List.generate(
      _classifications.length,
      (_) => List.generate(_municipalities.length, (_) => []),
    );
  }

  // Restart the game.
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
    });
  }

  // Place a wine on the board.
  void _placeWine(Wine wine, int classIndex, int areaIndex) {
    setState(() {
      wine.isPlaced = true;
      _targetMatrix[classIndex][areaIndex].add(wine);
      _placedWines.add(wine);
    });
  }

  // Return a wine back to the player's hand.
  void _returnWineToHand(Wine wine) {
    setState(() {
      wine.isPlaced = false;
      for (var row in _targetMatrix) {
        for (var cell in row) {
          cell.remove(wine);
        }
      }
      _placedWines.remove(wine);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Médoc 61 Fan Tan (1855) - ${widget.gameMode == GameMode.Easy ? "Easy Mode" : "Standard Mode"}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _initializeWines,
          ),
        ],
      ),
      body: Column(
        children: [
          // Game board area.
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildMatrix(),
            ),
          ),
          // Player's wine cards area.
          Container(
            height: 120,
            padding: const EdgeInsets.all(8),
            // Card placement area: background is assortColor.
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

  // Build the game board (matrix).
  Widget _buildMatrix() {
    return Column(
      children: [
        // Header row for municipality names.
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
        // Classification rows with drop targets.
        Expanded(
          child: ListView.builder(
            itemCount: _classifications.length,
            itemBuilder: (context, classIndex) {
              Classification classification = _classifications[classIndex];
              String classificationName = classification.displayName;
              return SizedBox(
                height: 80,
                child: Row(
                  children: [
                    // Classification label.
                    Container(
                      width: 100,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        color: _getClassificationColor(classification).withOpacity(0.1),
                      ),
                      child: Wrap(
                        direction: Axis.vertical,
                        crossAxisAlignment: WrapCrossAlignment.start,
                        children: [
                          RichText(
                            text: const TextSpan(
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: assortColor,
                              ),
                              children: [],
                            ),
                          ),
                          // Using simple Text widgets with assortColor for clarity.
                          Text(
                            classificationName,
                            style: const TextStyle(fontWeight: FontWeight.bold, color: assortColor),
                          ),
                        ],
                      ),
                    ),
                    // Drop targets for each municipality column.
                    ...List.generate(_municipalities.length, (areaIndex) {
                      Municipality municipality = _municipalities[areaIndex];
                      return Expanded(
                        child: Container(
                          margin: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            border: Border.all(color: _getClassificationColor(classification)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: DragTarget<Wine>(
                            builder: (context, candidateData, rejectedData) {
                              return Container(
                                color: candidateData.isNotEmpty
                                    ? _getClassificationColor(classification).withOpacity(0.3)
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
                                  wine.municipality == municipality;
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

  // Build a draggable wine card.
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
            color: accentColor, // Card color is now accentColor.
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Château',
                style: const TextStyle(fontSize: 8, color: assortColor),
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
          color: accentColor, // Card color is now accentColor.
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
            Text(
              'Château',
              style: const TextStyle(fontSize: 10, color: assortColor),
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

  // Build a wine card that has been placed.
  Widget _buildPlacedWineCard(Wine wine) {
    return GestureDetector(
      onTap: () => _returnWineToHand(wine),
      child: Container(
        width: 120,
        height: 100,
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: accentColor, // Card color is now accentColor.
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
                  style: TextStyle(fontSize: 9, color: assortColor),
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

  // Helper: get a color based on the wine's municipality.
  Color _getMunicipalityColor(Municipality municipality) {
    switch (municipality) {
      case Municipality.margaux:
        return Colors.purple[700]!;
      case Municipality.pauillac:
        return Colors.red[800]!;
      case Municipality.saintJulien:
        return Colors.blue[800]!;
      case Municipality.saintEstephe:
        return Colors.green[800]!;
      case Municipality.hautMedoc:
        return Colors.amber[800]!;
    }
  }

  // Helper: get a color based on the classification.
  Color _getClassificationColor(Classification classification) {
    switch (classification) {
      case Classification.first:
        return Colors.purple[900]!;
      case Classification.second:
        return Colors.red[700]!;
      case Classification.third:
        return Colors.blue[700]!;
      case Classification.fourth:
        return Colors.green[700]!;
      case Classification.fifth:
        return Colors.amber[700]!;
    }
  }
}
