import 'dart:convert';
import 'package:http/http.dart' as http;

class MyHttpHelper {
  static const String _baseUrl = 'http://127.0.0.1:4000';

  static Future<Map<String, dynamic>> get(String endpoint) async {
    final response = await http.get(Uri.parse('$_baseUrl/$endpoint'));
    return _handleResponse(response);
  }

  static Future<http.Response> getAuthorized(String endpoint, String token) async {
    final response = await http.get(Uri.parse('$_baseUrl/$endpoint'),
        headers: {'authorization': token}
    );
    return response;
  }

  static Future<http.Response> getAllAuthorized(String endpoint, String token) async {
    final response = await http.get(Uri.parse('$_baseUrl/$endpoint'),
        headers: {'authorization': token}
    );
    return response;
  }

  static Future<Map<String, dynamic>> post(
      String endpoint, dynamic data) async {
    final response = await http.post(Uri.parse('$_baseUrl/$endpoint'),
        headers: {'Content-Type': 'application/json'}, body: json.encode(data));
    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> postAuthorized(
      String endpoint, dynamic data, String token) async {
    final response = await http.post(Uri.parse('$_baseUrl/$endpoint'),
        headers:
        {'authorization': token,
          'Content-Type': 'application/json',
        },
        body: json.encode(data));
    return _handleResponse(response);
  }


  static Future<Map<String, dynamic>> put(String endpoint, dynamic data) async {
    final response = await http.put(Uri.parse('$_baseUrl/$endpoint'),
        headers: {'Content-Type': 'application/json'}, body: json.encode(data));
    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> delete(
      String endpoint, String token) async {
    Map<String, String> header = {'authorization': token};
    final response = await http.delete(
        Uri.parse('$_baseUrl/$endpoint'),
        headers: header
    );
    return _handleResponse(response);
  }

  static Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }
}
