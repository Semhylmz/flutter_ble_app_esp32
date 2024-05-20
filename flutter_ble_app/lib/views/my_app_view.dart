import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_ble_app/views/bluetooth_off_view.dart';
import 'package:flutter_ble_app/views/home_view.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late BluetoothAdapterState _bluetoothAdapterState;
  late StreamSubscription<BluetoothAdapterState> _adapterStateStateSubscription;

  @override
  void initState() {
    _bluetoothAdapterState = BluetoothAdapterState.unknown;
    _adapterStateStateSubscription =
        FlutterBluePlus.adapterState.listen((state) {
      _bluetoothAdapterState = state;
      if (mounted) setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _adapterStateStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget currentPage = _bluetoothAdapterState == BluetoothAdapterState.on
        ? const HomePage()
        : const BleOffPage();

    return MaterialApp(
      title: 'Flutter BLE App',
      home: currentPage,
    );
  }
}
