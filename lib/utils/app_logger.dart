class AppLogger {
  static const String _prefix = '🌱';
  
  // Logs de succès (opérations réussies)
  static void success(String message) {
    print('$_prefix ✅ SUCCESS: $message');
  }
  
  // Logs d'information (étapes importantes)
  static void info(String message) {
    print('$_prefix ℹ️  INFO: $message');
  }
  
  // Logs d'erreur
  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    print('$_prefix ❌ ERROR: $message');
    if (error != null) print('   └─ Details: $error');
    if (stackTrace != null) print('   └─ Stack: $stackTrace');
  }
  
  // Logs de debug (données techniques)
  static void debug(String message, [dynamic data]) {
    print('$_prefix 🐛 DEBUG: $message');
    if (data != null) print('   └─ Data: $data');
  }
  
  // Logs d'avertissement
  static void warning(String message) {
    print('$_prefix ⚠️  WARNING: $message');
  }
  
  // Logs pour Firestore spécifiquement
  static void firestore(String action, {String? collection, String? docId, dynamic data}) {
    print('$_prefix 🔥 FIRESTORE: $action');
    if (collection != null) print('   └─ Collection: $collection');
    if (docId != null) print('   └─ Doc ID: $docId');
    if (data != null) print('   └─ Data: $data');
  }
  
  // Logs pour les fichiers
  static void file(String action, String path) {
    print('$_prefix 📁 FILE: $action');
    print('   └─ Path: $path');
  }
}
