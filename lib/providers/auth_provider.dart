import 'package:agent_app_belle_house_immobilier/models/user.dart';
import 'package:agent_app_belle_house_immobilier/services/api_services.dart';
import 'package:agent_app_belle_house_immobilier/services/storage_services.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();

  User? _currentUser;
  String? _token;
  bool _isLoading = false;
  String? _error;

  // Getters
  User? get currentUser => _currentUser;
  String? get token => _token;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _token != null && _currentUser != null;

  // Initialize - Check if user is already logged in
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      _token = await _storageService.getToken();
      final userData = await _storageService.getUserData();

      if (_token != null && userData != null) {
        _currentUser = User.fromJson(userData);
      }
    } catch (e) {
      _error = 'Failed to initialize auth: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Login
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.login(email, password);

      if (response.success && response.data != null) {
        _token = response.data['token'];
        _currentUser = User.fromJson(response.data['user']);

        // Save to local storage
        await _storageService.saveToken(_token!);
        await _storageService.saveUserData(_currentUser!.toJson());

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = response.message ?? 'Login failed';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Login error: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      if (_token != null) {
        await _apiService.logout(_token!);
      }
    } catch (e) {
      // Continue with logout even if API call fails
      print('Logout API error: $e');
    } finally {
      // Clear local data
      await _storageService.clearAll();
      _currentUser = null;
      _token = null;
      _error = null;
      _isLoading = false;
      notifyListeners();
    }
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Update user data
  void updateUser(User user) {
    _currentUser = user;
    _storageService.saveUserData(user.toJson());
    notifyListeners();
  }
}
