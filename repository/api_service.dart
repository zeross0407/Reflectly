// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class ApiService {
//   final String baseUrl;

//   ApiService({required this.baseUrl});

//   // Generic GET request
//   Future<T> get<T>(String endpoint, T Function(dynamic data) fromJson) async {
//     final response = await http.get(Uri.parse('$baseUrl/$endpoint'));

//     if (response.statusCode == 200) {
//       // Convert JSON response to Model using the provided fromJson method
//       return fromJson(json.decode(response.body));
//     } else {
//       throw Exception('Failed to load data');
//     }
//   }

//   // Generic POST request
//   Future<T> post<T>(String endpoint, Map<String, dynamic> body, T Function(dynamic data) fromJson) async {
//     final response = await http.post(
//       Uri.parse('$baseUrl/$endpoint'),
//       headers: {'Content-Type': 'application/json'},
//       body: json.encode(body),
//     );
// print("Fetching");
//     if (response.statusCode == 200 || response.statusCode == 201) {
//       return fromJson(json.decode(response.body));
//     } else if(response.statusCode == 400 || response.statusCode == 401){
//       throw Exception('Incorrect Info');
//     }
//     else{
//       throw Exception('Unknown Error , Please try again later');
//     }
//   }

//   // Generic PUT request
//   Future<T> put<T>(String endpoint, Map<String, dynamic> body, T Function(dynamic data) fromJson) async {
//     final response = await http.put(
//       Uri.parse('$baseUrl/$endpoint'),
//       headers: {'Content-Type': 'application/json'},
//       body: json.encode(body),
//     );

//     if (response.statusCode == 200) {
//       return fromJson(json.decode(response.body));
//     } else {
//       throw Exception('Failed to update data');
//     }
//   }

//   // Generic DELETE request
//   Future<void> delete(String endpoint) async {
//     final response = await http.delete(Uri.parse('$baseUrl/$endpoint'));

//     if (response.statusCode != 200) {
//       throw Exception('Failed to delete data');
//     }
//   }
// }
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

  // Generic GET request
  Future<T> get<T>(String endpoint, T Function(dynamic data) fromJson, {String? token}) async {
    final response = await http.get(
      Uri.parse('$baseUrl/$endpoint'),
      headers: _buildHeaders(token),
    );

    if (response.statusCode == 200) {
      // Convert JSON response to Model using the provided fromJson method
      return fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }

  // Generic POST request
  Future<T> post<T>(String endpoint, Map<String, dynamic> body, T Function(dynamic data) fromJson, {String? token}) async {
    final response = await http.post(
      Uri.parse('$baseUrl/$endpoint'),
      headers: _buildHeaders(token),
      body: json.encode(body),
    );
    print("Fetching");
    if (response.statusCode == 200 || response.statusCode == 201) {
      return fromJson(json.decode(response.body));
    } else if (response.statusCode == 400 || response.statusCode == 401) {
      throw Exception('Incorrect Info');
    } else {
      throw Exception('Unknown Error, Please try again later');
    }
  }

  // Generic PUT request
  Future<T> put<T>(String endpoint, Map<String, dynamic> body, T Function(dynamic data) fromJson, {String? token}) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$endpoint'),
      headers: _buildHeaders(token),
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      return fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update data');
    }
  }

  // Generic DELETE request
  Future<void> delete(String endpoint, {String? token}) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$endpoint'),
      headers: _buildHeaders(token),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete data');
    }
  }

  // Helper method to build headers with or without token
  Map<String, String> _buildHeaders(String? token) {
    final headers = {'Content-Type': 'application/json'};
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }
}
