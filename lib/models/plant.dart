import 'package:cloud_firestore/cloud_firestore.dart';

class Plant {
  final String id;
  final String nom;
  final String imagePath;
  final DateTime date;
  final String? imageUrl; // URL de l'image stockée dans Firebase Storage

  Plant({
    required this.id,
    required this.nom,
    required this.imagePath,
    required this.date,
    this.imageUrl,
  });

  // Convertir un objet Plant en Map pour Firestore
  Map<String, dynamic> toMap() {
    return {
      'nom': nom,
      'imagePath': imagePath,
      'date': Timestamp.fromDate(date),
      'imageUrl': imageUrl,
    };
  }

  // Créer un objet Plant à partir d'un document Firestore
  factory Plant.fromMap(Map<String, dynamic> map, String id) {
    return Plant(
      id: id,
      nom: map['nom'] ?? '',
      imagePath: map['imagePath'] ?? '',
      date: (map['date'] as Timestamp).toDate(),
      imageUrl: map['imageUrl'],
    );
  }
  
  // Pour l'affichage et le debug
  @override
  String toString() {
    return 'Plant{id: $id, nom: $nom, date: $date}';
  }
}
