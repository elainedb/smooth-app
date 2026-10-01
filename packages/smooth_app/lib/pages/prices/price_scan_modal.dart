import 'package:flutter/material.dart';
import 'package:matomo_tracker/matomo_tracker.dart';
import 'package:smooth_app/helpers/analytics_helper.dart';
import 'package:smooth_app/helpers/camera_helper.dart';
import 'package:smooth_app/helpers/global_vars.dart';
import 'package:smooth_app/helpers/haptic_feedback_helper.dart';
import 'package:smooth_app/l10n/app_localizations.dart';
import 'package:smooth_app/pages/scan/camera_scan_page.dart';
import 'package:smooth_app/resources/app_icons.dart' as icons;

Future<String?> showSingleBarcodeScanner(BuildContext context) {
  return showModalBottomSheet<String>(
    context: context,
    backgroundColor: Colors.black,
    isScrollControlled: true,
    builder: (BuildContext context) {
      final Size size = MediaQuery.sizeOf(context);
      return SizedBox(
        height: size.height * 0.4,
        child: const _BarcodeScannerView(),
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
  bool _mutex = false;

  @override
  String get actionName => 'Opened single barcode scanner modal';

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context);
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: GlobalVars.barcodeScanner.getScanner(
            onScan: (final String barcode) async {
              if (_mutex) {
                return false;
              }
              _mutex = true;
              Navigator.of(context).pop(barcode);
              return true;
            },
            hapticFeedback: () => SmoothHapticFeedback.click(),
            onCameraFlashError: CameraScannerPage.onCameraFlashError,
            trackCustomEvent: AnalyticsHelper.trackCustomEvent,
            hasMoreThanOneCamera: CameraHelper.hasMoreThanOneCamera,
            toggleCameraModeTooltip: appLocalizations.camera_toggle_camera,
            toggleFlashModeTooltip: appLocalizations.camera_toggle_flash,
            barcodeScannerIcon: const icons.Search.off(),
            torchOnIcon: const icons.Torch.on(),
            torchOffIcon: const icons.Torch.off(),
            contentPadding: null,
          ),
        ),
        const Positioned(
          top: 8.0,
          left: 0,
          right: 0,
          child: Center(
            child: _DragHandle(),
          ),
        ),
      ],
    );
  }
}

class _DragHandle extends StatelessWidget {
  const _DragHandle();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Size? dragHandleSize = theme.bottomSheetTheme.dragHandleSize;
    return Container(
      width: dragHandleSize?.width ?? 32.0,
      height: dragHandleSize?.height ?? 4.0,
      decoration: BoxDecoration(
        color: Colors.blueGrey,
        borderRadius: BorderRadius.circular(
            (dragHandleSize?.height ?? 4.0) / 2.0),
      ),
    );
  }
}