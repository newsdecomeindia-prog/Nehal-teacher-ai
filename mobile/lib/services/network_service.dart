import 'dart:async';

/// Network State Manager for handling online/offline transitions and caching responses.
class NetworkService {
  bool _isOnline = true;
  final _controller = StreamController<bool>.broadcast();

  bool get isOnline => _isOnline;
  Stream<bool> get onConnectivityChanged => _controller.stream;

  void setOnlineStatus(bool online) {
    _isOnline = online;
    _controller.add(_isOnline);
  }

  /// Safe API call wrapper with offline fallback handling
  Future<T> executeWithOfflineFallback<T>({
    required Future<T> Function() apiCall,
    required T Function() offlineFallback,
  }) async {
    if (!_isOnline) {
      return offlineFallback();
    }
    try {
      return await apiCall();
    } catch (e) {
      // On network failure, fall back to cached/offline response
      return offlineFallback();
    }
  }

  void dispose() {
    _controller.close();
  }
}
