import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_ble_app/consts/ble_const.dart';
import 'package:flutter_ble_app/views/scan_view.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late bool _isScanning;

  late BluetoothConnectionState _bluetoothConnectionState;
  late BluetoothCharacteristic? _selectedCharacteristic;

  late List<ScanResult> _scanResults;
  late StreamSubscription<bool> _isScanningSubscription;

  @override
  void initState() {
    super.initState();
    _scanResults = [];
    _isScanning = false;

    _bluetoothConnectionState = BluetoothConnectionState.disconnected;
    FlutterBluePlus.scanResults.listen(
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

  Future getCharacteristic({required int selectedDeviceIndex}) async {
    List<BluetoothService> services =
        await _scanResults[selectedDeviceIndex].device.discoverServices();
    for (BluetoothService service in services) {
      for (BluetoothCharacteristic characteristic in service.characteristics) {
        if (characteristic.uuid.toString() == mCharacteristicUuid) {
          _selectedCharacteristic = characteristic;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: _bluetoothConnectionState ==
                BluetoothConnectionState.disconnected
            ? ScanPage(
                scanResults: _scanResults,
                isScanning: _isScanning,
                timerValue: 15,
                connect: (index) async {
                  await _scanResults[index].device.connect().then(
                        (value) => getCharacteristic(
                          selectedDeviceIndex: index,
                        ),
                      );
                  Fluttertoast.showToast(
                    msg: '${_scanResults[index].device.platformName} connected',
                  );
                },
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}
