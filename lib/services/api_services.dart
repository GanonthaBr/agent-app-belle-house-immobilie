import 'dart:convert';
import 'dart:io';
import 'package:agent_app_belle_house_immobilier/models/house.dart';
import 'package:agent_app_belle_house_immobilier/models/land.dart';
import 'package:agent_app_belle_house_immobilier/models/api_response_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // Base URL from environment variables
  String get baseUrl => 'http://localhost:8000/api';

  // Default headers
  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Headers with authentication token
  Map<String, String> _headersWithAuth(String token) => {
    ..._headers,
    'Authorization': 'Bearer $token',
  };

  // ===================
  // Authentication APIs
  // ===================

  Future<ApiResponse> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: _headers,
        body: json.encode({'email': email, 'password': password}),
      );

      return _handleResponse(response);
    } catch (e) {
      return ApiResponse.error('Network error: $e');
    }
  }

  Future<ApiResponse> logout(String token) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/logout'),
        headers: _headersWithAuth(token),
      );

      return _handleResponse(response);
    } catch (e) {
      return ApiResponse.error('Network error: $e');
    }
  }

  // ===================
  // Houses APIs
  // ===================

  Future<ApiResponse<List<House>>> getHouses(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/houses'),
        headers: _headersWithAuth(token),
      );

      final apiResponse = _handleResponse(response);
      if (apiResponse.success && apiResponse.data != null) {
        final List<dynamic> housesJson =
            apiResponse.data['results'] ?? apiResponse.data;
        final List<House> houses =
            housesJson.map((json) => House.fromJson(json)).toList();
        return ApiResponse.success(houses);
      }

      return ApiResponse.error(apiResponse.message!);
    } catch (e) {
      return ApiResponse.error('Network error: $e');
    }
  }

  Future<ApiResponse<House>> createHouse(House house, String token) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/houses'),
        headers: _headersWithAuth(token),
        body: json.encode(house.toJson()),
      );

      final apiResponse = _handleResponse(response);
      if (apiResponse.success && apiResponse.data != null) {
        final House createdHouse = House.fromJson(apiResponse.data);
        return ApiResponse.success(createdHouse);
      }

      return ApiResponse.error(apiResponse.message!);
    } catch (e) {
      return ApiResponse.error('Network error: $e');
    }
  }

  Future<ApiResponse<House>> updateHouse(House house, String token) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/houses/${house.id}'),
        headers: _headersWithAuth(token),
        body: json.encode(house.toJson()),
      );

      final apiResponse = _handleResponse(response);
      if (apiResponse.success && apiResponse.data != null) {
        final House updatedHouse = House.fromJson(apiResponse.data);
        return ApiResponse.success(updatedHouse);
      }

      return ApiResponse.error(apiResponse.message!);
    } catch (e) {
      return ApiResponse.error('Network error: $e');
    }
  }

  Future<ApiResponse> deleteHouse(int houseId, String token) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/houses/$houseId'),
        headers: _headersWithAuth(token),
      );

      return _handleResponse(response);
    } catch (e) {
      return ApiResponse.error('Network error: $e');
    }
  }

  // ===================
  // Lands APIs
  // ===================

  Future<ApiResponse<List<Land>>> getLands(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/lands'),
        headers: _headersWithAuth(token),
      );

      final apiResponse = _handleResponse(response);
      if (apiResponse.success && apiResponse.data != null) {
        final List<dynamic> landsJson =
            apiResponse.data['results'] ?? apiResponse.data;
        final List<Land> lands =
            landsJson.map((json) => Land.fromJson(json)).toList();
        return ApiResponse.success(lands);
      }

      return ApiResponse.error(apiResponse.message!);
    } catch (e) {
      return ApiResponse.error('Network error: $e');
    }
  }

  Future<ApiResponse<Land>> createLand(Land land, String token) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/lands'),
        headers: _headersWithAuth(token),
        body: json.encode(land.toJson()),
      );

      final apiResponse = _handleResponse(response);
      if (apiResponse.success && apiResponse.data != null) {
        final Land createdLand = Land.fromJson(apiResponse.data);
        return ApiResponse.success(createdLand);
      }

      return ApiResponse.error(apiResponse.message!);
    } catch (e) {
      return ApiResponse.error('Network error: $e');
    }
  }

  Future<ApiResponse<Land>> updateLand(Land land, String token) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/lands/${land.id}'),
        headers: _headersWithAuth(token),
        body: json.encode(land.toJson()),
      );

      final apiResponse = _handleResponse(response);
      if (apiResponse.success && apiResponse.data != null) {
        final Land updatedLand = Land.fromJson(apiResponse.data);
        return ApiResponse.success(updatedLand);
      }

      return ApiResponse.error(apiResponse.message!);
    } catch (e) {
      return ApiResponse.error('Network error: $e');
    }
  }

  Future<ApiResponse> deleteLand(int landId, String token) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/lands/$landId'),
        headers: _headersWithAuth(token),
      );

      return _handleResponse(response);
    } catch (e) {
      return ApiResponse.error('Network error: $e');
    }
  }

  // ===================
  // Image Upload API
  // ===================

  Future<ApiResponse<String>> uploadImage(File imageFile, String token) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/upload/image'),
      );

      request.headers.addAll(_headersWithAuth(token));
      request.files.add(
        await http.MultipartFile.fromPath('image', imageFile.path),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      final apiResponse = _handleResponse(response);
      if (apiResponse.success && apiResponse.data != null) {
        final String imageUrl =
            apiResponse.data['url'] ?? apiResponse.data['image_url'];
        return ApiResponse.success(imageUrl);
      }

      return ApiResponse.error(apiResponse.message!);
    } catch (e) {
      return ApiResponse.error('Upload error: $e');
    }
  }

  // ===================
  // Helper Methods
  // ===================

  ApiResponse _handleResponse(http.Response response) {
    try {
      final Map<String, dynamic> data = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return ApiResponse.success(data);
      } else {
        final String message =
            data['message'] ?? data['error'] ?? 'Unknown error';
        return ApiResponse.error(message);
      }
    } catch (e) {
      return ApiResponse.error('Failed to parse response: $e');
    }
  }
}
