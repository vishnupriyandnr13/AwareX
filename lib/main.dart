import 'package:flutter/material.dart';

void main() {
  runApp(const AwareXApp());
}

class AwareXApp extends StatelessWidget {
  const AwareXApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AwareX',
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("AwareX"), centerTitle: true),
      body: const Center(
        child: Text(
          "Welcome to AwareX",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
