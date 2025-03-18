// wine_data.dart

// Enum for wine classification levels (1st to 5th growth)
enum Classification {
  first,   // Premier Cru
  second,  // Deuxième Cru
  third,   // Troisième Cru
  fourth,  // Quatrième Cru
  fifth    // Cinquième Cru
}

// Enum for Médoc municipalities
enum Municipality {
  saintEstephe,   // Saint-Estèphe
  pauillac,       // Pauillac
  saintJulien,    // Saint-Julien
  margaux,        // Margaux
  hautMedoc       // Haut-Médoc
}

// Extension to get display name for municipality
extension MunicipalityExtension on Municipality {
  String get displayName {
    switch (this) {
      case Municipality.saintEstephe:
        return "Saint-Estèphe";
      case Municipality.pauillac:
        return "Pauillac";
      case Municipality.saintJulien:
        return "Saint-Julien";
      case Municipality.margaux:
        return "Margaux";
      case Municipality.hautMedoc:
        return "Haut-Médoc";
    }
  }
}

// Extension to get display name for classification
extension ClassificationExtension on Classification {
  String get displayName {
    switch (this) {
      case Classification.first:
        return "1res Crûs";
      case Classification.second:
        return "2èmes Crûs";
      case Classification.third:
        return "3èmes Crûs";
      case Classification.fourth:
        return "4èmes Crûs";
      case Classification.fifth:
        return "5èmes Crûs";
    }
  }
  
  // Get the numeric value (1-5) for the classification
  int get value {
    return index + 1;
  }
}

// Wine class representing a classified Bordeaux wine
class Wine {
  final String name;
  final Municipality municipality;
  final Classification classification;
  bool isPlaced = false;

  Wine({
    required this.name,
    required this.municipality,
    required this.classification,
  });
}

