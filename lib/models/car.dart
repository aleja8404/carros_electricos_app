class Car {
  final String placa;
  final String conductor;

  Car({required this.placa, required this.conductor});

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      placa: json['placa'],
      conductor: json['conductor'],
    );
  }
}