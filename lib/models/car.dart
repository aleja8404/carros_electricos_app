class Car {
  final String? placa; // Ahora puede ser null
  final String? conductor; // Ahora puede ser null
  final String? image; // Ahora puede ser null

  Car({
    required this.placa,
    required this.conductor,
    required this.image,
  });

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      placa: json['placa'] as String? ?? 'Sin placa', // Valor predeterminado si es null
      conductor: json['conductor'] as String? ?? 'Sin conductor', // Valor predeterminado si es null
      image: json['image'] as String? ?? '', // Valor predeterminado si es null
    );
  }
}