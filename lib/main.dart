import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'views/pantallaPrincipal.dart';
import 'views/order_summary_screen.dart';
import 'viewmodels/homeViewModel.dart';

/// Punto de entrada de la aplicación.
void main() {
  runApp(const BarApp());
}

/// Widget principal de la aplicación.
class BarApp extends StatelessWidget {
  const BarApp({super.key});

/// Construye la UI de la aplicación.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
      ],
      child: MaterialApp(
        title: 'Bar Order App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.teal,
          useMaterial3: true,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ),
        // Pantalla inicial
        home: const HomeScreen(),
        routes: {
          OrderSummaryScreen.routeName: (context) => const OrderSummaryScreen(),
        },
      ),
    );
  }
}