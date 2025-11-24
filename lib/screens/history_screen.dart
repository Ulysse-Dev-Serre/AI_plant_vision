// PERSONNE A - Écran d'historique
import 'package:flutter/material.dart';
import '../models/plant.dart';
import '../services/storage_service.dart';
import 'dart:io';
import '../utils/app_logger.dart';

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

  // Fonction pour charger l'historique
  Future<void> _chargerHistorique() async {
    AppLogger.debug("Chargement écran Historique");
    try {
      final plants = await _storageService.getHistorique();
      if (mounted) {
        setState(() {
          _plants = plants;
          _isLoading = false;
        });
      }
    } catch (e) {
      AppLogger.error("Erreur chargement historique UI", e);
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors du chargement de l\'historique: $e')),
        );
      }
    }
  }

  Future<void> _supprimerPlante(String id) async {
    try {
      await _storageService.supprimerPlante(id);
      _chargerHistorique(); // Recharger la liste
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Plante supprimée')),
        );
      }
    } catch (e) {
      AppLogger.error("Erreur suppression plante UI", e);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de la suppression: $e')),
        );
      }
    }
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
                    final file = File(plant.imagePath);
                    final bool fileExists = file.existsSync();

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: fileExists
                              ? Image.file(
                                  file,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  width: 50,
                                  height: 50,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.image_not_supported, size: 30),
                                ),
                        ),
                        title: Text(
                          plant.nom,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (plant.description.isNotEmpty)
                              Text(
                                plant.description,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            Text(
                              "${plant.date.day}/${plant.date.month}/${plant.date.year}",
                              style: TextStyle(color: Colors.grey[600], fontSize: 12),
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _supprimerPlante(plant.id),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
