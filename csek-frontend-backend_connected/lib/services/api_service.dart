import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://host.docker.internal:9500/user-requirements';

  // POST: Yeni User Requirement Ekle
  static Future<bool> postUserRequirement(String title, String description, String createdBy, bool flag) async {
    final url = Uri.parse('$baseUrl/requirements');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'title': title,
        'description': description,
        'createdBy': createdBy,
        'flag': flag,
      }),
    );
    return response.statusCode == 200 || response.statusCode == 201;
  }

  // POST: Yeni Attribute Ekle
  static Future<bool> postAttribute(String header, String userRequirementId, String description) async {
    final url = Uri.parse('$baseUrl/attributes');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'header': header,
        'userRequirementId': userRequirementId,
        'description': description,
      }),
    );
    return response.statusCode == 200 || response.statusCode == 201;
  }

  // POST: Yeni Header Ekle
  static Future<bool> postHeader(String header) async {
    final url = Uri.parse('$baseUrl/headers');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'header': header,
      }),
    );
    return response.statusCode == 200 || response.statusCode == 201;
  }

  // GET: User Requirements Çek
  static Future<List<dynamic>> fetchUserRequirements() async {
    final url = Uri.parse('$baseUrl/requirements');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('User Requirements çekilemedi');
    }
  }

  // GET: Attributes Çek
  static Future<List<dynamic>> fetchAttributes() async {
    final url = Uri.parse('$baseUrl/attributes');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Attributes çekilemedi');
    }
  }

  // GET: Headers Çek
  static Future<List<dynamic>> fetchHeaders() async {
    final url = Uri.parse('$baseUrl/headers');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Headers çekilemedi');
    }
  }

  // GET: Sistem Gereksinimleri
  static Future<List<dynamic>> fetchSystemRequirements() async {
    final url = Uri.parse('$baseUrl/requirements'); // aynı endpoint
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Sistem gereksinimleri çekilemedi');
    }
  }

// GET: Alt Başlık Gereksinimleri
  static Future<List<dynamic>> fetchSubRequirements() async {
    final url = Uri.parse('$baseUrl/requirements'); // aynı endpoint
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Alt başlık gereksinimleri çekilemedi');
    }
  }


}



