import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/car.dart'; // Asegúrate de importar el modelo Car

class ConfirmScreen extends StatelessWidget {
  const ConfirmScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String carPlaca = ModalRoute.of(context)!.settings.arguments as String;
    final ApiService apiService = ApiService();

    return Scaffold(
      body: FutureBuilder<Car>( // Especifica el tipo genérico como Car
        future: apiService.getCarByQrCode(carPlaca),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Carro no encontrado'));
          }

          final car = snapshot.data!; // Ahora car es de tipo Car
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (car.image != null && car.image!.isNotEmpty)
                  Image.network(
                    car.image!,
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.error,
                        color: Colors.red,
                        size: 150,
                      );
                    },
                  )
                else
                  const Icon(
                    Icons.directions_car,
                    size: 150,
                  ),
                const SizedBox(height: 20),
                Text(
                  'Desea tomar el Carro ${car.placa ?? "Sin placa"}?',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 10),
                Text(
                  'Conductor: ${car.conductor ?? "Sin conductor"}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.popUntil(context, (route) => route.isFirst);
                      },
                      child: const Text('Sí'),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.popUntil(context, (route) => route.isFirst);
                      },
                      child: const Text('No'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}