import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'views/pantallaPrincipal.dart';
import 'views/order_summary_screen.dart';
import 'viewmodels/homeViewModel.dart';

void main() {
  runApp(const BarApp());
}

class BarApp extends StatelessWidget {
  const BarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Proveedor global para la lista de pedidos.
        // Se instancia aquí para que sobreviva durante toda la vida de la app.
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
      ],
      child: MaterialApp(
        title: 'Bar Order App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.teal,
          useMaterial3: true,
          // Definimos un estilo base para los botones para mantener consistencia
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ),
        // Pantalla inicial
        home: const HomeScreen(),
        // Rutas nombradas (requerido para la pantalla de resumen)
        routes: {
          OrderSummaryScreen.routeName: (context) => const OrderSummaryScreen(),
        },
      ),
    );
  }
}