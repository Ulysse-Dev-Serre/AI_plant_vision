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

  void _afficherDetails(Plant plant, File? imageFile) {
    final String confidenceText = "${(plant.confiance * 100).toStringAsFixed(1)}%";
    final String isPlantText = plant.isPlantProbability != null 
        ? "${(plant.isPlantProbability! * 100).toStringAsFixed(1)}%" 
        : "--%";

    // DEBUG: Log pour voir ce qui est récupéré
    AppLogger.debug('Historique - wikiDescription: ${plant.wikiDescription ?? "NULL"}');
    AppLogger.debug('Historique - confiance: ${plant.confiance}');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: const BoxDecoration(
            color: Color(0xFFF5F8F1),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              // Poignée
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // Contenu
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // BARRE D'INFO RAPIDE
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Date: ${plant.date.day}/${plant.date.month}/${plant.date.year}",
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                            Text("Proba plante: $isPlantText", style: const TextStyle(fontSize: 11)),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 16),

                      // CARTE PRINCIPALE
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            // Header avec nom et confiance
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: const BoxDecoration(
                                color: Color(0xFFE8F5E9),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      plant.nom,
                                      style: const TextStyle(
                                        color: Color(0xFF1B5E20),
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF2E7D32),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      "$confidenceText confiance",
                                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(14),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Image
                                  if (imageFile != null)
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.file(
                                        imageFile,
                                        height: 180,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  else
                                    Container(
                                      height: 180,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                                    ),
                                  
                                  const SizedBox(height: 16),

                                  // Noms communs
                                  const Text(
                                    "Noms communs:",
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                  ),
                                  const SizedBox(height: 6),
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      plant.description.isNotEmpty ? plant.description : "Non disponible",
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),

                                  const SizedBox(height: 16),

                                  // Description Wiki
                                  const Text(
                                    "Description Wiki:",
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                  ),
                                  const SizedBox(height: 6),
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF9F9F9),
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(color: Colors.grey.withOpacity(0.2)),
                                    ),
                                    child: Text(
                                      (plant.wikiDescription != null && plant.wikiDescription!.isNotEmpty)
                                          ? plant.wikiDescription!
                                          : "Aucune description Wikipedia disponible.",
                                      style: const TextStyle(fontSize: 14, height: 1.5),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
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
                        onTap: () => _afficherDetails(plant, fileExists ? file : null),
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
