import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: Colors.black),
      home: PinScreen(),
    );
  }
}

// --- PIN SCREEN ---
class PinScreen extends StatefulWidget {
  @override State<PinScreen> createState() => _PinScreenState();
}
class _PinScreenState extends State<PinScreen> {
  String pin = "";
  @override Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(Icons.account_balance_wallet, size: 80, color: Color(0xFF00FF82)),
      SizedBox(height: 15),
      Text("QUICK PAY X", style: TextStyle(color: Color(0xFF00FF82), fontSize: 28, fontWeight: FontWeight.bold)),
      SizedBox(height: 10),
      Text("PIN: $pin", style: TextStyle(fontSize: 22, letterSpacing: 8)),
      SizedBox(height: 20),
      Wrap(spacing: 15, runSpacing: 15, alignment: WrapAlignment.center, children: [
        for(int i=1;i<=9;i++) _numBtn("$i"),
        _numBtn("0"),
        ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF00FF82), padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15)), onPressed: (){
          if(pin=="1234"){ Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>HomeScreen())); }
          else { setState(()=>pin=""); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Wrong PIN! Default 1234"))); }
        }, child: Text("OK", style: TextStyle(color: Colors.black))),
      ]),
      TextButton(onPressed: ()=>setState(()=>pin=""), child: Text("Clear", style: TextStyle(color: Colors.white54)))
    ])));
  }
  Widget _numBtn(String n) => ElevatedButton(
    style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF1A1A1A), padding: EdgeInsets.all(20)),
    onPressed: (){ if(pin.length<4) setState(()=>pin+=n); },
    child: Text(n, style: TextStyle(fontSize: 20)),
  );
}

// --- HOME SCREEN ---
class HomeScreen extends StatefulWidget {
  @override State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  double balance = 12540;
  List<String> history = [];

  @override void initState(){ super.initState(); _loadBalance(); }

  _loadBalance() async {
    final prefs = await SharedPreferences.getInstance();
    setState((){
      balance = prefs.getDouble('balance')?? 12540;
      history = prefs.getStringList('history')?? [];
    });
  }
  _saveBalance() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble('balance', balance);
    prefs.setStringList('history', history);
  }

  @override Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("QUICK PAY X"), backgroundColor: Colors.black, centerTitle: true),
      body: Padding(padding: EdgeInsets.all(20), child: Column(children: [
        Container(width: double.infinity, padding: EdgeInsets.all(25), decoration: BoxDecoration(color: Color(0xFF00FF82), borderRadius: BorderRadius.circular(25)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("WALLET BALANCE", style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text("₹ ${balance.toStringAsFixed(2)}", style: TextStyle(color: Colors.black, fontSize: 36, fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            Text("Tap My QR to receive money", style: TextStyle(color: Colors.black54, fontSize: 12)),
          ])),
        SizedBox(height: 30),
        Row(children: [
          Expanded(child: _actionBtn(context, Icons.qr_code, "My QR", (){ Navigator.push(context, MaterialPageRoute(builder: (_)=>MyQRScreen(onMoneyReceived: (amt){
            setState((){ balance+=amt; history.insert(0, "+ ₹$amt Received - ${DateTime.now().hour}:${DateTime.now().minute}"); }); _saveBalance();
          }))); })),
          SizedBox(width: 15),
          Expanded(child: _actionBtn(context, Icons.qr_code_scanner, "Scan & Pay", () async {
            final result = await Navigator.push(context, MaterialPageRoute(builder: (_)=>ScanScreen()));
            if(result!=null && result is double){ setState((){ balance-=result; history.insert(0, "- ₹$result Paid to Shop - ${DateTime.now().hour}:${DateTime.now().minute}"); }); _saveBalance(); }
          })),
        ]),
        SizedBox(height: 15),
        Row(children: [
          Expanded(child: _actionBtn(context, Icons.history, "History", (){ Navigator.push(context, MaterialPageRoute(builder: (_)=>HistoryScreen(history: history))); })),
          SizedBox(width: 15),
          Expanded(child: _actionBtn(context, Icons.add, "Add Money (Test)", (){
            setState((){ balance+=500; history.insert(0, "+ ₹500 Test Added"); }); _saveBalance();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("₹500 Added for testing!")));
          })),
        ]),
      ])),
    );
  }
  Widget _actionBtn(BuildContext ctx, IconData ic, String lb, VoidCallback onTap) => InkWell(onTap: onTap, child: Container(padding: EdgeInsets.symmetric(vertical: 22), decoration: BoxDecoration(color: Color(0xFF1A1A1A), borderRadius: BorderRadius.circular(18), border: Border.all(color: Color(0xFF00FF82).withOpacity(0.2))), child: Column(children: [Icon(ic, color: Color(0xFF00FF82), size: 32), SizedBox(height: 8), Text(lb, style: TextStyle(fontWeight: FontWeight.bold))])));
}

// --- MY QR SCREEN (Receive Money) ---
class MyQRScreen extends StatefulWidget {
  final Function(double) onMoneyReceived;
  MyQRScreen({required this.onMoneyReceived});
  @override State<MyQRScreen> createState() => _MyQRScreenState();
}
class _MyQRScreenState extends State<MyQRScreen> {
  TextEditingController upiController = TextEditingController(text: "bidhan@upi");
  TextEditingController nameController = TextEditingController(text: "Bidhan");
  TextEditingController amountController = TextEditingController();

