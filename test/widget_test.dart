import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:carros_electricos_app/services/api_service.dart';
import 'package:carros_electricos_app/screens/login_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// Genera los mocks para FlutterSecureStorage
@GenerateMocks([FlutterSecureStorage])
import 'widget_test.mocks.dart';

void main() {
  late MockFlutterSecureStorage mockStorage;
  late ApiService apiService;

  setUp(() {
    // Inicializa el mock
    mockStorage = MockFlutterSecureStorage();
    apiService = ApiService(storage: mockStorage);

    // Configura el comportamiento del mock
    when(mockStorage.read(key: 'auth_token')).thenAnswer((_) async => null);
    when(mockStorage.write(key: 'auth_token', value: anyNamed('value')))
        .thenAnswer((_) async {});
  });

  testWidgets('Login screen displays correctly', (WidgetTester tester) async {
    // Construye la app y renderiza un frame.
    await tester.pumpWidget(
      MaterialApp(
        home: LoginScreen(apiService: apiService),
      ),
    );

    // Verifica que el título "Iniciar Sesión" esté presente en el AppBar.
    expect(find.text('Iniciar Sesión'), findsOneWidget);

    // Verifica que los campos de texto para usuario y contraseña estén presentes.
    expect(find.widgetWithText(TextField, 'Usuario'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Contraseña'), findsOneWidget);

    // Verifica que el botón "Iniciar Sesión" esté presente.
    expect(find.widgetWithText(ElevatedButton, 'Iniciar Sesión'), findsOneWidget);

    // Verifica que los botones de texto "¿Olvidaste tu contraseña?" y "Nuevo Usuario - Registrarse" estén presentes.
    expect(find.text('¿Olvidaste tu contraseña?'), findsOneWidget);
    expect(find.text('Nuevo Usuario - Registrarse'), findsOneWidget);
  });

  testWidgets('Login screen allows text input', (WidgetTester tester) async {
    // Configura el mock para simular una respuesta exitosa del login
    when(mockStorage.write(key: 'auth_token', value: anyNamed('value')))
        .thenAnswer((_) async {});
    when(mockStorage.read(key: 'auth_token')).thenAnswer((_) async => 'mock_token');

    // Construye la app y renderiza un frame.
    await tester.pumpWidget(
      MaterialApp(
        home: LoginScreen(apiService: apiService),
      ),
    );

    // Ingresa texto en el campo de usuario.
    await tester.enterText(find.widgetWithText(TextField, 'Usuario'), 'admin');
    expect(find.text('admin'), findsOneWidget);

    // Ingresa texto en el campo de contraseña.
    await tester.enterText(find.widgetWithText(TextField, 'Contraseña'), 'admin');
    expect(find.text('admin'), findsOneWidget);

    // Toca el botón "Iniciar Sesión" (no verificamos la navegación aquí, solo la acción).
    await tester.tap(find.widgetWithText(ElevatedButton, 'Iniciar Sesión'));
    await tester.pump();
  });
}