import 'package:flutter/material.dart';
import 'wine_data.dart'; // Import the wine data file

void main() {
  runApp(const MedocFanTanApp());
}

class MedocFanTanApp extends StatelessWidget {
  const MedocFanTanApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Médoc 61 Fan Tan (1855)',
      theme: ThemeData(
        primarySwatch: Colors.red,
        fontFamily: 'Georgia',
      ),
      home: const WineGameScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class WineGameScreen extends StatefulWidget {
  const WineGameScreen({Key? key}) : super(key: key);

  @override
  _WineGameScreenState createState() => _WineGameScreenState();
}

class _WineGameScreenState extends State<WineGameScreen> {
  late List<Wine> _allWines;  // All wines in the game
  final List<Wine> _placedWines = [];  // Wines that have been placed on the board
  
  // Lists of classifications and municipalities from enums
  final List<Classification> _classifications = getAllClassifications();
  final List<Municipality> _municipalities = getAllMunicipalities();
  
  // Target matrix: a 5x5 grid (each cell is a list of wines dropped there)
  late List<List<List<Wine>>> _targetMatrix;

  @override
  void initState() {
    super.initState();
    _initializeWines();
  }

  // Initialize the game with a new set of shuffled wines
  void _initializeWines() {
    // Get wine data from separate file
    _allWines = getWineData();
    _allWines.shuffle();

    // Initialize a 5x5 empty matrix (classifications x municipalities)
    _targetMatrix = List.generate(
      _classifications.length, 
      (_) => List.generate(_municipalities.length, (_) => [])
    );
  }

  // Place a wine on the board at the specified position
  void _placeWine(Wine wine, int classIndex, int areaIndex) {
    setState(() {
      wine.isPlaced = true;
      _targetMatrix[classIndex][areaIndex].add(wine);
      _placedWines.add(wine);
    });
  }

  // Return a wine from the board back to the player's hand
  void _returnWineToHand(Wine wine) {
    setState(() {
      wine.isPlaced = false;
      // Remove wine from all cells in the matrix
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
        title: const Text('Médoc 61 Fan Tan (1855)'),
        actions: [
          // Refresh button to restart the game
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _initializeWines();
                _placedWines.clear();
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Game board: 5x5 target matrix
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildMatrix(),
            ),
          ),
          // Wine cards in player's hand
          Container(
            height: 120, // Fixed height of 120px
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              border: Border(
                top: BorderSide(width: 2, color: Colors.grey[400]!),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Text(
                    'Your Wine Cards',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: _allWines
                        .where((wine) => !wine.isPlaced)
                        .map((wine) => _buildWineCard(wine))
                        .toList(),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  // Build the game board matrix
  Widget _buildMatrix() {
    return Column(
      children: [
        // Header row for municipality names
        Row(
          children: [
            // Empty top-left corner cell
            Container(
              width: 100,
              height: 50,
              alignment: Alignment.center,
              child: const Text(''),
            ),
            // Municipality column headers
            ..._municipalities.map((municipality) {
              return Expanded(
                child: Container(
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Text(
                    municipality.displayName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              );
            }).toList(),
          ],
        ),
        // Classification rows with drop targets
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
                    // Classification label on the left
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
                            text: TextSpan(
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: _getClassificationColor(classification),
                              ),
                              children: [
                                TextSpan(text: classificationName[0]),
                                // Superscript for "res" and "èmes" with color
                                WidgetSpan(
                                  alignment: PlaceholderAlignment.baseline,
                                  baseline: TextBaseline.alphabetic,
                                  child: Transform.translate(
                                    offset: const Offset(0, -5),
                                    child: Text(
                                      classificationName.substring(1, classificationName.indexOf(" ")),
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: _getClassificationColor(classification),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Second line with remaining text
                          Text(
                            classificationName.substring(classificationName.indexOf(" ")),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: _getClassificationColor(classification),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Build one cell per municipality
                    ...List.generate(_municipalities.length, (areaIndex) {
                      Municipality municipality = _municipalities[areaIndex];
                      return Expanded(
                        child: Container(
                          margin: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            border: Border.all(color: _getClassificationColor(classification)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          // Drop target for wine cards
                          child: DragTarget<Wine>(
                            builder: (context, candidateData, rejectedData) {
                              return Container(
                                color: candidateData.isNotEmpty
                                    ? _getClassificationColor(classification).withOpacity(0.3)
                                    : Colors.transparent,
                                // Horizontal list of placed wines in this cell
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: _targetMatrix[classIndex][areaIndex]
                                      .map((wine) => _buildPlacedWineCard(wine))
                                      .toList(),
                                ),
                              );
                            },
                            // Check if the wine can be placed in this cell
                            onWillAccept: (wine) {
                              return wine != null &&
                                  wine.classification == classification &&
                                  wine.municipality == municipality;
                            },
                            // Handle wine placement when dropped
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

  // Build a draggable wine card for the player's hand
  Widget _buildWineCard(Wine wine) {
    return Draggable<Wine>(
      data: wine,
      // Feedback widget (shown while dragging)
      feedback: Material(
        elevation: 4,
        child: Container(
          width: 120,
          height: 120,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _getMunicipalityColor(wine.municipality),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                wine.name,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
              const SizedBox(height: 4),
              Text(
                wine.municipality.displayName,
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                ),
              ),
              Text(
                wine.classification.displayName,
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
      // Widget shown in place of the dragged card
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
      // The actual card widget
      child: Container(
        width: 120,
        height: 120,
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: _getMunicipalityColor(wine.municipality),
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
              wine.name,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
            const SizedBox(height: 4),
            Text(
              wine.municipality.displayName,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.white,
              ),
            ),
            Text(
              wine.classification.displayName,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build a wine card that's been placed on the board
  Widget _buildPlacedWineCard(Wine wine) {
    return GestureDetector(
      onTap: () => _returnWineToHand(wine),
      child: Container(
        width: 120,
        height: 100,
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: _getMunicipalityColor(wine.municipality),
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
              wine.name,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
            const SizedBox(height: 2),
            Text(
              wine.municipality.displayName,
              style: const TextStyle(
                fontSize: 9,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Get color based on municipality for wine cards
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

  // Get color based on classification for the matrix cells
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