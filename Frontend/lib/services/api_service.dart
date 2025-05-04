import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://localhost:9500';


  // POST: Yeni User Requirement Ekle
  static Future<bool> postUserRequirement(String title, String description, String createdBy, bool flag) async {
    final url = Uri.parse('$baseUrl/user-requirements/user-requirements');
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

// POST: Yeni System Requirement Ekle
  static Future<bool> postSystemRequirement(String title, String description, String createdBy, bool flag, String urId) async {
    final url = Uri.parse('$baseUrl/system-requirements/system-requirements');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'title': title,
        'description': description,
        'createdBy': createdBy,
        'flag': flag,
        'user_req_id': urId
      }),
    );
    return response.statusCode == 200 || response.statusCode == 201;
  }

// POST: Yeni Subsystem 1 Requirement Ekle
  static Future<bool> postSub1Requirement(String title, String description, String createdBy, bool flag, String reqid) async {
    final url = Uri.parse('$baseUrl/subsystem-requirements/subsystem1');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'title': title,
        'description': description,
        'createdBy': createdBy,
        'flag': flag,
        'systemRequirementId': reqid
      }),
    );
    return response.statusCode == 200 || response.statusCode == 201;
  }

// POST: Yeni Subsystem 2 Requirement Ekle
  static Future<bool> postSub2Requirement(String title, String description, String createdBy, bool flag, String reqid) async {
    final url = Uri.parse('$baseUrl/subsystem-requirements/subsystem2');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'title': title,
        'description': description,
        'createdBy': createdBy,
        'flag': flag,
        'systemRequirementId': reqid
      }),
    );
    return response.statusCode == 200 || response.statusCode == 201;
  }

// POST: Yeni Subsystem 3 Requirement Ekle
  static Future<bool> postSub3Requirement(String title, String description, String createdBy, bool flag, String reqid) async {
    final url = Uri.parse('$baseUrl/subsystem-requirements/subsystem3');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'title': title,
        'description': description,
        'createdBy': createdBy,
        'flag': flag,
        'systemRequirementId': reqid
      }),
    );
    return response.statusCode == 200 || response.statusCode == 201;
  }


  // USER ATTRIBUTE POST
  static Future<bool> postUserAttribute(String header, String userRequirementId, String description) async {
    final url = Uri.parse('$baseUrl/user-requirements/attributes');
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

  // SYSTEM ATTRIBUTE POST
  static Future<bool> postSystemAttribute(String header, String requirementId, String description) async {
    final url = Uri.parse('$baseUrl/system-requirements/attributes');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'header': header,
        'systemRequirementId': requirementId,
        'description': description,
      }),
    );
    return response.statusCode == 200 || response.statusCode == 201;
  }

// SUBSYSTEM 1 ATTRIBUTE POST
  static Future<bool> postSub1Attribute(String header, String requirementId, String description) async {
    final url = Uri.parse('$baseUrl/subsystem-requirements/subsystem1-attributes');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'title': header,
        'subsystem1Id': requirementId,
        'description': description
      }),
    );
    return response.statusCode == 200 || response.statusCode == 201;
  }

// SUBSYSTEM 2 ATTRIBUTE POST
  static Future<bool> postSub2Attribute(String header, String requirementId, String description) async {
    final url = Uri.parse('$baseUrl/subsystem-requirements/subsystem2-attributes');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'title': header,
        'subsystem2Id': requirementId,
        'description': description
      }),
    );
    return response.statusCode == 200 || response.statusCode == 201;
  }

// SUBSYSTEM 3 ATTRIBUTE POST
  static Future<bool> postSub3Attribute(String header, String requirementId, String description) async {
    final url = Uri.parse('$baseUrl/subsystem-requirements/subsystem3-attributes');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'title': header,
        'subsystem3Id': requirementId,
        'description': description
      }),
    );
    return response.statusCode == 200 || response.statusCode == 201;
  }


  // POST: Kullanıcı Header
  static Future<bool> postUserHeader(String header) async {
    final url = Uri.parse('$baseUrl/user-requirements/headers');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'header': header}),
    );
    return response.statusCode == 200 || response.statusCode == 201;
  }

// POST: Sistem Header
  static Future<bool> postSystemHeader(String header) async {
    final url = Uri.parse('$baseUrl/system-requirements/headers');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'header': header}),
    );
    return response.statusCode == 200 || response.statusCode == 201;
  }

