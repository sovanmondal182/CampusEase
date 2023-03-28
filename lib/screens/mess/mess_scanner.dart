import 'dart:typed_data';

import 'package:campus_ease/screens/mess/mess_review_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile_scanner/mobile_scanner.dart' as mobile_scanner;
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';

import '../../apis/foodAPIs.dart';
import '../../notifiers/authNotifier.dart';

class MessScanner extends StatefulWidget {
  const MessScanner({super.key});

  @override
  State<MessScanner> createState() => _MessScannerState();
}

class _MessScannerState extends State<MessScanner> {
  mobile_scanner.MobileScannerController cameraController =
      mobile_scanner.MobileScannerController();
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Mess Review'),
          actions: [
            IconButton(
              color: Colors.white,
              icon: ValueListenableBuilder(
                valueListenable: cameraController.torchState,
                builder: (context, state, child) {
                  switch (state as mobile_scanner.TorchState) {
                    case mobile_scanner.TorchState.off:
                      return const Icon(Icons.flash_off, color: Colors.grey);
                    case mobile_scanner.TorchState.on:
                      return const Icon(Icons.flash_on, color: Colors.yellow);
                  }
                },
              ),
              iconSize: 32.0,
              onPressed: () => cameraController.toggleTorch(),
            ),
            IconButton(
              color: Colors.white,
              icon: ValueListenableBuilder(
                valueListenable: cameraController.cameraFacingState,
                builder: (context, state, child) {
                  switch (state as mobile_scanner.CameraFacing) {
                    case mobile_scanner.CameraFacing.front:
                      return const Icon(Icons.camera_front);
                    case mobile_scanner.CameraFacing.back:
                      return const Icon(Icons.camera_rear);
                  }
                },
              ),
              iconSize: 32.0,
              onPressed: () => cameraController.switchCamera(),
            ),
          ],
        ),
        body: Stack(
          children: [
            mobile_scanner.MobileScanner(
              // fit: BoxFit.contain,
              controller: cameraController,
              onDetect: (capture) {
                final List<Barcode> barcodes = capture.barcodes;
                for (final barcode in barcodes) {
                  Navigator.pop(context);
                  print('Barcode found! ${barcode.rawValue}');
                  if (barcode.rawValue == "Mess") {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MessReviewScreen()));
                  }
                }
              },
            ),
          ],
        ));
  }
}