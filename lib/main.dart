import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

/// Main app widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: IPDisplayScreen(), // Entry screen
    );
  }
}

/// Screen that displays the fetched public IP
class IPDisplayScreen extends StatefulWidget {
  const IPDisplayScreen({super.key});

  @override
  State<IPDisplayScreen> createState() => _IPDisplayScreenState();
}

class _IPDisplayScreenState extends State<IPDisplayScreen> {
  // Define the platform channel to talk to native iOS code
  static const platform = MethodChannel('com.example.iosProxyApp/ip');

  // Public IP string shown on screen
  String _ip = 'Fetching...';

  @override
  void initState() {
    super.initState();
    _fetchIP(); // Fetch IP when the widget initializes
  }

  /// Fetches the public IP from native iOS code
  Future<void> _fetchIP() async {
    try {
      // Call the native method via platform channel
      final String result = await platform.invokeMethod('getPublicIP');

      // Update the UI with the fetched IP
      setState(() {
        _ip = result;
      });
    } on PlatformException catch (e) {
      // In case of an error, show the error message
      setState(() {
        _ip = 'Error: ${e.message}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Public IP: $_ip', // Display the result
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
