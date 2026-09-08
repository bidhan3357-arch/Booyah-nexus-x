import 'package:flutter/material.dart';
void main() => runApp(QuickPayXApp());
int walletBalance = 0;
List<String> history = [];
String? userPassword;

class QuickPayXApp extends StatelessWidget {
  @override Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: userPassword == null ? CreatePinScreen() : LockScreen());
  }
}

class CreatePinScreen extends StatefulWidget { @override State<CreatePinScreen> createState() => _CreatePinScreenState(); }
class _CreatePinScreenState extends State<CreatePinScreen> {
  final p1 = TextEditingController(); final p2 = TextEditingController(); String err = "";
  @override Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.black, body: Center(child: Padding(padding: EdgeInsets.all(25), child: Column(mainAxisSize: MainAxisSize.min, children: [
      Icon(Icons.lock_person, size: 80, color: Color(0xFF00FF82)),
      Text("QUICK PAY X", style: TextStyle(color: Color(0xFF00FF82), fontSize: 26, fontWeight: FontWeight.bold)),
      Text("নিজের Password বানাও", style: TextStyle(color: Colors.white54)),
      SizedBox(height: 30),
      TextField(controller: p1, obscureText: true, maxLength: 4, keyboardType: TextInputType.number, textAlign: TextAlign.center, style: TextStyle(color: Colors.white, letterSpacing: 10, fontSize: 22), decoration: InputDecoration(counterText: "", hintText: "PIN বানাও", filled: true, fillColor: Color(0xFF1A1A1A), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
      SizedBox(height: 10),
      TextField(controller: p2, obscureText: true, maxLength: 4, keyboardType: TextInputType.number, textAlign: TextAlign.center, style: TextStyle(color: Colors.white, letterSpacing: 10, fontSize: 22), decoration: InputDecoration(counterText: "", hintText: "Confirm PIN", filled: true, fillColor: Color(0xFF1A1A1A), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
      if(err.isNotEmpty) Text(err, style: TextStyle(color: Colors.red)),
      SizedBox(height: 20),
      SizedBox(width: double.infinity, height: 55, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF00FF82), foregroundColor: Colors.black), onPressed: (){ if(p1.text.length!=4){setState(()=>err="4 Digit দাও"); return;} if(p1.text!=p2.text){setState(()=>err="PIN মিলছে না"); return;} userPassword=p1.text; Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> WalletScreen())); }, child: Text("SET PIN", style: TextStyle(fontWeight: FontWeight.bold)))),
    ])))));
  }
}

class LockScreen extends StatefulWidget { @override State<LockScreen> createState() => _LockScreenState(); }
class _LockScreenState extends State<LockScreen> {
  final pinCtrl = TextEditingController(); String err = "";
  @override Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.black, body: Center(child: Padding(padding: EdgeInsets.all(30), child: Column(mainAxisSize: MainAxisSize.min, children: [
      Icon(Icons.lock, size: 70, color: Color(0xFF00FF82)),
      Text("PIN দিয়ে খোলো", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
      SizedBox(height: 25),
      TextField(controller: pinCtrl, obscureText: true, maxLength: 4, keyboardType: TextInputType.number, textAlign: TextAlign.center, style: TextStyle(color: Colors.white, letterSpacing: 10, fontSize: 26), decoration: InputDecoration(counterText: "", filled: true, fillColor: Color(0xFF1A1A1A), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
      if(err.isNotEmpty) Text(err, style: TextStyle(color: Colors.red)),
      SizedBox(height: 20),
      SizedBox(width: double.infinity, height: 55, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF00FF82), foregroundColor: Colors.black), onPressed: (){ if(pinCtrl.text==userPassword){Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> WalletScreen()));} else {setState(()=>err="ভুল PIN");} }, child: Text("UNLOCK", style: TextStyle(fontWeight: FontWeight.bold)))),
      TextButton(onPressed: (){userPassword=null; Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> CreatePinScreen()));}, child: Text("Reset PIN", style: TextStyle(color: Colors.white24))),
    ])))));
  }
}

class WalletScreen extends StatefulWidget { @override State<WalletScreen> createState() => _WalletScreenState(); }
class _WalletScreenState extends State<WalletScreen> {
  @override Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.black, body: SafeArea(child: Column(children: [
      Container(padding: EdgeInsets.all(20), decoration: BoxDecoration(color: Color(0xFF111111), borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))), child: Column(children: [
        Text("QUICK PAY X", style: TextStyle(color: Color(0xFF00FF82), fontWeight: FontWeight.bold)),
        SizedBox(height: 15),
        Container(padding: EdgeInsets.all(18), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: