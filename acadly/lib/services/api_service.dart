import "dart:convert";
import 'package:http/http.dart' as http;

class ApiService{
  static const String baseUrl = "http://localhost:3000";

  static Future<Map<String , dynamic>> login(String email, String password) async{
    final url = Uri.parse("$baseUrl/api/user/login");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body); // success
    } else {
      throw Exception("Login failed: ${response.body}");
    }
  }
}