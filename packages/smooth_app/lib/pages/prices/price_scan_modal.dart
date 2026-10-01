import 'package:flutter/material.dart';
import 'package:matomo_tracker/matomo_tracker.dart';
import 'package:smooth_app/helpers/analytics_helper.dart';
import 'package:smooth_app/helpers/camera_helper.dart';
import 'package:smooth_app/helpers/global_vars.dart';
import 'package:smooth_app/helpers/haptic_feedback_helper.dart';
import 'package:smooth_app/l10n/app_localizations.dart';
import 'package:smooth_app/resources/app_icons.dart' as icons;

/// Shows a modal bottom sheet with a barcode scanner for single barcode scanning.
Future<String?> showSingleBarcodeScanner(BuildContext context) {
  return showModalBottomSheet<String>(
    context: context,
    backgroundColor: Colors.black,
    constraints: BoxConstraints(
      maxHeight: MediaQuery.sizeOf(context).height * 0.4,
    ),
    builder: (BuildContext context) => const _BarcodeScannerView(),
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
  String get actionName =>
      'Opened ${GlobalVars.barcodeScanner.getType()}_modal for price';

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context);
    final BottomSheetThemeData bottomSheetTheme =
        Theme.of(context).bottomSheetTheme;

    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(28.0),
            ),
            child: GlobalVars.barcodeScanner.getScanner(
              onScan: (final String barcode) async {
                if (_mutex) {
                  return false;
                }
                _mutex = true;
                if (context.mounted) {
                  Navigator.of(context).pop(barcode);
                }
                return true;
              },
              hapticFeedback: () => SmoothHapticFeedback.click(),
              onCameraFlashError: (_) {},
              trackCustomEvent: AnalyticsHelper.trackCustomEvent,
              hasMoreThanOneCamera: CameraHelper.hasMoreThanOneCamera,
              toggleCameraModeTooltip:
                  appLocalizations.camera_toggle_camera,
              toggleFlashModeTooltip: appLocalizations.camera_toggle_flash,
              barcodeScannerIcon: const icons.Search.off(),
              torchOnIcon: const icons.Torch.on(),
              torchOffIcon: const icons.Torch.off(),
              contentPadding: null,
            ),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: _DragHandle(
            size: bottomSheetTheme.dragHandleSize ?? const Size(32, 4),
          ),
        ),
      ],
    );
  }
}

class _DragHandle extends StatelessWidget {
  const _DragHandle({required this.size});

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(top: 8.0),
      child: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
          color: Colors.blueGrey,
          borderRadius: BorderRadius.circular(size.height / 2),
        ),
      ),
    );
  }
}
