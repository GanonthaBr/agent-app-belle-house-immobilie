import 'dart:async';

import 'package:flutter/material.dart';

class LoadingProvider extends ChangeNotifier {
  // Global loading states
  final Map<String, bool> _loadingStates = {};
  final Map<String, String> _loadingMessages = {};

  // Overall loading state
  bool _isGlobalLoading = false;
  String? _globalMessage;

  // Getters
  bool get isGlobalLoading => _isGlobalLoading;
  String? get globalMessage => _globalMessage;

  // Get all loading states
  Map<String, bool> get loadingStates => Map.unmodifiable(_loadingStates);
  Map<String, String> get loadingMessages => Map.unmodifiable(_loadingMessages);

  // Check if any operation is loading
  bool get isAnyLoading =>
      _loadingStates.values.any((loading) => loading == true) ||
      _isGlobalLoading;

  // Set global loading state
  void setGlobalLoading(bool loading, {String? message}) {
    _isGlobalLoading = loading;
    _globalMessage = message;
    notifyListeners();
  }

  // Set specific loading state
  void setLoading(String key, bool loading, {String? message}) {
    if (loading) {
      _loadingStates[key] = true;
      if (message != null) {
        _loadingMessages[key] = message;
      }
    } else {
      _loadingStates.remove(key);
      _loadingMessages.remove(key);
    }
    notifyListeners();
  }

  // Check if specific operation is loading
  bool isLoading(String key) {
    return _loadingStates[key] ?? false;
  }

  // Get loading message for specific operation
  String? getLoadingMessage(String key) {
    return _loadingMessages[key];
  }

  // Clear specific loading state
  void clearLoading(String key) {
    _loadingStates.remove(key);
    _loadingMessages.remove(key);
    notifyListeners();
  }

  // Clear all loading states
  void clearAllLoading() {
    _loadingStates.clear();
    _loadingMessages.clear();
    _isGlobalLoading = false;
    _globalMessage = null;
    notifyListeners();
  }

  // Predefined loading keys for consistency
  static const String authLogin = 'auth_login';
  static const String authLogout = 'auth_logout';
  static const String fetchHouses = 'fetch_houses';
  static const String addHouse = 'add_house';
  static const String updateHouse = 'update_house';
  static const String deleteHouse = 'delete_house';
  static const String fetchLands = 'fetch_lands';
  static const String addLand = 'add_land';
  static const String updateLand = 'update_land';
  static const String deleteLand = 'delete_land';
  static const String uploadImage = 'upload_image';
  static const String uploadMultipleImages = 'upload_multiple_images';
  static const String fetchProfile = 'fetch_profile';
  static const String updateProfile = 'update_profile';
  static const String initialization = 'initialization';

  // Convenience methods for common operations
  void setAuthLoading(bool loading) {
    setLoading(authLogin, loading,
        message: loading ? 'Connexion en cours...' : null);
  }

  void setHousesLoading(bool loading) {
    setLoading(fetchHouses, loading,
        message: loading ? 'Chargement des maisons...' : null);
  }

  void setLandsLoading(bool loading) {
    setLoading(fetchLands, loading,
        message: loading ? 'Chargement des terrains...' : null);
  }

  void setImageUploadLoading(bool loading, {int? current, int? total}) {
    String? message;
    if (loading && current != null && total != null) {
      message = 'Upload des images... ($current/$total)';
    } else if (loading) {
      message = 'Upload en cours...';
    }
    setLoading(uploadImage, loading, message: message);
  }

  void setProfileLoading(bool loading) {
    setLoading(fetchProfile, loading,
        message: loading ? 'Chargement du profil...' : null);
  }

  void setInitializationLoading(bool loading) {
    setLoading(initialization, loading,
        message: loading ? 'Initialisation...' : null);
  }

  // Batch operations
  void setMultipleLoading(Map<String, bool> states) {
    states.forEach((key, loading) {
      if (loading) {
        _loadingStates[key] = true;
      } else {
        _loadingStates.remove(key);
        _loadingMessages.remove(key);
      }
    });
    notifyListeners();
  }

  // Get current loading operations as a list
  List<String> get currentLoadingOperations {
    return _loadingStates.entries
        .where((entry) => entry.value == true)
        .map((entry) => entry.key)
        .toList();
  }

  // Get current loading messages as a list
  List<String> get currentLoadingMessages {
    return _loadingMessages.values.toList();
  }

  // Check if multiple operations are loading
  bool areMultipleLoading(List<String> keys) {
    return keys.any((key) => isLoading(key));
  }

  // Check if all operations are loading
  bool areAllLoading(List<String> keys) {
    return keys.every((key) => isLoading(key));
  }

  // Execute operation with loading state
  Future<T> executeWithLoading<T>(
    String key,
    Future<T> Function() operation, {
    String? loadingMessage,
    String? successMessage,
    String? errorMessage,
  }) async {
    try {
      setLoading(key, true, message: loadingMessage);
      final result = await operation();
      setLoading(key, false);
      return result;
    } catch (e) {
      setLoading(key, false);
      rethrow;
    }
  }

  // Execute multiple operations with loading states
  Future<List<T>> executeMultipleWithLoading<T>(
    Map<String, Future<T> Function()> operations,
  ) async {
    final List<Future<T>> futures = [];

    operations.forEach((key, operation) {
      setLoading(key, true);
      futures.add(operation().whenComplete(() => setLoading(key, false)));
    });

    try {
      return await Future.wait(futures);
    } catch (e) {
      // Clear all loading states on error
      operations.keys.forEach((key) => setLoading(key, false));
      rethrow;
    }
  }

  // Debounced loading (useful for search operations)
  Timer? _debounceTimer;

  void setDebouncedLoading(
    String key,
    bool loading, {
    Duration delay = const Duration(milliseconds: 300),
    String? message,
  }) {
    _debounceTimer?.cancel();

    if (loading) {
      setLoading(key, true, message: message);
    } else {
      _debounceTimer = Timer(delay, () {
        setLoading(key, false);
      });
    }
  }

  // Progress tracking for long operations
  final Map<String, double> _progressStates = {};

  double getProgress(String key) {
    return _progressStates[key] ?? 0.0;
  }

  void setProgress(String key, double progress, {String? message}) {
    _progressStates[key] = progress.clamp(0.0, 1.0);
    if (progress > 0 && progress < 1) {
      setLoading(key, true, message: message);
    } else if (progress >= 1) {
      setLoading(key, false);
      _progressStates.remove(key);
    }
    notifyListeners();
  }

  void clearProgress(String key) {
    _progressStates.remove(key);
    notifyListeners();
  }

  Map<String, double> get progressStates => Map.unmodifiable(_progressStates);

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}
