import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile_scanner/mobile_scanner.dart' as mobile_scanner;
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';

import '../../apis/allAPIs.dart';
import '../../notifiers/authNotifier.dart';

class LibraryInOut extends StatefulWidget {
  const LibraryInOut({super.key});

  @override
  State<LibraryInOut> createState() => _LibraryInOutState();
}

class _LibraryInOutState extends State<LibraryInOut> {
  mobile_scanner.MobileScannerController cameraController =
      mobile_scanner.MobileScannerController();
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Library Entry'),
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
                  if (barcode.rawValue == "Library") {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Library In-Out'),
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
                                  libraryInOut(
                                      authNotifier.userDetails!.enrollNo,
                                      context);
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Yes'),
                              ),
                            ],
                          );
                        });
                  } else {
                    Fluttertoast.showToast(
                        msg: "Invalid QR Code",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);
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
