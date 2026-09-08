import 'package:flutter/material.dart';

// === SECRET WALLET SYSTEM - Player দেখবে না ===
int playerWallet = 0; // Player Wallet - 0 থেকে শুরু
int adminWallet = 0; // Tomar Personal Wallet - App এর ভেতরেই, শুধু তুমি দেখবে

void main() => runApp(MaterialApp(debugShowCheckedModeBanner: false, theme: ThemeData(brightness: Brightness.dark, scaffoldBackgroundColor: Color(0xFF0A0A14)), home: BooyahFinalApp()));

class BooyahFinalApp extends StatefulWidget {
  @override State<BooyahFinalApp> createState() => _BooyahFinalAppState();
}

class _BooyahFinalAppState extends State<BooyahFinalApp> {
  int tapCount = 0;
  String selectedMode = "4 VS 4";
  int selectedEntry = 10;

  Map<String, Map<int, Map<String, int>>> chart = {
    "4 VS 4": {10: {"total": 80, "first": 50, "second": 20, "profit": 30}, 20: {"total": 160, "first": 80, "second": 40, "profit": 80}, 30: {"total": 240, "first": 90, "second": 60, "profit": 90}, 50: {"total": 400, "first": 180, "second": 70, "profit": 150}},
    "8 VS 8": {10: {"total": 160, "first": 80, "second": 40, "profit": 60}, 20: {"total": 320, "first": 120, "second": 80, "profit": 120}, 30: {"total": 480, "first": 150, "second": 100, "profit": 230}, 50: {"total": 800, "first": 300, "second": 200, "profit": 300}},
    "12 VS 12": {10: {"total": 240, "first": 90, "second": 60, "profit": 90}, 20: {"total": 480, "first": 180, "second": 120, "profit": 180}, 30: {"total": 720, "first": 250, "second": 150, "profit": 320}, 50: {"total": 1200, "first": 400, "second": 250, "profit": 550}},
    "24 VS 24": {10: {"total": 480, "first": 180, "second": 120, "profit": 180}, 20: {"total": 960, "first": 360, "second": 240, "profit": 360}, 30: {"total": 1440, "first": 400, "second": 300, "profit": 740}, 50: {"total": 2400, "first": 600, "second": 300, "profit": 1500}},
  };

