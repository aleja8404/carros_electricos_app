import 'package:flutter/material.dart';
import 'package:carros_electricos_app/services/api_service.dart';
import 'package:carros_electricos_app/models/car.dart';

class CarListScreen extends StatefulWidget {
  const CarListScreen({super.key});

  @override
  _CarListScreenState createState() => _CarListScreenState();
}

class _CarListScreenState extends State<CarListScreen> {
  final ApiService apiService = ApiService();
  late Future<List<Car>> futureCars;

  @override
  void initState() {
    super.initState();
    futureCars = apiService.getCars();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis Carros Eléctricos')),
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
              return ListTile(
                title: Text('Placa: ${car.placa}'),
                subtitle: Text('Conductor: ${car.conductor}'),
              );
            },
          );
        },
      ),
    );
  }
}