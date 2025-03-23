import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String barcodeResult = "Scan a barcode";

  Future<void> scanBarcode() async {
    String barcode = await FlutterBarcodeScanner.scanBarcode("#ff6666", "Cancel", true, ScanMode.BARCODE);
    if (barcode != "-1") {
      setState(() { barcodeResult = barcode; });
      FirebaseFirestore.instance.collection('scanned_medicines').add({'barcode': barcode, 'timestamp': DateTime.now()});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Medicine Authenticator")),
      body: Column(
        children: [
          Text(barcodeResult),
          ElevatedButton(onPressed: scanBarcode, child: Text("Scan Barcode")),
        ],
      ),
    );
  }
}


Future<void> verifyMedicine(String barcode) async {
  String apiUrl = "https://api.gs1.org/check_medicine/$barcode"; // Replace with actual GS1 API URL
  var response = await http.get(Uri.parse(apiUrl));
  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    // Display medicine details in UI
  } else {
    // Handle error
  }
}
