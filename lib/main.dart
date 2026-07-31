import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AwareXApp extends StatelessWidget {
  const AwareXApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AwareX',
      home: const Scaffold(
        body: Center(
          child: Text(
            'AwareX',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const ProviderScope(child: AwareXApp()));
}