// POST: Alt Sistem 1 Header
  static Future<bool> postSub1Header(String header) async {
    final url = Uri.parse('$baseUrl/subsystem-requirements/subsystem1-header');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'header': header}),
    );
    return response.statusCode == 200 || response.statusCode == 201;
  }

// POST: Alt Sistem 2 Header
  static Future<bool> postSub2Header(String header) async {
    final url = Uri.parse('$baseUrl/subsystem-requirements/subsystem2-header');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'header': header}),
    );
    return response.statusCode == 200 || response.statusCode == 201;
  }

// POST: Alt Sistem 3 Header
  static Future<bool> postSub3Header(String header) async {
    final url = Uri.parse('$baseUrl/subsystem-requirements/subsystem3-header');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'header': header}),
    );
    return response.statusCode == 200 || response.statusCode == 201;
  }


  // GET: User Requirements
  static Future<List<dynamic>> fetchUserRequirements() async {
    final url = Uri.parse('$baseUrl/user-requirements/user-requirements');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final decodedBody = utf8.decode(response.bodyBytes);
      return jsonDecode(decodedBody);
    } else {
      throw Exception('User Requirements çekilemedi');
    }
  }

  // USER HEADERS
  static Future<List<dynamic>> fetchUserHeaders() async {
    final url = Uri.parse('$baseUrl/user-requirements/headers');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final decodedBody = utf8.decode(response.bodyBytes);
      return jsonDecode(decodedBody);
    } else {
      throw Exception('User headers çekilemedi');
    }
  }

  static Future<bool> deleteUserHeader(String header) async {
    final url = Uri.parse('$baseUrl/user-requirements/headers/$header');
    final response = await http.delete(url);
    return response.statusCode == 200 || response.statusCode == 204;
  }

// SYSTEM HEADERS
  static Future<List<dynamic>> fetchSystemHeaders() async {
    final url = Uri.parse('$baseUrl/system-requirements/headers');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final decodedBody = utf8.decode(response.bodyBytes);
      return jsonDecode(decodedBody);
    } else {
      throw Exception('System headers çekilemedi');
    }
  }

  static Future<bool> deleteSystemHeader(String header) async {
    final url = Uri.parse('$baseUrl/system-requirements/headers/$header');
    final response = await http.delete(url);
    return response.statusCode == 200 || response.statusCode == 204;
  }

// SUBSYSTEM HEADERS
  static Future<List<dynamic>> fetchSub1Headers() async {
    final url = Uri.parse('$baseUrl/subsystem-requirements/subsystem1-header');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final decodedBody = utf8.decode(response.bodyBytes);
      return jsonDecode(decodedBody);
    } else {
      throw Exception('Subsystem1 headers çekilemedi');
    }
  }

  static Future<bool> deleteSub1Header(String header) async {
    final url = Uri.parse('$baseUrl/subsystem-requirements/subsystem1-header/$header');
    final response = await http.delete(url);
    return response.statusCode == 200 || response.statusCode == 204;
  }

  static Future<List<dynamic>> fetchSub2Headers() async {
    final url = Uri.parse('$baseUrl/subsystem-requirements/subsystem2-header');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final decodedBody = utf8.decode(response.bodyBytes);
      return jsonDecode(decodedBody);
    } else {
      throw Exception('Subsystem2 headers çekilemedi');
    }
  }

  static Future<bool> deleteSub2Header(String header) async {
    final url = Uri.parse('$baseUrl/subsystem-requirements/subsystem2-header/$header');
    final response = await http.delete(url);
    return response.statusCode == 200 || response.statusCode == 204;
  }

  static Future<List<dynamic>> fetchSub3Headers() async {
    final url = Uri.parse('$baseUrl/subsystem-requirements/subsystem3-header');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final decodedBody = utf8.decode(response.bodyBytes);
      return jsonDecode(decodedBody);
    } else {
      throw Exception('Subsystem3 headers çekilemedi');
    }
  }

  static Future<bool> deleteSub3Header(String header) async {
    final url = Uri.parse('$baseUrl/subsystem-requirements/subsystem3-header/$header');
    final response = await http.delete(url);
    return response.statusCode == 200 || response.statusCode == 204;
  }



  // USER ATTRIBUTES
  static Future<List<dynamic>> fetchUserAttributes() async {
    final url = Uri.parse('$baseUrl/user-requirements/attributes');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final decodedBody = utf8.decode(response.bodyBytes);
      return jsonDecode(decodedBody);
    } else {
      throw Exception('User attributes çekilemedi');
    }
  }

