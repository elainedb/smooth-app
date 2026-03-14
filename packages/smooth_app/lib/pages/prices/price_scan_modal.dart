import 'package:flutter/material.dart';
import 'package:smooth_app/l10n/app_localizations.dart';
import 'package:matomo_tracker/matomo_tracker.dart';
import 'package:smooth_app/generic_lib/bottom_sheets/smooth_bottom_sheet.dart';
import 'package:smooth_app/pages/prices/price_scan_page.dart';

Future<String?> showSingleBarcodeScanner(BuildContext context) async {
  MatomoTracker.instance.trackEvent(
    eventInfo: EventInfo(
      category: 'scanner',
      action: 'scanner_modal',
    ),
  );

  final AppLocalizations appLocalizations = AppLocalizations.of(context);
  final List<String>? barcodes = await showSmoothModalSheet<List<String>?>(
    context: context,
    isScrollControlled: true,
    minHeight: 0.8,
    builder: (BuildContext context) {
      return SmoothModalSheet(
        title: appLocalizations.prices_barcode_reader_action,
        body: const SizedBox(
          height: 400,
          child: PriceScanPage(
            latestScannedBarcode: null,
            isMultiProducts: false,
          ),
        ),
      );
    },
  );

  return barcodes != null && barcodes.isNotEmpty ? barcodes.first : null;
}
