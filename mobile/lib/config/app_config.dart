import 'package:flutter/foundation.dart';

/// Centralized configuration manager for Nehal Ki Teacher AI mobile application.
/// Provides dynamic base URL resolution to ensure Flutter app reaches FastAPI backend
/// whether running on Android Emulator (10.0.2.2), physical Android device over Wi-Fi,
/// or Web/Desktop (localhost).
class AppConfig {
  static String? _customBaseUrl;

  /// Retrieves the active API base URL.
  /// Precedence:
  /// 1. Custom runtime override set via App Settings dialog.
  /// 2. Compile-time environment variable specified via --dart-define=BACKEND_URL=...
  /// 3. Platform default:
  ///    - Android target platform -> 'http://10.0.2.2:8000/api/v1'
  ///    - iOS / Web / Desktop -> 'http://localhost:8000/api/v1'
  static String get baseUrl {
    if (_customBaseUrl != null && _customBaseUrl!.isNotEmpty) {
      return _customBaseUrl!;
    }

    const envUrl = String.fromEnvironment('BACKEND_URL');
    if (envUrl.isNotEmpty) {
      return envUrl;
    }

    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:8000/api/v1';
    }

    return 'http://localhost:8000/api/v1';
  }

  /// Override the API base URL dynamically at runtime (e.g. from AppBar host config dialog).
  static void setCustomBaseUrl(String url) {
    var trimmed = url.trim();
    if (trimmed.endsWith('/')) {
      trimmed = trimmed.substring(0, trimmed.length - 1);
    }
    if (!trimmed.endsWith('/api/v1') && !trimmed.contains('/api/')) {
      trimmed = '$trimmed/api/v1';
    }
    _customBaseUrl = trimmed;
  }

  /// Reset back to default auto-detected base URL.
  static void resetBaseUrl() {
    _customBaseUrl = null;
  }
}