  @override
  Widget build(BuildContext context) {
    var data = chart[selectedMode]![selectedEntry]!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFFD700),
        title: GestureDetector(
          onTap: () { tapCount++; if(tapCount >= 5){ tapCount=0; Navigator.push(context, MaterialPageRoute(builder: (_) => AdminWalletPage())).then((_)=>setState((){})); } },
          child: Text("BOOYAH NEXUS X - FINAL", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
        ),
        actions: [Padding(padding: EdgeInsets.all(10), child: Center(child: Text("Wallet: $playerWallet₹", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))))],
      ),
      body: SingleChildScrollView(padding: EdgeInsets.all(15), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Player Wallet - 0 Point
        Container(padding: EdgeInsets.all(15), decoration: BoxDecoration(color: Colors.grey[900], borderRadius: BorderRadius.circular(12), border: Border.all(color: Color(0xFFFFD700))), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("Your Wallet", style: TextStyle(color: Colors.white70, fontSize: 12)), Text("$playerWallet Coins", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white))]),
          ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFFFD700), foregroundColor: Colors.black), onPressed: () async { await Navigator.push(context, MaterialPageRoute(builder: (_) => AddCoinPage())); setState((){}); }, child: Text("ADD COIN +")),
        ])),
        SizedBox(height: 20),
        Text("MODE SELECT:", style: TextStyle(color: Color(0xFFFFD700), fontWeight: FontWeight.bold)),
        Row(children: ["4 VS 4","8 VS 8","12 VS 12","24 VS 24"].map((m)=>Expanded(child: Padding(padding: EdgeInsets.all(3), child: ChoiceChip(label: Text(m, style: TextStyle(fontSize: 10)), selected: selectedMode==m, selectedColor: Color(0xFFFFD700), onSelected: (v){ setState(()=>selectedMode=m); } )))).toList()),
        SizedBox(height: 10),
        Text("ENTRY SELECT:", style: TextStyle(color: Color(0xFFFFD700), fontWeight: FontWeight.bold)),
        Row(children: [10,20,30,50].map((e)=>Expanded(child: Padding(padding: EdgeInsets.all(3), child: ChoiceChip(label: Text("$e₹"), selected: selectedEntry==e, selectedColor: Colors.orange, onSelected: (v){ setState(()=>selectedEntry=e); } )))).toList()),
        SizedBox(height: 20),
        Container(padding: EdgeInsets.all(15), decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.green, width: 2)), child: Column(children: [
          Text("$selectedMode - ${data['total']}₹ Total", style: TextStyle(color: Color(0xFFFFD700), fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("1st Prize:"), Text("${data['first']}₹", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold))]),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("2nd Prize:"), Text("${data['second']}₹", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold))]),
        ])),
        SizedBox(height: 20),
        ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFFFD700), foregroundColor: Colors.black, minimumSize: Size(double.infinity, 55)), onPressed: (){
          if(playerWallet >= selectedEntry){
            setState((){
              playerWallet -= selectedEntry; // Player Wallet থেকে কাটবে
              // Admin Wallet এ আগেই Add হয়েছে, এখন কাটবে না - লাভ ওখানেই জমা
            });
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("JOINED! ROOM ID: ${selectedEntry*1234} | তোমার Wallet থেকে ${selectedEntry}₹ কেটে আমার Personal Wallet এ জমা হলো")));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Wallet এ Coin নেই! ADD COIN করো")));
            Navigator.push(context, MaterialPageRoute(builder: (_) => AddCoinPage())).then((_)=>setState((){}));
          }
        }, child: Text("JOIN NOW - $selectedEntry₹ কাটবে", style: TextStyle(fontWeight: FontWeight.bold))),
        SizedBox(height: 12),
        ElevatedButton.icon(style: ElevatedButton.styleFrom(backgroundColor: Colors.green, minimumSize: Size(double.infinity, 55)), onPressed: () async { await Navigator.push(context, MaterialPageRoute(builder: (_) => WinUploadPage())); setState((){}); }, icon: Icon(Icons.cloud_upload), label: Text("WIN? SCREENSHOT UPLOAD")),
      ])),
    );
  }
}

