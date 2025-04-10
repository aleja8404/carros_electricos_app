import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/car.dart';

class ApiService {
  final String baseUrl = 'https://carros-electricos.wiremockapi.cloud';
  final FlutterSecureStorage storage;

  ApiService({FlutterSecureStorage? storage}) : storage = storage ?? const FlutterSecureStorage();

  Future<String> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token'];
      await storage.write(key: 'auth_token', value: token);
      return token;
    } else {
      throw Exception('Error al iniciar sesión');
    }
  }

  Future<List<Car>> getCars() async {
    final token = await storage.read(key: 'auth_token');
    if (token == null) throw Exception('No se encontró el token');

    final response = await http.get(
      Uri.parse('$baseUrl/carros'),
      headers: {'Authentication': token},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Car.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener los carros');
    }
  }
}