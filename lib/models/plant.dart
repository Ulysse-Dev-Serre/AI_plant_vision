import 'package:cloud_firestore/cloud_firestore.dart';

class Plant {
  final String id;
  final String nom;
  final String description; // Noms communs
  final String imagePath;
  final DateTime date;
  final String? imageUrl;
  final String? wikiDescription; // Description Wikipedia
  final double confiance; // Probabilité d'identification (0.0 à 1.0)
  final double? isPlantProbability; // Probabilité que ce soit une plante

  Plant({
    required this.id,
    required this.nom,
    this.description = '',
    required this.imagePath,
    required this.date,
    this.imageUrl,
    this.wikiDescription,
    this.confiance = 0.0,
    this.isPlantProbability,
  });

  // Convertir un objet Plant en Map pour Firestore
  Map<String, dynamic> toMap() {
    return {
      'nom': nom,
      'description': description,
      'imagePath': imagePath,
      'date': Timestamp.fromDate(date),
      'imageUrl': imageUrl,
      'wikiDescription': wikiDescription,
      'confiance': confiance,
      'isPlantProbability': isPlantProbability,
    };
  }

  // Créer un objet Plant à partir d'un document Firestore
  factory Plant.fromMap(Map<String, dynamic> map, String id) {
    return Plant(
      id: id,
      nom: map['nom'] ?? '',
      description: map['description'] ?? '',
      imagePath: map['imagePath'] ?? '',
      date: (map['date'] as Timestamp).toDate(),
      imageUrl: map['imageUrl'],
      wikiDescription: map['wikiDescription'],
      confiance: (map['confiance'] ?? 0.0).toDouble(),
      isPlantProbability: map['isPlantProbability']?.toDouble(),
    );
  }
  
  @override
  String toString() {
    return 'Plant{id: $id, nom: $nom, date: $date}';
  }
}