// Return the complete list of 1855 classified Médoc wines
List<Wine> getWineData() {
  return [
    // 1st Growth (Premier Cru)
    Wine(name: "Château Lafite Rothschild", municipality: Municipality.pauillac, classification: Classification.first),
    Wine(name: "Château Latour", municipality: Municipality.pauillac, classification: Classification.first),
    Wine(name: "Château Margaux", municipality: Municipality.margaux, classification: Classification.first),
    Wine(name: "Château Mouton Rothschild", municipality: Municipality.pauillac, classification: Classification.first),
    
    // 2nd Growth (Deuxieme Cru)
    Wine(name: "Château Rauzan-Ségla", municipality: Municipality.margaux, classification: Classification.second),
    Wine(name: "Château Rauzan-Gassies", municipality: Municipality.margaux, classification: Classification.second),
    Wine(name: "Château Léoville-Las Cases", municipality: Municipality.saintJulien, classification: Classification.second),
    Wine(name: "Château Léoville-Poyferré", municipality: Municipality.saintJulien, classification: Classification.second),
    Wine(name: "Château Léoville-Barton", municipality: Municipality.saintJulien, classification: Classification.second),
    Wine(name: "Château Durfort-Vivens", municipality: Municipality.margaux, classification: Classification.second),
    Wine(name: "Château Gruaud-Larose", municipality: Municipality.saintJulien, classification: Classification.second),
    Wine(name: "Château Lascombes", municipality: Municipality.margaux, classification: Classification.second),
    Wine(name: "Château Brane-Cantenac", municipality: Municipality.margaux, classification: Classification.second),
    Wine(name: "Château Pichon-Longueville Baron", municipality: Municipality.pauillac, classification: Classification.second),
    Wine(name: "Château Pichon-Longueville Comtesse de Lalande", municipality: Municipality.pauillac, classification: Classification.second),
    Wine(name: "Château Ducru-Beaucaillou", municipality: Municipality.saintJulien, classification: Classification.second),
    Wine(name: "Château Cos d'Estournel", municipality: Municipality.saintEstephe, classification: Classification.second),
    Wine(name: "Château Montrose", municipality: Municipality.saintEstephe, classification: Classification.second),
    
    // 3rd Growth (Troisieme Cru)
    Wine(name: "Château Giscours", municipality: Municipality.margaux, classification: Classification.third),
    Wine(name: "Château Kirwan", municipality: Municipality.margaux, classification: Classification.third),
    Wine(name: "Château d'Issan", municipality: Municipality.margaux, classification: Classification.third),
    Wine(name: "Château Lagrange", municipality: Municipality.saintJulien, classification: Classification.third),
    Wine(name: "Château Langoa Barton", municipality: Municipality.saintJulien, classification: Classification.third),
    Wine(name: "Château Malescot St. Exupéry", municipality: Municipality.margaux, classification: Classification.third),
    Wine(name: "Château Cantenac Brown", municipality: Municipality.margaux, classification: Classification.third),
    Wine(name: "Château Palmer", municipality: Municipality.margaux, classification: Classification.third),
    Wine(name: "Château La Lagune", municipality: Municipality.hautMedoc, classification: Classification.third),
    Wine(name: "Château Desmirail", municipality: Municipality.margaux, classification: Classification.third),
    Wine(name: "Château Calon-Ségur", municipality: Municipality.saintEstephe, classification: Classification.third),
    Wine(name: "Château Ferrière", municipality: Municipality.margaux, classification: Classification.third),
    Wine(name: "Château Marquis d'Alesme Becker", municipality: Municipality.margaux, classification: Classification.third),
    Wine(name: "Château Boyd-Cantenac", municipality: Municipality.margaux, classification: Classification.third),
    
    // 4th Growth (Quatrieme Cru)
    Wine(name: "Château Saint-Pierre", municipality: Municipality.saintJulien, classification: Classification.fourth),
    Wine(name: "Château Talbot", municipality: Municipality.saintJulien, classification: Classification.fourth),
    Wine(name: "Château Branaire-DuCrû", municipality: Municipality.saintJulien, classification: Classification.fourth),
    Wine(name: "Château Duhart-Milon", municipality: Municipality.pauillac, classification: Classification.fourth),
    Wine(name: "Château Pouget", municipality: Municipality.margaux, classification: Classification.fourth),
    Wine(name: "Château La Tour Carnet", municipality: Municipality.hautMedoc, classification: Classification.fourth),
    Wine(name: "Château Lafon-Rochet", municipality: Municipality.saintEstephe, classification: Classification.fourth),
    Wine(name: "Château Beychevelle", municipality: Municipality.saintJulien, classification: Classification.fourth),
    Wine(name: "Château Prieuré-Lichine", municipality: Municipality.margaux, classification: Classification.fourth),
    Wine(name: "Château Marquis de Terme", municipality: Municipality.margaux, classification: Classification.fourth),
    
    // 5th Growth (Cinquieme Cru)
    Wine(name: "Château Pontet-Canet", municipality: Municipality.pauillac, classification: Classification.fifth),
    Wine(name: "Château Batailley", municipality: Municipality.pauillac, classification: Classification.fifth),
    Wine(name: "Château Grand-Puy-Lacoste", municipality: Municipality.pauillac, classification: Classification.fifth),
    Wine(name: "Château Grand-Puy-Ducasse", municipality: Municipality.pauillac, classification: Classification.fifth),
    Wine(name: "Château Lynch-Bages", municipality: Municipality.pauillac, classification: Classification.fifth),
    Wine(name: "Château Lynch-Moussas", municipality: Municipality.pauillac, classification: Classification.fifth),
    Wine(name: "Château Dauzac", municipality: Municipality.margaux, classification: Classification.fifth),
    Wine(name: "Château d'Armailhac", municipality: Municipality.pauillac, classification: Classification.fifth),
    Wine(name: "Château du Tertre", municipality: Municipality.margaux, classification: Classification.fifth),
    Wine(name: "Château Haut-Batailley", municipality: Municipality.pauillac, classification: Classification.fifth),
    Wine(name: "Château Haut-Bages Libéral", municipality: Municipality.pauillac, classification: Classification.fifth),
    Wine(name: "Château Pédesclaux", municipality: Municipality.pauillac, classification: Classification.fifth),
    Wine(name: "Château Belgrave", municipality: Municipality.hautMedoc, classification: Classification.fifth),
    Wine(name: "Château de Camensac", municipality: Municipality.hautMedoc, classification: Classification.fifth),
    Wine(name: "Château Cos Labory", municipality: Municipality.saintEstephe, classification: Classification.fifth),
    Wine(name: "Château Clerc Milon", municipality: Municipality.pauillac, classification: Classification.fifth),
    Wine(name: "Château Croizet-Bages", municipality: Municipality.pauillac, classification: Classification.fifth),
    Wine(name: "Château Cantemerle", municipality: Municipality.hautMedoc, classification: Classification.fifth),
  ];
}

// Helper function to get all municipalities as a list
List<Municipality> getAllMunicipalities() {
  return Municipality.values;
}

// Helper function to get all classifications as a list
List<Classification> getAllClassifications() {
  return Classification.values;
}