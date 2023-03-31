import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart' as mobile_scanner;
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';

import '../../apis/allAPIs.dart';
import '../../notifiers/authNotifier.dart';

class OutingInOut extends StatefulWidget {
  const OutingInOut({super.key});

  @override
  State<OutingInOut> createState() => _OutingInOutState();
}

class _OutingInOutState extends State<OutingInOut> {
  mobile_scanner.MobileScannerController cameraController =
      mobile_scanner.MobileScannerController();
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Outing Window'),
          actions: [
            IconButton(
              color: Colors.white,
              icon: ValueListenableBuilder(
                valueListenable: cameraController.torchState,
                builder: (context, state, child) {
                  switch (state) {
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
                  switch (state) {
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
                  if (barcode.rawValue == "Outing") {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Outing'),
                            content: const Text('Are you sure?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('No'),
                              ),
                              TextButton(
                                onPressed: () {
                                  outingInOut(
                                      authNotifier.userDetails!.enrollNo,
                                      context);
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Yes'),
                              ),
                            ],
                          );
                        });
                  }
                }
              },
            ),
          ],
        ));
  }
}
