import 'package:flutter/material.dart';

void main() {
  runApp(const BooyahNexusApp());
}

class BooyahNexusApp extends StatelessWidget {
  const BooyahNexusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Booyah Nexus X',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFFFFD700),
        scaffoldBackgroundColor: const Color(0xFF0A0A0A),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BOOYAH NEXUS X', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFFD700))),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.sports_esports, size: 100, color: Color(0xFFFFD700)),
            const SizedBox(height: 20),
            const Text('Welcome to Booyah Nexus X', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text('Tournament App Ready!', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFFFD700), foregroundColor: Colors.black),
              onPressed: () {},
              child: const Text('ENTER TOURNAMENT'),
            )
          ],
        ),
      ),
    );
  }
}
        
