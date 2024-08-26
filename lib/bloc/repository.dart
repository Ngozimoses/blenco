import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
class UserRepository {
  final String baseUrl = 'http://www.swee.somee.com/v1/api'; // Replace with your actual API URL

  Future<String> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/account-login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      print("you have login successfully ");
      final responseData = json.decode(response.body);
      print("hereis it ${responseData['token']}");
      return "responseData['token']"; // Assuming the API returns a token
    } else {
      print("invaild details ");
      throw Exception('Failed to login');
    }
  }
  Future<String> createUser(String email, String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/RegisterEventlogin'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      print("you have login successfully ");
      final responseData = json.decode(response.body);
      print("hereis it ${responseData['token']}");
      return "responseData['token']"; // Assuming the API returns a token
    } else {
      print("invaild details ");
      throw Exception('Failed to login');
    }
  }
}