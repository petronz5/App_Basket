// lib/main.dart
import 'package:basketball_stats_app/screens/ProfileScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/auth_provider.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/add_game_screen.dart'; // Importa la nuova schermata
import 'screens/guide_screen.dart'; // Schermata guida
import 'screens/game_detail_screen.dart'; // Aggiungi questa importazione

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Basketball Stats App',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange, // Usa deepOrange per un tema arancione più ricco
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepOrange).copyWith(
          secondary: Colors.orangeAccent, // Accent color arancione
        ),
        textTheme: TextTheme(
          headlineSmall: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.deepOrange),
          bodyMedium: TextStyle(fontSize: 16.0, color: Colors.black87),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.deepOrange,
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.deepOrange,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepOrange, // Colore di sfondo arancione per i pulsanti
            foregroundColor: Colors.white, // Colore del testo dei pulsanti
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.deepOrange),
          ),
          labelStyle: TextStyle(color: Colors.deepOrange),
        ),
      ),
      home: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          if (authProvider.isAuthenticated) {
            return HomeScreen();
          } else {
            return LoginScreen();
          }
        },
      ),
      routes: {
        '/login': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
        '/addGame': (context) => AddGameScreen(),
        '/guide': (context) => GuideScreen(),
        '/profile': (context) => ProfileScreen(),

      },
    );
  }
}
