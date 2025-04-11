import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/api_service.dart';
import '../models/car.dart';

class CarListScreen extends StatefulWidget {
  const CarListScreen({super.key});

  @override
  _CarListScreenState createState() => _CarListScreenState();
}

class _CarListScreenState extends State<CarListScreen> {
  final ApiService apiService = ApiService();
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  late Future<List<Car>> futureCars;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
    futureCars = apiService.getCars();
  }

  Future<void> _checkAuthStatus() async {
    String? token = await storage.read(key: 'auth_token');
    if (token == null || token != 'authenticated') {
      if (ModalRoute.of(context)?.settings.name != '/login' && mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis Carros')),
      body: FutureBuilder<List<Car>>(
        future: futureCars,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay carros disponibles'));
          }

          final cars = snapshot.data!;
          return ListView.builder(
            itemCount: cars.length,
            itemBuilder: (context, index) {
              final car = cars[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  leading: (car.image != null && car.image!.isNotEmpty)
                      ? Image.network(
                          car.image!,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.error,
                              color: Colors.red,
                              size: 50,
                            );
                          },
                        )
                      : const Icon(
                          Icons.directions_car,
                          size: 50,
                        ),
                  title: Text('Placa: ${car.placa ?? "Sin placa"}'),
                  subtitle: Text('Conductor: ${car.conductor ?? "Sin conductor"}'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}