import "dart:convert";
import 'package:http/http.dart' as http;
import 'config.dart';

class ApiService {
  static String baseUrl = ApiConfig.getBaseURL();

  static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final url = Uri.parse("$baseUrl/api/v1/user/login");
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );
      return _handleResponse(response, "Login failed");
    } catch (e) {
      return {"success": false, "message": "Network error: ${e.toString()}"};
    }
  }

  static Future<Map<String, dynamic>> register(
      String email, String username, String password) async {
    try {
      final url = Uri.parse("$baseUrl/api/v1/user/signup");
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "username": username,
          "password": password,
        }),
      );

      return _handleResponse(response, "Registration failed");
    } catch (e) {
      return {"success": false, "message": "Network error: ${e.toString()}"};
    }
  }

  static Map<String, dynamic> _handleResponse(
      http.Response response, String defaultError) {
    if (response.statusCode == 200) {
      try {
        final data = jsonDecode(response.body);
        if (!data.containsKey('success')) {
          data['success'] = true;
        }
        return data;
      } catch (e) {
        return {"success": false, "message": "Invalid server response"};
      }
    } else {
      return {
        "success": false,
        "message": _extractMessage(response.body) ?? defaultError,
      };
    }
  }

  static String? _extractMessage(String responseBody) {
    try {
      final data = jsonDecode(responseBody);
      return data['message'];
    } catch (e) {
      return null;
    }
  }
}
