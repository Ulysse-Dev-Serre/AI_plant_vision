// PERSONNE A - Écran de capture photo
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../services/vision_api.dart';
import 'result_screen.dart';
import 'history_screen.dart';

import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'dart:convert'; // Pour lire le manifeste des assets
import '../utils/app_logger.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  File? _image;
  final VisionApiService _visionService = VisionApiService();
  bool _isLoading = false;

  // Fonction pour sélectionner une image (Caméra ou Galerie)
  Future<void> _selectionnerImage(ImageSource source) async {
    AppLogger.debug("Ouverture du sélecteur d'image (${source == ImageSource.camera ? 'Caméra' : 'Galerie'})");
    
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(
        source: source,
        maxWidth: 1080,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        AppLogger.info("Image sélectionnée : ${pickedFile.path}");
        setState(() {
          _image = File(pickedFile.path);
        });
      } else {
        AppLogger.debug("Sélection d'image annulée par l'utilisateur");
      }
    } catch (e) {
      AppLogger.error("Erreur lors de la sélection d'image", e);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de la sélection: $e')),
        );
      }
    }
  }

  // Fonction pour analyser la plante
  Future<void> _analyserPlante() async {
    if (_image == null) return;

    AppLogger.info("Lancement de l'analyse...");

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _visionService.analyzerPlante(_image!);
      
      AppLogger.success("Analyse terminée. Résultat : ${result['nom']}");
      
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ResultScreen(
              nomPlante: result['nom'] ?? "Inconnu",
              description: result['description'] ?? "",
              image: _image!,
              wikiDescription: result['wikiDescription'],
              confiance: result['confiance'] ?? 0.0,
              isPlantProbability: result['isPlantProbability'],
            ),
          ),
        );
      }
    } catch (e) {
      AppLogger.error("Erreur lors de l'analyse UI", e);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de l\'analyse: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Fonction pour ouvrir la galerie de test (fichiers locaux)
  Future<void> _ouvrirGalerieTest() async {
    AppLogger.debug("Ouverture de la galerie de test");
    List<String> imagePaths = [];
    
    try {
      // Tentative 1: Lire le manifeste standard (AssetManifest.json)
      try {
        final manifestContent = await rootBundle.loadString('AssetManifest.json');
        final Map<String, dynamic> manifestMap = json.decode(manifestContent);
        imagePaths = manifestMap.keys
            .where((String key) => key.startsWith('test_assets/') && 
                                  (key.endsWith('.jpg') || key.endsWith('.png') || key.endsWith('.jpeg')))
            .toList();
        AppLogger.debug("${imagePaths.length} images trouvées dans le manifeste");
      } catch (e) {
        AppLogger.warning("Manifest JSON non trouvé, passage au mode manuel/fallback");
        // Fallback: Si le manifeste échoue (Flutter récent ou Hot Reload), on met les fichiers connus
        imagePaths = [
          'test_assets/plant_test2.jpg',
          'test_assets/plant_test3.jpg',
          'test_assets/plant_test4.jpg',
          // Ajoutez vos futurs fichiers ici manuellement si le scan auto échoue
        ];
      }

      if (!mounted) return;

      // 2. Afficher une "Bottom Sheet" avec la grille d'images
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 400,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Galerie de Test",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: imagePaths.isEmpty
                      ? const Center(child: Text("Aucune image trouvée dans test_assets/"))
                      : GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          itemCount: imagePaths.length,
                          itemBuilder: (context, index) {
                            final assetPath = imagePaths[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.pop(context); // Fermer la galerie
                                _convertirAssetEnFichier(assetPath); // Charger l'image
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  assetPath,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        },
      );
    } catch (e) {
      AppLogger.error("Erreur chargement galerie test", e);
    }
  }

  // Convertit un asset en File utilisable par l'API
  Future<void> _convertirAssetEnFichier(String assetPath) async {
    AppLogger.debug("Conversion asset vers fichier : $assetPath");
    try {
      final directory = await getTemporaryDirectory();
      // On crée un nom de fichier unique basé sur le chemin de l'asset
      final fileName = assetPath.split('/').last;
      final file = File('${directory.path}/$fileName');

      final byteData = await rootBundle.load(assetPath);
      await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

      setState(() {
        _image = file;
      });
      
      AppLogger.success("Image de test chargée");
      
    } catch (e) {
      AppLogger.error("Erreur conversion asset", e);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur conversion asset: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vision Plante 🌿'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HistoryScreen()),
              );
            },
            tooltip: "Historique",
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              const Text(
                "Identifiez votre plante en un clic",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B5E20),
                ),
              ),
              const SizedBox(height: 40),
              // Afficher l'image si _image != null, sinon afficher une icône
              if (_image != null)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          _image!,
                          height: 300,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      // Bouton pour supprimer l'image sélectionnée
                      Positioned(
                        top: 10,
                        right: 10,
                        child: CircleAvatar(
                          backgroundColor: Colors.black54,
                          child: IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: () {
                              setState(() {
                                _image = null;
                                // On réinitialise aussi le chargement si jamais
                                _isLoading = false;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              else
                Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.image_search, // Icône changée pour refléter le choix multiple
                    size: 80,
                    color: Colors.grey[400],
                  ),
                ),
              
              const SizedBox(height: 30),
              
              // Row pour les deux boutons : Caméra et Galerie
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Bouton Caméra
                  ElevatedButton.icon(
                    onPressed: _isLoading ? null : () => _selectionnerImage(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text("Caméra"),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                  ),
                  
                  const SizedBox(width: 20),
                  
                  // Bouton Galerie
                  ElevatedButton.icon(
                    onPressed: _isLoading ? null : () => _selectionnerImage(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library),
                    label: const Text("Galerie"),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      backgroundColor: Colors.white, // Style différent pour distinguer
                      foregroundColor: Colors.green,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 20),

              // Bouton DEBUG pour charger une image de test sans drag & drop
              TextButton.icon(
                onPressed: _isLoading ? null : _ouvrirGalerieTest,
                icon: const Icon(Icons.bug_report),
                label: const Text("Ouvrir Galerie de Test"),
                style: TextButton.styleFrom(foregroundColor: Colors.grey),
              ),
              
              const SizedBox(height: 10),
              
              // Bouton "Analyser" (visible seulement si _image != null)
              if (_image != null)
                if (_isLoading)
                  const CircularProgressIndicator()
                else
                  ElevatedButton.icon(
                    onPressed: _analyserPlante,
                    icon: const Icon(Icons.search),
                    label: const Text("Analyser la plante"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
