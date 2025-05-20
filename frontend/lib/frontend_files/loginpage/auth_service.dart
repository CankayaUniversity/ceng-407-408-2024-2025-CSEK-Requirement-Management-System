import 'dart:html';
import 'dart:convert';
import 'package:openid_client/openid_client_browser.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'dart:html' as html;

class AuthService {
  static Credential? _credential;



  static Future<void> loginWithKeycloak() async {
   // print('[AuthService] loginWithKeycloak çağırıldı.');

    final redirectUri = Uri.parse('${window.location.origin}/keycloak-redirect.html');
    final issuer = await Issuer.discover(Uri.parse('http://localhost:8081/realms/csek'));
    final client = Client(issuer, 'csek-frontend');

    final flow = Flow.implicit(client);
    flow.redirectUri = redirectUri;

    // ➕ flow.state değerini sessionStorage'a kaydet
    window.sessionStorage['pkce_state'] = flow.state;

    final authUrl = flow.authenticationUri;

    //print('[AuthService] Login için yönlendirme yapılıyor: $authUrl');
    window.location.href = authUrl.toString();
  }






  /// Rastgele state oluşturmak için yardımcı fonksiyon
  static String _generateRandomState() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final rand = DateTime.now().millisecondsSinceEpoch;
    return 'state_$rand';
  }



  Future<String?> processRedirect() async {
   // print('[AuthService] processRedirect çağırıldı');

    final fragment = html.window.sessionStorage['redirect_fragment'];
    html.window.sessionStorage.remove('redirect_fragment');
    //print('[AuthService] redirect_fragment: $fragment');

    if (fragment == null || fragment.isEmpty || !fragment.contains('&')) {
      //print('[AuthService] Fragment null ya da içinde beklenen veri yok.');
      return null;
    }

    final query = fragment.substring(1); // '#' karakterini at
    final params = Uri.splitQueryString(query);
   // print('[AuthService] fragmentParams: $params');

    final issuer = await Issuer.discover(Uri.parse('http://localhost:8081/realms/csek'));
    final client = Client(issuer, 'csek-frontend');

    // 🔐 Kaydedilmiş state'i al ve Flow.implicit() içine geçir
    final storedState = html.window.sessionStorage['pkce_state'];
    if (storedState == null) {
      //print('[AuthService] Hata: Kaydedilmiş state yok!');
      return null;
    }

    final flow = Flow.implicit(client, state: storedState);
    flow.redirectUri = Uri.parse('${html.window.location.origin}/keycloak-redirect.html');

    try {
      _credential = await flow.callback(params);
      final token = await _credential?.getTokenResponse();
     // print('[AuthService] Token alındı: ${token?.accessToken}');
      return token?.accessToken;
    } catch (e) {
      //print('[AuthService] Token alma hatası: $e');
      return null;
    }
  }



  static Future<String?> getAccessToken() async {
    final token = await _credential?.getTokenResponse();
   // print('[AuthService] Access token: ${token?.accessToken}');
    return token?.accessToken;
  }


  static Future<Map<String, dynamic>?> getUserInfo() async {
    if (_credential == null) return null;

    final idToken = _credential!.idToken.toCompactSerialization();
    final parts = idToken.split('.');
    if (parts.length != 3) return null;

    final payload = utf8.decode(base64Url.decode(base64.normalize(parts[1])));
    final decoded = json.decode(payload) as Map<String, dynamic>;

    return {
      'username': decoded['preferred_username'],
      'name': '${decoded['given_name'] ?? ''} ${decoded['family_name'] ?? ''}',
      'email': decoded['email'],
    };
  }


  static Future<List<String>> getUserRoles() async {
    print('[AuthService] getUserRoles çağırıldı.');
    if (_credential == null) {
      return [];
    }

    final accessToken = (await _credential!.getTokenResponse())?.accessToken;
    if (accessToken == null) {
      print('[AuthService] Access token alınamadı.');
      return [];
    }

    final parts = accessToken.split('.');
    if (parts.length != 3) {
      print('[AuthService] Token formatı geçersiz.');
      return [];
    }

    final payload = utf8.decode(base64Url.decode(base64.normalize(parts[1])));
    final decoded = json.decode(payload) as Map<String, dynamic>;

    final roles = (decoded['resource_access']?['csek-frontend']?['roles'] as List?)?.cast<String>() ?? [];
    print('\n\n\n\n[AuthService] Roller: $roles \n\n\n\n\n\n');
    return roles;
  }




  static Future<void> logout() async {
    final redirectUri = Uri.encodeComponent('${window.location.origin}/login');

    final idToken = _credential?.idToken?.toCompactSerialization();

    final logoutUrl =
        'http://localhost:8081/realms/csek/protocol/openid-connect/logout'
        '?post_logout_redirect_uri=$redirectUri'
        '&id_token_hint=$idToken';

    window.localStorage.clear();
    window.sessionStorage.clear();
    window.location.href = logoutUrl;
  }





}