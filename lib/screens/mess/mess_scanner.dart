import 'package:campus_ease/screens/mess/mess_review_screen.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart' as mobile_scanner;
import 'package:mobile_scanner/mobile_scanner.dart';

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
    return Scaffold(
        appBar: AppBar(
          title: const Text('Mess Review'),
          actions: [
            IconButton(
              color: Colors.white,
              icon: ValueListenableBuilder(
                valueListenable: cameraController.torchState,
                builder: (context, state, child) {
                  switch (state) {
                    case mobile_scanner.TorchState.off:
                      return const Icon(Icons.flashlight_off_rounded,
                          size: 22, color: Colors.black);
                    case mobile_scanner.TorchState.on:
                      return const Icon(Icons.flashlight_on_rounded,
                          size: 22, color: Colors.yellow);
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
                      return const Icon(
                        Icons.flip_camera_android_sharp,
                        size: 22,
                        color: Colors.black,
                      );
                    case mobile_scanner.CameraFacing.back:
                      return const Icon(
                        Icons.flip_camera_android_sharp,
                        size: 22,
                        color: Colors.black,
                      );
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
                  if (barcode.rawValue == "Mess") {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MessReviewScreen()));
                  }
                }
              },
            ),
            Center(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xFF8CBBF1),
                    width: 3,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                height: 200,
                width: 200,
              ),
            ),
          ],
        ));
  }
}
