// PERSONNE A - Écran d'historique
import 'package:flutter/material.dart';
import '../models/plant.dart';
import '../services/storage_service.dart';
import 'dart:io';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final StorageService _storageService = StorageService();
  List<Plant> _plants = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _chargerHistorique();
  }

  // TODO PERSONNE A: Fonction pour charger l'historique
  Future<void> _chargerHistorique() async {
    // Appeler _storageService.getHistorique()
    // Mettre à jour _plants et _isLoading à false
    // Ne pas oublier setState
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historique'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _plants.isEmpty
              ? const Center(child: Text('Aucune plante enregistrée'))
              : ListView.builder(
                  itemCount: _plants.length,
                  itemBuilder: (context, index) {
                    final plant = _plants[index];
                    
                    // TODO PERSONNE A: Créer une Card pour afficher chaque plante
                    // - leading: Image.file (50x50)
                    // - title: nom de la plante
                    // - subtitle: date (jour/mois/année)
                    // - trailing: IconButton delete (optionnel)
                    
                    return Container(); // Remplacer par votre Card
                  },
                ),
    );
  }
}
