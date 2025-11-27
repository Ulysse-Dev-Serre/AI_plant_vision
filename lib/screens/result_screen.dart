// PERSONNE A - Écran de résultat amélioré
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:intl/intl.dart'; // Pour la date
import '../services/storage_service.dart';
import '../utils/app_logger.dart';

class ResultScreen extends StatelessWidget {
  final String nomPlante;
  final String description; // Noms communs
  final File image;
  final String? wikiDescription;
  final double confiance;
  final double? isPlantProbability;

  const ResultScreen({
    Key? key,
    required this.nomPlante,
    required this.description,
    required this.image,
    this.wikiDescription,
    this.confiance = 0.0,
    this.isPlantProbability,
  }) : super(key: key);

  // Fonction pour sauvegarder la plante
  Future<void> _sauvegarder(BuildContext context) async {
    try {
      AppLogger.info("Clic bouton Sauvegarder - Plante: $nomPlante");
      
      final storageService = StorageService();
      await storageService.sauvegarderPlante(
        nomPlante, 
        description, 
        image,
        wikiDescription: wikiDescription,
        confiance: confiance,
        isPlantProbability: isPlantProbability,
      );
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Plante sauvegardée avec succès !')),
        );
        // Retourner à l'écran précédent (CameraScreen)
        Navigator.pop(context);
      }
    } catch (e) {
      AppLogger.error("Erreur UI lors de la sauvegarde", e);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de la sauvegarde : $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Formatage de la date du jour
    final String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    
    // Formatage de la confiance
    final String confidenceText = "${(confiance * 100).toStringAsFixed(1)}%";
    
    // Formatage proba plante
    final String isPlantText = isPlantProbability != null 
        ? "${(isPlantProbability! * 100).toStringAsFixed(1)}%" 
        : "--%";

    return Scaffold(
      backgroundColor: const Color(0xFFF5F8F1), // Fond clair comme la maquette
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1B5E20)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.eco, color: Color(0xFF4CAF50)), // Petite feuille
            SizedBox(width: 8),
            Text(
              "Résultat Analyse Vision Plante",
              style: TextStyle(
                color: Color(0xFF1B5E20),
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // BARRE D'INFO RAPIDE
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 3,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Date: $formattedDate", style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text("Probabilité plante: $isPlantText", style: const TextStyle(fontSize: 12)),
                    const Text("Images: 1", style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),

              // CARTE PRINCIPALE
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // HEADER CARTE (Nom + Confiance)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        color: Color(0xFFE8F5E9), // Vert très clair
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
                              nomPlante,
                              style: const TextStyle(
                                color: Color(0xFF1B5E20),
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2E7D32),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              "$confidenceText de confiance",
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // SECTION IMAGE ET DETAILS
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // IMAGE (gauche)
                              Expanded(
                                flex: 4,
                                child: Column(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.file(
                                        image,
                                        height: 180,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      "Image analysée",
                                      style: TextStyle(fontSize: 10, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                              
                              const SizedBox(width: 16),
                              
                              // DETAILS (droite)
                              Expanded(
                                flex: 5,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Détails",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF333333),
                                      ),
                                    ),
                                    const Divider(),
                                    const SizedBox(height: 8),
                                    const Text(
                                      "Noms communs:",
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 4),
                                    Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        description.isNotEmpty ? description : "Non disponible",
                                        style: const TextStyle(fontSize: 13),
                                      ),
                                    ),
                                    
                                    // Cartes Info simulées (Lumière/Arrosage)
                                    const SizedBox(height: 16),
                                    _buildInfoRow(Icons.wb_sunny, "Lumière", "Soleil / Mi-ombre"),
                                    const SizedBox(height: 8),
                                    _buildInfoRow(Icons.water_drop, "Arrosage", "Régulier"),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),
                          
                          // DESCRIPTION WIKI (En bas de la photo comme demandé)
                          if (wikiDescription != null && wikiDescription!.isNotEmpty) ...[
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF9F9F9),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey.withOpacity(0.2)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Description Wiki:",
                                    style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2F3E46)),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    wikiDescription!,
                                    style: const TextStyle(fontSize: 14, height: 1.4, color: Colors.black87),
                                  ),
                                ],
                              ),
                            ),
                          ] else ...[
                             const Text("Aucune description Wiki disponible.", style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey)),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 30),
              
              // ACTIONS
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.refresh),
                    label: const Text("Nouvelle"),
                    style: OutlinedButton.styleFrom(foregroundColor: Colors.grey[700]),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _sauvegarder(context),
                    icon: const Icon(Icons.save_alt),
                    label: const Text("Sauvegarder"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1B5E20),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.orange),
        const SizedBox(width: 6),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.black87, fontSize: 12),
              children: [
                TextSpan(text: "$title: ", style: const TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: value),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
