import 'package:flutter/material.dart';

void main() {
  runApp(const MedocFanTanApp());
}

class MedocFanTanApp extends StatelessWidget {
  const MedocFanTanApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medoc 61 Fan Tan',
      theme: ThemeData(
        primarySwatch: Colors.red,
        fontFamily: 'Georgia',
      ),
      home: const WineGameScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Wine {
  final String name;
  final String municipality;
  final String classification;
  bool isPlaced = false;

  Wine({
    required this.name,
    required this.municipality,
    required this.classification,
  });
}

class WineGameScreen extends StatefulWidget {
  const WineGameScreen({Key? key}) : super(key: key);

  @override
  _WineGameScreenState createState() => _WineGameScreenState();
}

class _WineGameScreenState extends State<WineGameScreen> {
  late List<Wine> _allWines;
  final List<Wine> _placedWines = [];

  // Define classifications and areas.
  final List<String> _classifications = [
    "1ere Cru",
    "2eme Cru",
    "3eme Cru",
    "4eme Cru",
    "5eme Cru",
  ];

  final List<String> _areas = [
    "Saint-Estèphe",
    "Pauillac",
    "Saint-Julien",
    "Margaux",
    "Haut-Médoc",
  ];

  // Target matrix: a 5x5 grid (each cell is a list of wines dropped there).
  late List<List<List<Wine>>> _targetMatrix;

  @override
  void initState() {
    super.initState();
    _initializeWines();
  }

  void _initializeWines() {
    _allWines = [
      // 1ere Cru (Premier Cru)
      Wine(name: "Château Lafite Rothschild", municipality: "Pauillac", classification: "1ere Cru"),
      Wine(name: "Château Latour", municipality: "Pauillac", classification: "1ere Cru"),
      Wine(name: "Château Margaux", municipality: "Margaux", classification: "1ere Cru"),
      Wine(name: "Château Mouton Rothschild", municipality: "Pauillac", classification: "1ere Cru"),
      
      // 2eme Cru (Deuxieme Cru)
      Wine(name: "Château Rauzan-Ségla", municipality: "Margaux", classification: "2eme Cru"),
      Wine(name: "Château Rauzan-Gassies", municipality: "Margaux", classification: "2eme Cru"),
      Wine(name: "Château Léoville-Las Cases", municipality: "Saint-Julien", classification: "2eme Cru"),
      Wine(name: "Château Léoville-Poyferré", municipality: "Saint-Julien", classification: "2eme Cru"),
      Wine(name: "Château Léoville-Barton", municipality: "Saint-Julien", classification: "2eme Cru"),
      Wine(name: "Château Durfort-Vivens", municipality: "Margaux", classification: "2eme Cru"),
      Wine(name: "Château Gruaud-Larose", municipality: "Saint-Julien", classification: "2eme Cru"),
      Wine(name: "Château Lascombes", municipality: "Margaux", classification: "2eme Cru"),
      Wine(name: "Château Brane-Cantenac", municipality: "Margaux", classification: "2eme Cru"),
      Wine(name: "Château Pichon-Longueville Baron", municipality: "Pauillac", classification: "2eme Cru"),
      Wine(name: "Château Pichon-Longueville Comtesse de Lalande", municipality: "Pauillac", classification: "2eme Cru"),
      Wine(name: "Château Ducru-Beaucaillou", municipality: "Saint-Julien", classification: "2eme Cru"),
      Wine(name: "Château Cos d'Estournel", municipality: "Saint-Estèphe", classification: "2eme Cru"),
      Wine(name: "Château Montrose", municipality: "Saint-Estèphe", classification: "2eme Cru"),
      
      // 3eme Cru (Troisieme Cru)
      Wine(name: "Château Giscours", municipality: "Margaux", classification: "3eme Cru"),
      Wine(name: "Château Kirwan", municipality: "Margaux", classification: "3eme Cru"),
      Wine(name: "Château d'Issan", municipality: "Margaux", classification: "3eme Cru"),
      Wine(name: "Château Lagrange", municipality: "Saint-Julien", classification: "3eme Cru"),
      Wine(name: "Château Langoa Barton", municipality: "Saint-Julien", classification: "3eme Cru"),
      Wine(name: "Château Malescot St. Exupéry", municipality: "Margaux", classification: "3eme Cru"),
      Wine(name: "Château Cantenac Brown", municipality: "Margaux", classification: "3eme Cru"),
      Wine(name: "Château Palmer", municipality: "Margaux", classification: "3eme Cru"),
      Wine(name: "Château La Lagune", municipality: "Haut-Médoc", classification: "3eme Cru"),
      Wine(name: "Château Desmirail", municipality: "Margaux", classification: "3eme Cru"),
      Wine(name: "Château Calon-Ségur", municipality: "Saint-Estèphe", classification: "3eme Cru"),
      Wine(name: "Château Ferrière", municipality: "Margaux", classification: "3eme Cru"),
      Wine(name: "Château Marquis d'Alesme Becker", municipality: "Margaux", classification: "3eme Cru"),
      Wine(name: "Château Boyd-Cantenac", municipality: "Margaux", classification: "3eme Cru"),
      
      // 4eme Cru (Quatrieme Cru)
      Wine(name: "Château Saint-Pierre", municipality: "Saint-Julien", classification: "4eme Cru"),
      Wine(name: "Château Talbot", municipality: "Saint-Julien", classification: "4eme Cru"),
      Wine(name: "Château Branaire-Ducru", municipality: "Saint-Julien", classification: "4eme Cru"),
      Wine(name: "Château Duhart-Milon", municipality: "Pauillac", classification: "4eme Cru"),
      Wine(name: "Château Pouget", municipality: "Margaux", classification: "4eme Cru"),
      Wine(name: "Château La Tour Carnet", municipality: "Haut-Médoc", classification: "4eme Cru"),
      Wine(name: "Château Lafon-Rochet", municipality: "Saint-Estèphe", classification: "4eme Cru"),
      Wine(name: "Château Beychevelle", municipality: "Saint-Julien", classification: "4eme Cru"),
      Wine(name: "Château Prieuré-Lichine", municipality: "Margaux", classification: "4eme Cru"),
      Wine(name: "Château Marquis de Terme", municipality: "Margaux", classification: "4eme Cru"),
      
      // 5eme Cru (Cinquieme Cru)
      Wine(name: "Château Pontet-Canet", municipality: "Pauillac", classification: "5eme Cru"),
      Wine(name: "Château Batailley", municipality: "Pauillac", classification: "5eme Cru"),
      Wine(name: "Château Grand-Puy-Lacoste", municipality: "Pauillac", classification: "5eme Cru"),
      Wine(name: "Château Grand-Puy-Ducasse", municipality: "Pauillac", classification: "5eme Cru"),
      Wine(name: "Château Lynch-Bages", municipality: "Pauillac", classification: "5eme Cru"),
      Wine(name: "Château Lynch-Moussas", municipality: "Pauillac", classification: "5eme Cru"),
      Wine(name: "Château Dauzac", municipality: "Margaux", classification: "5eme Cru"),
      Wine(name: "Château d'Armailhac", municipality: "Pauillac", classification: "5eme Cru"),
      Wine(name: "Château du Tertre", municipality: "Margaux", classification: "5eme Cru"),
      Wine(name: "Château Haut-Batailley", municipality: "Pauillac", classification: "5eme Cru"),
      Wine(name: "Château Haut-Bages Libéral", municipality: "Pauillac", classification: "5eme Cru"),
      Wine(name: "Château Pédesclaux", municipality: "Pauillac", classification: "5eme Cru"),
      Wine(name: "Château Belgrave", municipality: "Haut-Médoc", classification: "5eme Cru"),
      Wine(name: "Château de Camensac", municipality: "Haut-Médoc", classification: "5eme Cru"),
      Wine(name: "Château Cos Labory", municipality: "Saint-Estèphe", classification: "5eme Cru"),
      Wine(name: "Château Clerc Milon", municipality: "Pauillac", classification: "5eme Cru"),
      Wine(name: "Château Croizet-Bages", municipality: "Pauillac", classification: "5eme Cru"),
      Wine(name: "Château Cantemerle", municipality: "Haut-Médoc", classification: "5eme Cru"),
    ];

    _allWines.shuffle();

    // Initialize a 5x5 empty matrix.
    _targetMatrix = List.generate(5, (_) => List.generate(5, (_) => []));
  }

