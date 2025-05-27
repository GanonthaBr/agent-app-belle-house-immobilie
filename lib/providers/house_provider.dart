import 'package:agent_app_belle_house_immobilier/models/house.dart';
import 'package:agent_app_belle_house_immobilier/services/api_services.dart';
import 'package:flutter/material.dart';

class HouseProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<House> _houses = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<House> get houses => _houses;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get housesCount => _houses.length;

  // Get houses by type
  List<House> get housesForSale =>
      _houses.where((h) => h.typeOfContract == 'sale').toList();
  List<House> get housesForRent =>
      _houses.where((h) => h.typeOfContract == 'rent').toList();

  // Fetch all houses
  Future<void> fetchHouses(String token) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.getHouses(token);

      if (response.success && response.data != null) {
        _houses = response.data!;
      } else {
        _error = response.message ?? 'Failed to fetch houses';
      }
    } catch (e) {
      _error = 'Network error: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add new house
  Future<bool> addHouse(House house, String token) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.createHouse(house, token);

      if (response.success && response.data != null) {
        _houses.add(response.data!);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = response.message ?? 'Failed to add house';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Network error: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Update house
  Future<bool> updateHouse(House house, String token) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.updateHouse(house, token);

      if (response.success && response.data != null) {
        final index = _houses.indexWhere((h) => h.id == house.id);
        if (index != -1) {
          _houses[index] = response.data!;
        }
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = response.message ?? 'Failed to update house';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Network error: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Delete house
  Future<bool> deleteHouse(int houseId, String token) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.deleteHouse(houseId, token);

      if (response.success) {
        _houses.removeWhere((h) => h.id == houseId);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = response.message ?? 'Failed to delete house';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Network error: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Get house by ID
  House? getHouseById(int id) {
    try {
      return _houses.firstWhere((house) => house.id == id);
    } catch (e) {
      return null;
    }
  }

  // Search houses
  List<House> searchHouses(String query) {
    if (query.isEmpty) return _houses;

    return _houses.where((house) {
      return house.name.toLowerCase().contains(query.toLowerCase()) ||
          house.area.toLowerCase().contains(query.toLowerCase()) ||
          house.description.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  // Filter houses by area
  List<House> getHousesByArea(String area) {
    return _houses
        .where((house) => house.area.toLowerCase().contains(area.toLowerCase()))
        .toList();
  }

  // Filter houses by price range
  List<House> getHousesByPriceRange(double minPrice, double maxPrice) {
    return _houses
        .where((house) => house.price >= minPrice && house.price <= maxPrice)
        .toList();
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Refresh houses
  Future<void> refreshHouses(String token) async {
    await fetchHouses(token);
  }
}