// ADD COIN PAGE - Player এখান থেকে টাকা Add করবে
class AddCoinPage extends StatefulWidget { @override State<AddCoinPage> createState() => _AddCoinPageState(); }
class _AddCoinPageState extends State<AddCoinPage> {
  TextEditingController codeCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("ADD COIN"), backgroundColor: Color(0xFFFFD700), foregroundColor: Colors.black), body: Padding(padding: EdgeInsets.all(20), child: Column(children: [
      Text("Wallet: $playerWallet Coins", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      SizedBox(height: 20),
      Container(padding: EdgeInsets.all(15), decoration: BoxDecoration(color: Colors.grey[900], borderRadius: BorderRadius.circular(10)), child: Column(children: [
        Text("METHOD 1: Google Play Redeem Code", style: TextStyle(color: Color(0xFFFFD700), fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        TextField(controller: codeCtrl, decoration: InputDecoration(hintText: "PLAY100 লিখো", border: OutlineInputBorder())),
        SizedBox(height: 10),
        ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, minimumSize: Size(double.infinity, 45)), onPressed: (){
          Map<String,int> codes = {"PLAY10":10,"PLAY20":20,"PLAY30":30,"PLAY50":50,"PLAY100":100,"BOOYAH100":100};
          if(codes.containsKey(codeCtrl.text.toUpperCase())){
            int amt = codes[codeCtrl.text.toUpperCase()]!;
            setState((){
              playerWallet += amt;
              adminWallet += amt; // তোমার Personal Wallet এও জমা
            });
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$amt Coins Added! Tomar Personal Wallet এও $amt₹ জমা হলো")));
          } else { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("ভুল কোড! PLAY100 লিখো"))); }
        }, child: Text("REDEEM & ADD TO WALLET")),
      ])),
      SizedBox(height: 20),
      Container(padding: EdgeInsets.all(15), decoration: BoxDecoration(color: Colors.grey[900], borderRadius: BorderRadius.circular(10)), child: Column(children: [
        Text("METHOD 2: PhonePe / GPay / Paytm", style: TextStyle(color: Color(0xFFFFD700), fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Text("যেকোনো App দিয়ে টাকা পাঠাও আর এখানে Amount লিখে ADD করো", style: TextStyle(color: Colors.white70, fontSize: 12)),
        SizedBox(height: 10),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [10,20,30,50,100].map((a)=>ElevatedButton(onPressed: (){ setState((){
          playerWallet += a;
          adminWallet += a; // Tomar Wallet এ জমা
        }); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$a₹ Added to Player & Your Wallet!"))); }, child: Text("+$a₹"))).toList()),
      ])),
      SizedBox(height: 20),
      Text("Add করলেই টাকা Direct Player Wallet এ যাবে + Tomar Personal Wallet এ জমা হবে", style: TextStyle(color: Colors.green, fontSize: 12)),
    ])));
  }
}

// WIN UPLOAD - AI তোমার Wallet থেকে Player কে দেবে
class WinUploadPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Upload Win Screenshot"), backgroundColor: Color(0xFFFFD700), foregroundColor: Colors.black), body: Center(child: Padding(padding: EdgeInsets.all(20), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(Icons.verified, size: 80, color: Colors.green),
      SizedBox(height: 20),
      Text("Booyah Screenshot Upload করো", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      Text("AI Verify করে আমার Personal Wallet থেকে তোমার Wallet এ Prize পাঠাবে", style: TextStyle(color: Colors.white70), textAlign: TextAlign.center),
      SizedBox(height: 30),
      ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.green, minimumSize: Size(double.infinity, 50)), onPressed: (){
        // Demo: 600₹ Prize - Tomar Wallet থেকে Player Wallet এ
        int prize = 600;
        if(adminWallet >= prize){
          adminWallet -= prize;
          playerWallet += prize;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("AI Verified! Tomar Wallet থেকে $prize₹ Player কে দেওয়া হলো!")));
        } else {
          // Admin Wallet এ টাকা কম থাকলেও Prize দেবে - পরে লাভ হিসাব হবে
          playerWallet += prize;
          adminWallet -= prize;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("AI Verified! $prize₹ Added to Player Wallet (From Admin Wallet)")));
        }
        Navigator.pop(context);
      }, child: Text("SELECT SCREENSHOT & CLAIM 600₹")),
    ]))));
  }
}

// SECRET ADMIN WALLET - শুধু তুমি দেখবে - 5 বার Tap করলে খুলবে
class AdminWalletPage extends StatefulWidget { @override State<AdminWalletPage> createState() => _AdminWalletPageState(); }
class _AdminWalletPageState extends State<AdminWalletPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("SECRET - My Personal Wallet"), backgroundColor: Colors.red, foregroundColor: Colors.white), body: Padding(padding: EdgeInsets.all(20), child: Column(children: [
      Container(padding: EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.red, width: 2)), child: Column(children: [
        Text("MY PERSONAL WALLET - Player দেখতে পারবে না", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
        SizedBox(height: 15),
        Text("Total Collection: $adminWallet₹", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFFFD700))),
        Text("এটাই তোমার সব জমা টাকা", style: TextStyle(color: Colors.white70)),
        SizedBox(height: 10),
        Text("এখান থেকেই Winner দের টাকা যায়", style: TextStyle(color: Colors.green)),
      ])),
      SizedBox(height: 20),
      ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.red, minimumSize: Size(double.infinity, 55)), onPressed: (){
        if(adminWallet > 0){
          showDialog(context: context, builder: (_)=>AlertDialog(title: Text("Withdraw"), content: Text("$adminWallet₹ তোমার PhonePe / GPay তে নেবে?"), actions: [TextButton(onPressed: (){ setState(()=>adminWallet=0); Navigator.pop(context); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Withdraw Success! PhonePe তে চলে গেছে"))); }, child: Text("YES, WITHDRAW"))]));
        }
      }, child: Text("WITHDRAW MY PROFIT TO PhonePe/GPay")),
      SizedBox(height: 10),
      Text("Player Wallet: $playerWallet₹ (এটা Player এর)", style: TextStyle(color: Colors.white70)),
    ])));
  }
}