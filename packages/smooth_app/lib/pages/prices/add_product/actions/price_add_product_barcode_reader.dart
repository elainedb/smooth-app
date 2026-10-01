part of '../price_add_product_action.dart';

class _PriceAddProductActionBarcodeReader extends PriceAddProductAction {
  const _PriceAddProductActionBarcodeReader();

  @override
  String label(AppLocalizations appLocalizations) =>
      appLocalizations.prices_barcode_reader_action;

  @override
  Widget icon(BuildContext context) => const Icon(Icons.barcode_reader);

  @override
  Future<void> execute(BuildContext context) async {
    final UserPreferences userPreferences = context.read<UserPreferences>();
    final bool multiScan = userPreferences.getFlag(
          UserPreferencesDevMode.userPreferencesFlagPricesReceiptMultiSelection,
        ) ??
        false;

    final List<String> barcodes = <String>[];
    if (multiScan) {
      final List<String>? scanResult = await Navigator.push<List<String>>(
        context,
        MaterialPageRoute<List<String>>(
          builder: (BuildContext context) => PriceScanPage(
            latestScannedBarcode: null,
            isMultiProducts: multiScan,
          ),
        ),
      );
      if (scanResult != null) {
        barcodes.addAll(scanResult);
      }
    } else {
      final String? barcode = await showSingleBarcodeScanner(context);
      if (barcode != null) {
        barcodes.add(barcode);
      }
    }

    if (context.mounted) {
      await _addBarcodesToList(barcodes, context);
    }
  }
}
