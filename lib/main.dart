import 'package:flutter/material.dart';
void main() => runApp(MyApp());
class MyApp extends StatelessWidget {
  @override Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.account_balance_wallet, size: 80, color: Color(0xFF00FF82)),
            SizedBox(height: 20),
            Text("QUICK PAY X", style: TextStyle(color: Color(0xFF00FF82), fontSize: 28, fontWeight: FontWeight.bold)),
            Text("Build Success!", style: TextStyle(color: Colors.white54)),
          ]),
        ),
      ),
    );
  }
}