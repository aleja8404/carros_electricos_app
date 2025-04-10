import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:carros_electricos_app/screens/login_screen.dart';
import 'package:carros_electricos_app/screens/home_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([FlutterSecureStorage])
import 'widget_test.mocks.dart';

void main() {
  late MockFlutterSecureStorage mockStorage;

  setUp(() {
    mockStorage = MockFlutterSecureStorage();
    when(mockStorage.read(key: 'auth_token')).thenAnswer((_) async => null);
    when(mockStorage.write(key: 'auth_token', value: anyNamed('value')))
        .thenAnswer((_) async {});
  });

  testWidgets('Login screen displays correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp( // Elimina 'const'
        home: const LoginScreen(),
        routes: {
          '/home': (context) => const HomeScreen(),
          '/login': (context) => const LoginScreen(),
        },
      ),
    );

    expect(find.text('Sign In'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'User Name'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Password'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'SIGN IN'), findsOneWidget);
  });

  testWidgets('Login screen allows text input and successful login',
      (WidgetTester tester) async {
    // Configura el mock para que inicialmente no haya token
    when(mockStorage.read(key: 'auth_token')).thenAnswer((_) async => null);

    // Simula que después de escribir el token, la lectura devolverá 'authenticated'
    when(mockStorage.write(key: 'auth_token', value: 'authenticated'))
        .thenAnswer((_) async {
      when(mockStorage.read(key: 'auth_token'))
          .thenAnswer((_) async => 'authenticated');
    });

    await tester.pumpWidget(
      MaterialApp( // Elimina 'const'
        home: const LoginScreen(),
        routes: {
          '/home': (context) => const HomeScreen(),
          '/login': (context) => const LoginScreen(),
        },
      ),
    );

    await tester.enterText(find.widgetWithText(TextField, 'User Name'), 'admin');
    expect(find.text('admin'), findsOneWidget);

    await tester.enterText(find.widgetWithText(TextField, 'Password'), 'admin');
    // No verificamos el texto de la contraseña porque obscureText: true

    await tester.tap(find.widgetWithText(ElevatedButton, 'SIGN IN'));
    await tester.pump();
    await Future.delayed(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    expect(find.byType(HomeScreen), findsOneWidget);
  });

  testWidgets('Login screen shows error on incorrect credentials',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp( // Elimina 'const'
        home: const LoginScreen(),
        routes: {
          '/home': (context) => const HomeScreen(),
          '/login': (context) => const LoginScreen(),
        },
      ),
    );

    await tester.enterText(find.widgetWithText(TextField, 'User Name'), 'wrong');
    await tester.enterText(find.widgetWithText(TextField, 'Password'), 'wrong');
    await tester.tap(find.widgetWithText(ElevatedButton, 'SIGN IN'));
    await tester.pump();

    expect(find.text('Usuario o contraseña incorrectos'), findsOneWidget);
  });
}