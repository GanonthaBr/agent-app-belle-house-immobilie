import 'package:agent_app_belle_house_immobilier/models/land.dart';
import 'package:agent_app_belle_house_immobilier/services/api_services.dart';
import 'package:flutter/material.dart';

class LandProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Land> _lands = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Land> get lands => _lands;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get landsCount => _lands.length;

  // Get lands by type
  List<Land> get landsForSale =>
      _lands.where((l) => l.typeOfContract == 'sale').toList();
  List<Land> get landsForRent =>
      _lands.where((l) => l.typeOfContract == 'rent').toList();

  // Get lands by land type
  List<Land> get residentialLands =>
      _lands.where((l) => l.landType == 'residential').toList();
  List<Land> get commercialLands =>
      _lands.where((l) => l.landType == 'commercial').toList();
  List<Land> get agriculturalLands =>
      _lands.where((l) => l.landType == 'agricultural').toList();

  // Fetch all lands
  Future<void> fetchLands(String token) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.getLands(token);

      if (response.success && response.data != null) {
        _lands = response.data!;
      } else {
        _error = response.message ?? 'Failed to fetch lands';
      }
    } catch (e) {
      _error = 'Network error: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add new land
  Future<bool> addLand(Land land, String token) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.createLand(land, token);

      if (response.success && response.data != null) {
        _lands.add(response.data!);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = response.message ?? 'Failed to add land';
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

  // Update land
  Future<bool> updateLand(Land land, String token) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.updateLand(land, token);

      if (response.success && response.data != null) {
        final index = _lands.indexWhere((l) => l.id == land.id);
        if (index != -1) {
          _lands[index] = response.data!;
        }
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = response.message ?? 'Failed to update land';
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

  // Delete land
  Future<bool> deleteLand(int landId, String token) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.deleteLand(landId, token);

      if (response.success) {
        _lands.removeWhere((l) => l.id == landId);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = response.message ?? 'Failed to delete land';
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

  // Get land by ID
  Land? getLandById(int id) {
    try {
      return _lands.firstWhere((land) => land.id == id);
    } catch (e) {
      return null;
    }
  }

  // Search lands
  List<Land> searchLands(String query) {
    if (query.isEmpty) return _lands;

    return _lands.where((land) {
      return land.name.toLowerCase().contains(query.toLowerCase()) ||
          land.area.toLowerCase().contains(query.toLowerCase()) ||
          land.description.toLowerCase().contains(query.toLowerCase()) ||
          land.landType.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  // Filter lands by area
  List<Land> getLandsByArea(String area) {
    return _lands
        .where((land) => land.area.toLowerCase().contains(area.toLowerCase()))
        .toList();
  }

  // Filter lands by price range
  List<Land> getLandsByPriceRange(double minPrice, double maxPrice) {
    return _lands
        .where((land) => land.price >= minPrice && land.price <= maxPrice)
        .toList();
  }

  // Filter lands by size range
  List<Land> getLandsBySizeRange(double minSize, double maxSize) {
    return _lands
        .where((land) => land.size >= minSize && land.size <= maxSize)
        .toList();
  }

  // Filter lands by land type
  List<Land> getLandsByType(String landType) {
    return _lands
        .where((land) => land.landType.toLowerCase() == landType.toLowerCase())
        .toList();
  }

  // Get statistics
  Map<String, dynamic> getStatistics() {
    if (_lands.isEmpty) {
      return {
        'totalLands': 0,
        'forSale': 0,
        'forRent': 0,
        'residential': 0,
        'commercial': 0,
        'agricultural': 0,
        'averagePrice': 0.0,
        'totalArea': 0.0,
      };
    }

    final forSale = landsForSale.length;
    final forRent = landsForRent.length;
    final residential = residentialLands.length;
    final commercial = commercialLands.length;
    final agricultural = agriculturalLands.length;

    final totalPrice = _lands.fold<double>(0, (sum, land) => sum + land.price);
    final averagePrice = totalPrice / _lands.length;

    final totalArea = _lands.fold<double>(0, (sum, land) => sum + land.size);

    return {
      'totalLands': _lands.length,
      'forSale': forSale,
      'forRent': forRent,
      'residential': residential,
      'commercial': commercial,
      'agricultural': agricultural,
      'averagePrice': averagePrice,
      'totalArea': totalArea,
    };
  }

  // Sort lands
  void sortLands(String sortBy, {bool ascending = true}) {
    switch (sortBy.toLowerCase()) {
      case 'name':
        _lands.sort((a, b) =>
            ascending ? a.name.compareTo(b.name) : b.name.compareTo(a.name));
        break;
      case 'price':
        _lands.sort((a, b) => ascending
            ? a.price.compareTo(b.price)
            : b.price.compareTo(a.price));
        break;
      case 'size':
        _lands.sort((a, b) =>
            ascending ? a.size.compareTo(b.size) : b.size.compareTo(a.size));
        break;
      case 'area':
        _lands.sort((a, b) =>
            ascending ? a.area.compareTo(b.area) : b.area.compareTo(a.area));
        break;
      case 'date':
        _lands.sort((a, b) {
          final aDate = a.createdAt ?? DateTime.now();
          final bDate = b.createdAt ?? DateTime.now();
          return ascending ? aDate.compareTo(bDate) : bDate.compareTo(aDate);
        });
        break;
      default:
        // Default sort by name
        _lands.sort((a, b) =>
            ascending ? a.name.compareTo(b.name) : b.name.compareTo(a.name));
    }
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Refresh lands
  Future<void> refreshLands(String token) async {
    await fetchLands(token);
  }

  // Toggle land status (active/inactive)
  Future<bool> toggleLandStatus(int landId, String token) async {
    try {
      final land = getLandById(landId);
      if (land == null) return false;

      final updatedLand = land.copyWith(isActive: !land.isActive);
      return await updateLand(updatedLand, token);
    } catch (e) {
      _error = 'Error toggling land status: $e';
      notifyListeners();
      return false;
    }
  }

  // Bulk operations
  Future<bool> deleteMultipleLands(List<int> landIds, String token) async {
    bool allSuccess = true;

    for (int landId in landIds) {
      final success = await deleteLand(landId, token);
      if (!success) {
        allSuccess = false;
      }
    }

    return allSuccess;
  }

  // Get lands by multiple filters
  List<Land> getFilteredLands({
    String? contractType,
    String? landType,
    String? area,
    double? minPrice,
    double? maxPrice,
    double? minSize,
    double? maxSize,
    bool? isActive,
  }) {
    return _lands.where((land) {
      bool matches = true;

      if (contractType != null && land.typeOfContract != contractType) {
        matches = false;
      }

      if (landType != null && land.landType != landType) {
        matches = false;
      }

      if (area != null &&
          !land.area.toLowerCase().contains(area.toLowerCase())) {
        matches = false;
      }

      if (minPrice != null && land.price < minPrice) {
        matches = false;
      }

      if (maxPrice != null && land.price > maxPrice) {
        matches = false;
      }

      if (minSize != null && land.size < minSize) {
        matches = false;
      }

      if (maxSize != null && land.size > maxSize) {
        matches = false;
      }

      if (isActive != null && land.isActive != isActive) {
        matches = false;
      }

      return matches;
    }).toList();
  }
}
