import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/car.dart';

class ApiService {
  final String baseUrl = 'https://github.com/aleja8404/carros_electricos_app';

  Future<List<Car>> getCars() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Car.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener los carros: ${response.statusCode}');
    }
  }

  Future<Car> getCarByQrCode(String qrCode) async {
    final response = await http.get(Uri.parse('$baseUrl/$qrCode'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Car.fromJson(data);
    } else {
      throw Exception('Error al obtener el carro: ${response.statusCode}');
    }
  }
}