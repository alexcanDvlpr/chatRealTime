import 'dart:convert';

import 'package:chat_realtime/global/environment.dart';
import 'package:chat_realtime/models/login_response.dart';
import 'package:chat_realtime/models/usuario.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService with ChangeNotifier {
  late Usuario user;
  bool _authenticating = false;

  final _storage = new FlutterSecureStorage();

  static Future<String?> getToken() async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');
    return token;
  }

  static Future<void> deleteToken() async {
    const storage = FlutterSecureStorage();
    await storage.delete(key: 'token');
  }

  bool get authenticating => _authenticating;
  set authenticating(bool value) {
    _authenticating = value;
    notifyListeners();
  }

  Future<bool> signIn(String email, String password) async {
    authenticating = true;
    final data = {'email': email, 'password': password};

    final resp = await http.post(
      Uri.parse('${Environment.apiUrl}/login'),
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );

    authenticating = false;
    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      user = loginResponse.user;

      // Guardar token en luugar seguro
      await _saveToken(loginResponse.token);

      return true;
    }
    return false;
  }

  Future signUp(String name, String email, String password) async {
    authenticating = true;
    final data = {'name': name, 'email': email, 'password': password};

    final resp = await http.post(
      Uri.parse('${Environment.apiUrl}/login/new'),
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );

    authenticating = false;
    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      user = loginResponse.user;

      // Guardar token en luugar seguro
      await _saveToken(loginResponse.token);

      return true;
    }

    final resBody = jsonDecode(resp.body);
    return resBody['msg'];
  }

  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: 'token');
    print(token);

    final resp = await http.get(
      Uri.parse('${Environment.apiUrl}/login/renew'),
      headers: {
        'Content-Type': 'application/json',
        'x-token': token ?? "",
      },
    );

    if (resp.statusCode == 200) {
      final renewedResponse = loginResponseFromJson(resp.body);
      user = renewedResponse.user;
      await _saveToken(renewedResponse.token);
      return true;
    } else {
      logout();
      return false;
    }
  }

  Future _saveToken(String token) async {
    return await _storage.write(key: 'token', value: token);
  }

  Future logout() async {
    await _storage.delete(key: 'token');
  }
}
