import 'package:flutter/material.dart';
import 'package:gas_page/page.dart';
import 'package:provider/provider.dart';

void main() => runApp(
      const MyApp(),
    );

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(seconds: 1),
      decoration: const BoxDecoration(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'PilotHealth',
        initialRoute: 'combustibles',
        routes: {
          'combustibles': (_) => const CombustibleScreen(title: 'COMBUSTIBLE')
        },
        theme: ThemeData.light(),
      ),
    );
  }
}
