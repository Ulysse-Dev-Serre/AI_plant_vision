// ENSEMBLE - Modèle de données (à créer ensemble en 10 min)
// Ce fichier définit la structure d'une plante

class Plant {
  final String nom;
  final String imagePath;
  final DateTime date;

  Plant({
    required this.nom,
    required this.imagePath,
    required this.date,
  });

  // TODO ENSEMBLE: Ajouter fromJson et toJson pour la sauvegarde
  Map<String, dynamic> toJson() {
    return {
      'nom': nom,
      'imagePath': imagePath,
      'date': date.toIso8601String(),
    };
  }

  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(
      nom: json['nom'],
      imagePath: json['imagePath'],
      date: DateTime.parse(json['date']),
    );
  }
}