  void _placeWine(Wine wine, int classIndex, int areaIndex) {
    setState(() {
      wine.isPlaced = true;
      _targetMatrix[classIndex][areaIndex].add(wine);
      _placedWines.add(wine);
    });
  }

  void _returnWineToHand(Wine wine) {
    setState(() {
      wine.isPlaced = false;
      // Remove wine from all cells in the matrix.
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
        title: const Text('Medoc 61 Fan Tan'),
        actions: [
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
          // Game board: 5x5 target matrix.
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildMatrix(),
            ),
          ),
          // Wine cards in hand.
          Expanded(
            flex: 3,
            child: Container(
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMatrix() {
    return Column(
      children: [
        // Header row for area names.
        Row(
          children: [
            Container(
              width: 100,
              height: 50,
              alignment: Alignment.center,
              child: const Text(''),
            ),
            ..._areas.map((area) {
              return Expanded(
                child: Container(
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Text(
                    area,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              );
            }).toList(),
          ],
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _classifications.length,
            itemBuilder: (context, classIndex) {
              String classification = _classifications[classIndex];
              return SizedBox(
                height: 80,
                child: Row(
                  children: [
                    // Classification label on the left.
                    Container(
                      width: 100,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        color: _getClassificationColor(classification).withOpacity(0.1),
                      ),
                      child: Text(
                        classification,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _getClassificationColor(classification),
                        ),
                      ),
                    ),
                    // Build one cell per area.
                    ...List.generate(_areas.length, (areaIndex) {
                      String area = _areas[areaIndex];
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
                                  wine.municipality == area;
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
                wine.municipality,
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                ),
              ),
              Text(
                wine.classification,
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.white70,
                ),
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
              wine.municipality,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.white,
              ),
            ),
            Text(
              wine.classification,
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
              wine.municipality,
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

  Color _getMunicipalityColor(String municipality) {
    switch (municipality) {
      case "Margaux":
        return Colors.purple[700]!;
      case "Pauillac":
        return Colors.red[800]!;
      case "Saint-Julien":
        return Colors.blue[800]!;
      case "Saint-Estèphe":
        return Colors.green[800]!;
      case "Haut-Médoc":
        return Colors.amber[800]!;
      default:
        return Colors.brown[700]!;
    }
  }

  Color _getClassificationColor(String classification) {
    switch (classification) {
      case "1ere Cru":
        return Colors.purple[900]!;
      case "2eme Cru":
        return Colors.red[700]!;
      case "3eme Cru":
        return Colors.blue[700]!;
      case "4eme Cru":
        return Colors.green[700]!;
      case "5eme Cru":
        return Colors.amber[700]!;
      default:
        return Colors.grey[700]!;
    }
  }
}