  String get upiString {
    String pa = upiController.text.trim();
    String pn = nameController.text.trim();
    String am = amountController.text.trim();
    if(am.isNotEmpty) return "upi://pay?pa=$pa&pn=$pn&am=$am&cu=INR";
    return "upi://pay?pa=$pa&pn=$pn&cu=INR";
  }

  @override Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My QR - Receive Money"), backgroundColor: Colors.black),
      body: SingleChildScrollView(padding: EdgeInsets.all(20), child: Column(children: [
        TextField(controller: upiController, decoration: InputDecoration(labelText: "Your UPI ID (e.g. 6290xxxx@paytm)", border: OutlineInputBorder())),
        SizedBox(height: 10),
        TextField(controller: nameController, decoration: InputDecoration(labelText: "Your Name", border: OutlineInputBorder())),
        SizedBox(height: 10),
        TextField(controller: amountController, keyboardType: TextInputType.number, onChanged: (_)=>setState((){}), decoration: InputDecoration(labelText: "Amount (Optional - leave blank for any amount)", border: OutlineInputBorder())),
        SizedBox(height: 20),
        Container(padding: EdgeInsets.all(15), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)), child: QrImageView(data: upiString, version: QrVersions.auto, size: 280)),
        SizedBox(height: 15),
        Text("Anyone can scan with PhonePe, GPay, Paytm to pay you!", style: TextStyle(color: Colors.white54), textAlign: TextAlign.center),
        SizedBox(height: 15),
        ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF00FF82), minimumSize: Size(double.infinity, 50)), onPressed: (){ launchUrl(Uri.parse(upiString)); }, child: Text("Test My UPI Link", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
        SizedBox(height: 10),
        ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.white10, minimumSize: Size(double.infinity, 50)), onPressed: (){
          String amt = amountController.text;
          if(amt.isNotEmpty){ double v = double.tryParse(amt)?? 0; if(v>0){ widget.onMoneyReceived(v); Navigator.pop(context); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("₹$v Received in Wallet!"))); } }
        }, child: Text("Simulate Payment Received (Demo)", style: TextStyle(color: Color(0xFF00FF82)))),
      ])),
    );
  }
}

// --- SCAN SCREEN (Pay to Shop) ---
class ScanScreen extends StatefulWidget {
  @override State<ScanScreen> createState() => _ScanScreenState();
}
class _ScanScreenState extends State<ScanScreen> {
  bool scanned = false;
  @override Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Scan QR to Pay"), backgroundColor: Colors.black),
      body: Stack(children: [
        MobileScanner(onDetect: (capture){
          if(scanned) return;
          final code = capture.barcodes.first.rawValue;
          if(code==null) return;
          setState(()=>scanned=true);
          _handleCode(code);
        }),
        Center(child: Container(width: 250, height: 250, decoration: BoxDecoration(border: Border.all(color: Color(0xFF00FF82), width: 3), borderRadius: BorderRadius.circular(20)))),
      ]),
    );
  }
  _handleCode(String code) {
    double amount = 0;
    String to = "Shop";
    if(code.contains("upi://")){
      Uri uri = Uri.parse(code);
      amount = double.tryParse(uri.queryParameters['am']?? "0")?? 0;
      to = uri.queryParameters['pn']?? uri.queryParameters['pa']?? "Shop";
      if(amount==0){
        // If amount not in QR, ask user
        showDialog(context: context, builder: (_) {
          TextEditingController c = TextEditingController();
          return AlertDialog(title: Text("Pay to $to"), content: TextField(controller: c, keyboardType: TextInputType.number, decoration: InputDecoration(hintText: "Enter Amount")), actions: [
            TextButton(onPressed: (){ Navigator.pop(context); setState(()=>scanned=false); }, child: Text("Cancel")),
            TextButton(onPressed: (){ double v = double.tryParse(c.text)?? 0; Navigator.pop(context); Navigator.pop(context, v); }, child: Text("Pay")),
          ]);
        });
        return;
      }
    } else {
      amount = 10; // fallback for normal QR
    }

    showDialog(context: context, barrierDismissible: false, builder: (_) => AlertDialog(
      backgroundColor: Color(0xFF1A1A1A),
      title: Text("Confirm Payment"),
      content: Text("Pay ₹${amount.toStringAsFixed(2)} to $to?\nFrom your QUICK PAY X Wallet"),
      actions: [
        TextButton(onPressed: (){ Navigator.pop(context); setState(()=>scanned=false); }, child: Text("Cancel")),
        ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF00FF82)), onPressed: (){ Navigator.pop(context); Navigator.pop(context, amount); }, child: Text("Pay", style: TextStyle(color: Colors.black))),
      ],
    ));
  }
}

class HistoryScreen extends StatelessWidget {
  final List<String> history;
  HistoryScreen({required this.history});
  @override Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Transaction History"), backgroundColor: Colors.black), body: history.isEmpty? Center(child: Text("No Transactions", style: TextStyle(color: Colors.white54))) : ListView.builder(padding: EdgeInsets.all(15), itemCount: history.length, itemBuilder: (_, i) => Card(color: Color(0xFF1A1A1A), child: ListTile(leading: Icon(history[i].startsWith("+")? Icons.arrow_downward : Icons.arrow_upward, color: history[i].startsWith("+")? Colors.green : Colors.red), title: Text(history[i], style: TextStyle(color: Colors.white))))));
  }
}