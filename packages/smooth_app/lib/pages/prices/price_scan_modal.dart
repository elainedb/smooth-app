import 'package:flutter/material.dart';
import 'package:matomo_tracker/matomo_tracker.dart';
import 'package:smooth_app/helpers/analytics_helper.dart';
import 'package:smooth_app/helpers/camera_helper.dart';
import 'package:smooth_app/helpers/global_vars.dart';
import 'package:smooth_app/helpers/haptic_feedback_helper.dart';
import 'package:smooth_app/pages/scan/camera_scan_page.dart';

Future<String?> showSingleBarcodeScanner(BuildContext context) async {
  return showModalBottomSheet<String>(
    context: context,
    backgroundColor: Colors.black,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.4,
        child: const Stack(
          children: <Widget>[
            _BarcodeScannerView(),
            Align(
              alignment: Alignment.topCenter,
              child: _DragHandle(),
            ),
          ],
        ),
      );
    },
  );
}

class _BarcodeScannerView extends StatefulWidget {
  const _BarcodeScannerView();

  @override
  State<_BarcodeScannerView> createState() => _BarcodeScannerViewState();
}

class _BarcodeScannerViewState extends State<_BarcodeScannerView>
    with TraceableClientMixin {
  @override
  String get actionName => 'price_barcode_scanner_modal';

  @override
  Widget build(BuildContext context) {
    return GlobalVars.barcodeScanner.getScanner(
      onScan: (final String barcode) async {
        if (!context.mounted) {
          return false;
        }
        Navigator.of(context).pop(barcode);
        return true;
      },
      hapticFeedback: () => SmoothHapticFeedback.click(),
      onCameraFlashError: CameraScannerPage.onCameraFlashError,
      trackCustomEvent: AnalyticsHelper.trackCustomEvent,
      hasMoreThanOneCamera: CameraHelper.hasMoreThanOneCamera,
      toggleCameraModeTooltip: 'Toggle camera', // not localized, it's just a tooltip
      toggleFlashModeTooltip: 'Toggle flash',
      barcodeScannerIcon: const Icon(Icons.qr_code_scanner),
      torchOffIcon: const Icon(Icons.flash_off),
      torchOnIcon: const Icon(Icons.flash_on),
    );
  }
}

class _DragHandle extends StatelessWidget {
  const _DragHandle();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8.0),
      height: 4.0,
      width: 32.0,
      decoration: BoxDecoration(
        color: Colors.blueGrey,
        borderRadius: BorderRadius.circular(2.0),
      ),
    );
  }
}
