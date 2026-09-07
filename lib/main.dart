import 'package:flutter/material.dart';

void main() { runApp(BooyahNexusX()); }

class BooyahNexusX extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Booyah Nexus X',
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: Color(0xFF0F0F0F)),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('BOOYAH NEXUS X'), backgroundColor: Colors.deepPurple, centerTitle: true),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.sports_esports, size: 100, color: Colors.deepPurpleAccent),
            SizedBox(height: 20),
            Text('BOOYAH NEXUS X', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('Free Fire Pro Tools', style: TextStyle(color: Colors.grey)),
            SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple, padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15)),
              onPressed: (){},
              child: Text('GET SENSITIVITY'),
            ),
            SizedBox(height: 15),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15)),
              onPressed: (){},
              child: Text('CHECK STATS'),
            ),
          ],
        ),
      ),
    );
  }
}
