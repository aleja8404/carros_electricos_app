import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../services/api_service.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  final ApiService apiService = ApiService();
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  bool isScanned = false;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    String? token = await storage.read(key: 'auth_token');
    if (token == null || token != 'authenticated') {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      if (!isScanned) {
        setState(() {
          isScanned = true;
        });
        controller.pauseCamera();
        String qrCode = scanData.code ?? '';
        // Para propósitos de prueba, simulamos que el QR contiene "C01"
        // En un caso real, el QR debería contener el código directamente
        qrCode = 'C01'; // Simulación basada en el flujo de pantallas
        try {
          final car = await apiService.getCarByQrCode(qrCode);
          if (mounted) {
            Navigator.pushNamed(
              context,
              '/confirm',
              arguments: car.placa, // Pasa la placa como argumento
            );
          }
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error al buscar el carro: $e')),
            );
            Navigator.pop(context);
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escanear QR'),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: QRView(
        key: qrKey,
        onQRViewCreated: _onQRViewCreated,
        overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: 300,
        ),
      ),
    );
  }
}