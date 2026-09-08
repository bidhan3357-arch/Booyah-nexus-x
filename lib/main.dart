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
        primaryColor: const Color(0xFFFFFD700),
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.sports_esports, size: 100, color: Color(0xFFFFFD700)),
            SizedBox(height: 20),
            Text("BOOYAH NEXUS X", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFFFFFD700))),
            SizedBox(height: 10),
            Text("Ultimate Tournament Platform", style: TextStyle(color: Colors.white70)),
            SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFFFD700),
                foregroundColor: Colors.black,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: Text("ENTER TOURNAMENT", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
    );
  }
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Player Login"), backgroundColor: Color(0xFFFFFD700), foregroundColor: Colors.black),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(decoration: InputDecoration(labelText: "Your Name", border: OutlineInputBorder(), prefixIcon: Icon(Icons.person))),
            SizedBox(height: 15),
            TextField(decoration: InputDecoration(labelText: "Free Fire UID", border: OutlineInputBorder(), prefixIcon: Icon(Icons.games))),
            SizedBox(height: 15),
            TextField(decoration: InputDecoration(labelText: "WhatsApp Number", border: OutlineInputBorder(), prefixIcon: Icon(Icons.phone))),
            SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFFFFD700), foregroundColor: Colors.black, minimumSize: Size(double.infinity, 50)),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => TournamentPage()));
              },
              child: Text("JOIN NOW", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
    );
  }
}

class TournamentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tournaments"), backgroundColor: Color(0xFFFFFD700), foregroundColor: Colors.black),
      body: ListView(
        padding: EdgeInsets.all(15),
        children: [
          TournamentCard(title: "Daily Solo - 100₹ Prize", time: "Today 8 PM", fee: "10₹"),
          TournamentCard(title: "Squad Clash - 1000₹ Prize", time: "Tomorrow 9 PM", fee: "50₹"),
          TournamentCard(title: "Booyah Cup Final", time: "Sunday 10 PM", fee: "Free"),
        ],
      ),
    );
  }
}

class TournamentCard extends StatelessWidget {
  final String title, time, fee;
  TournamentCard({required this.title, required this.time, required this.fee});
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[900],
      margin: EdgeInsets.only(bottom: 15),
      child: ListTile(
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(time),
        trailing: Text(fee, style: TextStyle(color: Color(0xFFFFFD700), fontWeight: FontWeight.bold, fontSize: 18)),
      ),
    );
  }
}