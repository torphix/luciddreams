import 'dart:convert';

import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../models/user.dart';
import '../settings.dart';

class AuthAPI {
  // static Future<bool> autoLogin() async {
  // Loads user from database
  // Logs in user
  // }

  static Future<User> loadUserFromLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('user_email');
    final token = prefs.getString('user_token');
    return User(email: email, token: token);
  }

  static Future<void> saveUserToLocalStorage(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_token', user.token!);
    await prefs.setString('user_email', user.email!);
  }

  static Future<void> emailRegisterUser(String email, String password) async {
    try {
      Response response =
          await http.post(Uri.parse('${Settings.rootUrl}/auth/registration/'),
              body: {
                'email': email,
                'username': email,
                'password1': password,
                'password2': password,
              });
      if (response.statusCode != 201) {
        throw Exception(response.reasonPhrase);
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<User> loginUserWithEmail(String email, String password) async {
    try {
      Response response =
          await http.post(Uri.parse('${Settings.rootUrl}/auth/login/'),
              body: {
                'email': email,
                'password': password,
              });

      if (response.statusCode != 200){
        throw Exception(jsonDecode(response.body).values.toList()[0][0]);
      }
      final String token = jsonDecode(response.body)['key'];
      return User(email: email, token: token);
    } catch (e) {
      rethrow;
    }
  }
}