// SYSTEM ATTRIBUTES
  static Future<List<dynamic>> fetchSystemAttributes() async {
    final url = Uri.parse('$baseUrl/system-requirements/attributes');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final decodedBody = utf8.decode(response.bodyBytes);
      return jsonDecode(decodedBody);
    } else {
      throw Exception('System attributes çekilemedi');
    }
  }

// SUBSYSTEM 1 ATTRIBUTES
  static Future<List<dynamic>> fetchSub1Attributes() async {
    final url = Uri.parse('$baseUrl/subsystem-requirements/subsystem1-attributes');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final decodedBody = utf8.decode(response.bodyBytes);
      return jsonDecode(decodedBody);
    } else {
      throw Exception('Subsystem1 attributes çekilemedi');
    }
  }

// SUBSYSTEM 2 ATTRIBUTES
  static Future<List<dynamic>> fetchSub2Attributes() async {
    final url = Uri.parse('$baseUrl/subsystem-requirements/subsystem2-attributes');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final decodedBody = utf8.decode(response.bodyBytes);
      return jsonDecode(decodedBody);
    } else {
      throw Exception('Subsystem2 attributes çekilemedi');
    }
  }

// SUBSYSTEM 3 ATTRIBUTES
  static Future<List<dynamic>> fetchSub3Attributes() async {
    final url = Uri.parse('$baseUrl/subsystem-requirements/subsystem3-attributes');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final decodedBody = utf8.decode(response.bodyBytes);
      return jsonDecode(decodedBody);
    } else {
      throw Exception('Subsystem3 attributes çekilemedi');
    }
  }

  // GET: Sistem Gereksinimleri
  static Future<List<dynamic>> fetchSystemRequirements() async {
    final url = Uri.parse('$baseUrl/system-requirements/system-requirements');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final decodedBody = utf8.decode(response.bodyBytes);
      return jsonDecode(decodedBody);
    } else {
      throw Exception('Sistem gereksinimleri çekilemedi');
    }
  }

  // GET: Alt Başlık 1 Gereksinimleri
  static Future<List<dynamic>> fetchSubRequirements1() async {
    final url = Uri.parse('$baseUrl/subsystem-requirements/subsystem1');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final decodedBody = utf8.decode(response.bodyBytes);
      return jsonDecode(decodedBody);
    } else {
      throw Exception('1. Alt başlık gereksinimleri çekilemedi');
    }
  }

  // GET: Alt Başlık 2 Gereksinimleri
  static Future<List<dynamic>> fetchSubRequirements2() async {
    final url = Uri.parse('$baseUrl/subsystem-requirements/subsystem2');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final decodedBody = utf8.decode(response.bodyBytes);
      return jsonDecode(decodedBody);
    } else {
      throw Exception('2. Alt başlık gereksinimleri çekilemedi');
    }
  }

  // GET: Alt Başlık 3 Gereksinimleri
  static Future<List<dynamic>> fetchSubRequirements3() async {
    final url = Uri.parse('$baseUrl/subsystem-requirements/subsystem3');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final decodedBody = utf8.decode(response.bodyBytes);
      return jsonDecode(decodedBody);
    } else {
      throw Exception('3. Alt başlık gereksinimleri çekilemedi');
    }
  }

  //Delete User Req
  static Future<bool> deleteUserRequirement(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/user-requirements/user-requirements/$id'));
    return response.statusCode == 204 || response.statusCode == 200;
  }

  //Delete System Req
  static Future<bool> deleteSystemRequirement(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/system-requirements/system-requirements/$id'));
    return response.statusCode == 204 || response.statusCode == 200;
  }

  //Delete Subsystem1 Req
  static Future<bool> deleteSub1Requirement(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/subsystem-requirements/subsystem1/$id'));
    return response.statusCode == 204 || response.statusCode == 200;
  }

  //Delete Subsystem2 Req
  static Future<bool> deleteSub2Requirement(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/subsystem-requirements/subsystem2/$id'));
    return response.statusCode == 204 || response.statusCode == 200;
  }

  //Delete Subsystem3 Req
  static Future<bool> deleteSub3Requirement(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/subsystem-requirements/subsystem3/$id'));
    return response.statusCode == 204 || response.statusCode == 200;
  }

  //Delete User Attributes
  static Future<bool> deleteUserAttribute(String attributeId) async {
    final response = await http.delete(Uri.parse('$baseUrl/user-requirements/attributes/$attributeId'));
    return response.statusCode == 204 || response.statusCode == 200;
  }

  //Delete System Attributes
  static Future<bool> deleteSystemAttribute(String attributeId) async {
    final response = await http.delete(Uri.parse('$baseUrl/system-requirements/attributes/$attributeId'));
    return response.statusCode == 204 || response.statusCode == 200;
  }

  //Delete Sub1 Attributes
  static Future<bool> deleteSub1Attribute(String attributeId) async {
    final response = await http.delete(Uri.parse('$baseUrl/subsystem-requirements/subsystem1-attributes/$attributeId'));
    return response.statusCode == 204 || response.statusCode == 200;
  }

  //Delete Sub2 Attributes
  static Future<bool> deleteSub2Attribute(String attributeId) async {
    final response = await http.delete(Uri.parse('$baseUrl/subsystem-requirements/subsystem2-attributes/$attributeId'));
    return response.statusCode == 204 || response.statusCode == 200;
  }

  //Delete Sub3 Attributes
  static Future<bool> deleteSub3Attribute(String attributeId) async {
    final response = await http.delete(Uri.parse('$baseUrl/subsystem-requirements/subsystem3-attributes/$attributeId'));
    return response.statusCode == 204 || response.statusCode == 200;
  }

  //Update User Requirements
  static Future<bool> updateUserRequirement(
      String id,
      String title,
      String description,
      String createdBy,
      bool flag,
      ) async {
    final response = await http.put(
      Uri.parse('$baseUrl/user-requirements/user-requirements/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'title': title,
        'description': description,
        'createdBy': createdBy,
        'flag': flag,
      }),
    );

    return response.statusCode == 204 || response.statusCode == 200;
  }

  //Update System Requirements
  static Future<bool> updateSystemRequirement(
      String id,
      String title,
      String description,
      String createdBy,
      bool flag,
      String user_req_id,
      ) async {
    final response = await http.put(
      Uri.parse('$baseUrl/system-requirements/system-requirements/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'title': title,
        'description': description,
        'createdBy': createdBy,
        'flag': flag,
        'user_req_id': user_req_id,
      }),
    );

    return response.statusCode == 204 || response.statusCode == 200;
  }

  //Update SubSystem1 Requirements
  static Future<bool> updateSub1Requirement(
      String id,
      String title,
      String description,
      String createdBy,
      bool flag,
      String system_req_id,
      ) async {
    final response = await http.put(
      Uri.parse('$baseUrl/subsystem-requirements/subsystem1/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'title': title,
        'description': description,
        'createdBy': createdBy,
        'flag': flag,
        'systemRequirementId': system_req_id,
      }),
    );

    return response.statusCode == 204 || response.statusCode == 200;
  }

  //Update SubSystem2 Requirements
  static Future<bool> updateSub2Requirement(
      String id,
      String title,
      String description,
      String createdBy,
      bool flag,
      String system_req_id,
      ) async {
    final response = await http.put(
      Uri.parse('$baseUrl/subsystem-requirements/subsystem2/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'title': title,
        'description': description,
        'createdBy': createdBy,
        'flag': flag,
        'systemRequirementId': system_req_id,
      }),
    );

    return response.statusCode == 204 || response.statusCode == 200;
  }

  //Update SubSystem3 Requirements
  static Future<bool> updateSub3Requirement(
      String id,
      String title,
      String description,
      String createdBy,
      bool flag,
      String system_req_id,
      ) async {
    final response = await http.put(
      Uri.parse('$baseUrl/subsystem-requirements/subsystem3/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'title': title,
        'description': description,
        'createdBy': createdBy,
        'flag': flag,
        'systemRequirementId': system_req_id,
      }),
    );

    return response.statusCode == 204 || response.statusCode == 200;
  }



}