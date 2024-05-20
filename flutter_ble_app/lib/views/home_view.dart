import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_ble_app/views/scan_view.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late bool _isScanning;

  late BluetoothConnectionState _bluetoothConnectionState;

  late List<ScanResult> _scanResults;
  late StreamSubscription<List<ScanResult>> _scanResultsSubscription;
  late StreamSubscription<bool> _isScanningSubscription;

  @override
  void initState() {
    super.initState();
    _scanResults = [];
    _isScanning = false;

    _bluetoothConnectionState = BluetoothConnectionState.disconnected;
    _scanResultsSubscription = FlutterBluePlus.scanResults.listen(
      (results) {
        _scanResults = results;
        if (mounted) setState(() {});
      },
      onError: (e) => print('Error scan result subscription: $e'),
    );

    _isScanningSubscription = FlutterBluePlus.isScanning.listen((state) {
      if (mounted) setState(() => _isScanning = state);
    });

    scanDevice();
  }

  @override
  void dispose() {
    _scanResultsSubscription.cancel();
    _isScanningSubscription.cancel();
    super.dispose();
  }

  Future scanDevice() async {
    _scanResults.clear();

    try {
      int divisor = Platform.isAndroid ? 8 : 1;
      await FlutterBluePlus.startScan(
        timeout: const Duration(seconds: 15),
        continuousUpdates: true,
        continuousDivisor: divisor,
      );
    } catch (e) {
      print('Error scan device method: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child:
            _bluetoothConnectionState == BluetoothConnectionState.disconnected
                ? ScanPage(
                    scanResults: _scanResults,
                    connect: (p0) {},
                    isScanning: _isScanning,
                    timerValue: 15,
                  )
                : const SizedBox.shrink(),
      ),
    );
  }
}
