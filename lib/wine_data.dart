// wine_data.dart
class Wine {
  final String name;
  final String municipality;
  final int classification; // Changed to int (1-5)
  bool isPlaced = false;

  Wine({
    required this.name,
    required this.municipality,
    required this.classification,
  });
}

// Wine data moved to a separate file
List<Wine> getWineData() {
  return [
    // 1st Growth (Premier Cru)
    Wine(name: "Château Lafite Rothschild", municipality: "Pauillac", classification: 1),
    Wine(name: "Château Latour", municipality: "Pauillac", classification: 1),
    Wine(name: "Château Margaux", municipality: "Margaux", classification: 1),
    Wine(name: "Château Mouton Rothschild", municipality: "Pauillac", classification: 1),
    
    // 2nd Growth (Deuxieme Cru)
    Wine(name: "Château Rauzan-Ségla", municipality: "Margaux", classification: 2),
    Wine(name: "Château Rauzan-Gassies", municipality: "Margaux", classification: 2),
    Wine(name: "Château Léoville-Las Cases", municipality: "Saint-Julien", classification: 2),
    Wine(name: "Château Léoville-Poyferré", municipality: "Saint-Julien", classification: 2),
    Wine(name: "Château Léoville-Barton", municipality: "Saint-Julien", classification: 2),
    Wine(name: "Château Durfort-Vivens", municipality: "Margaux", classification: 2),
    Wine(name: "Château Gruaud-Larose", municipality: "Saint-Julien", classification: 2),
    Wine(name: "Château Lascombes", municipality: "Margaux", classification: 2),
    Wine(name: "Château Brane-Cantenac", municipality: "Margaux", classification: 2),
    Wine(name: "Château Pichon-Longueville Baron", municipality: "Pauillac", classification: 2),
    Wine(name: "Château Pichon-Longueville Comtesse de Lalande", municipality: "Pauillac", classification: 2),
    Wine(name: "Château Ducru-Beaucaillou", municipality: "Saint-Julien", classification: 2),
    Wine(name: "Château Cos d'Estournel", municipality: "Saint-Estèphe", classification: 2),
    Wine(name: "Château Montrose", municipality: "Saint-Estèphe", classification: 2),
    
    // 3rd Growth (Troisieme Cru)
    Wine(name: "Château Giscours", municipality: "Margaux", classification: 3),
    Wine(name: "Château Kirwan", municipality: "Margaux", classification: 3),
    Wine(name: "Château d'Issan", municipality: "Margaux", classification: 3),
    Wine(name: "Château Lagrange", municipality: "Saint-Julien", classification: 3),
    Wine(name: "Château Langoa Barton", municipality: "Saint-Julien", classification: 3),
    Wine(name: "Château Malescot St. Exupéry", municipality: "Margaux", classification: 3),
    Wine(name: "Château Cantenac Brown", municipality: "Margaux", classification: 3),
    Wine(name: "Château Palmer", municipality: "Margaux", classification: 3),
    Wine(name: "Château La Lagune", municipality: "Haut-Médoc", classification: 3),
    Wine(name: "Château Desmirail", municipality: "Margaux", classification: 3),
    Wine(name: "Château Calon-Ségur", municipality: "Saint-Estèphe", classification: 3),
    Wine(name: "Château Ferrière", municipality: "Margaux", classification: 3),
    Wine(name: "Château Marquis d'Alesme Becker", municipality: "Margaux", classification: 3),
    Wine(name: "Château Boyd-Cantenac", municipality: "Margaux", classification: 3),
    
    // 4th Growth (Quatrieme Cru)
    Wine(name: "Château Saint-Pierre", municipality: "Saint-Julien", classification: 4),
    Wine(name: "Château Talbot", municipality: "Saint-Julien", classification: 4),
    Wine(name: "Château Branaire-DuCrû", municipality: "Saint-Julien", classification: 4),
    Wine(name: "Château Duhart-Milon", municipality: "Pauillac", classification: 4),
    Wine(name: "Château Pouget", municipality: "Margaux", classification: 4),
    Wine(name: "Château La Tour Carnet", municipality: "Haut-Médoc", classification: 4),
    Wine(name: "Château Lafon-Rochet", municipality: "Saint-Estèphe", classification: 4),
    Wine(name: "Château Beychevelle", municipality: "Saint-Julien", classification: 4),
    Wine(name: "Château Prieuré-Lichine", municipality: "Margaux", classification: 4),
    Wine(name: "Château Marquis de Terme", municipality: "Margaux", classification: 4),
    
    // 5th Growth (Cinquieme Cru)
    Wine(name: "Château Pontet-Canet", municipality: "Pauillac", classification: 5),
    Wine(name: "Château Batailley", municipality: "Pauillac", classification: 5),
    Wine(name: "Château Grand-Puy-Lacoste", municipality: "Pauillac", classification: 5),
    Wine(name: "Château Grand-Puy-Ducasse", municipality: "Pauillac", classification: 5),
    Wine(name: "Château Lynch-Bages", municipality: "Pauillac", classification: 5),
    Wine(name: "Château Lynch-Moussas", municipality: "Pauillac", classification: 5),
    Wine(name: "Château Dauzac", municipality: "Margaux", classification: 5),
    Wine(name: "Château d'Armailhac", municipality: "Pauillac", classification: 5),
    Wine(name: "Château du Tertre", municipality: "Margaux", classification: 5),
    Wine(name: "Château Haut-Batailley", municipality: "Pauillac", classification: 5),
    Wine(name: "Château Haut-Bages Libéral", municipality: "Pauillac", classification: 5),
    Wine(name: "Château Pédesclaux", municipality: "Pauillac", classification: 5),
    Wine(name: "Château Belgrave", municipality: "Haut-Médoc", classification: 5),
    Wine(name: "Château de Camensac", municipality: "Haut-Médoc", classification: 5),
    Wine(name: "Château Cos Labory", municipality: "Saint-Estèphe", classification: 5),
    Wine(name: "Château Clerc Milon", municipality: "Pauillac", classification: 5),
    Wine(name: "Château Croizet-Bages", municipality: "Pauillac", classification: 5),
    Wine(name: "Château Cantemerle", municipality: "Haut-Médoc", classification: 5),
  ];
}

// Helper function to get classification display name
String getClassificationName(int classification) {
  switch (classification) {
    case 1:
      return "1res Crûs";
    case 2:
      return "2èmes Crûs";
    case 3:
      return "3èmes Crûs";
    case 4:
      return "4èmes Crûs";
    case 5:
      return "5èmes Crûs";
    default:
      return "";
  }
}
