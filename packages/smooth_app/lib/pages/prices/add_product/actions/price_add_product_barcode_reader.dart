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
    final bool isMultiProducts = userPreferences.getFlag(
          UserPreferencesDevMode.userPreferencesFlagPricesReceiptMultiSelection,
        ) ??
        false;

    final List<String>? barcodes;
    if (isMultiProducts) {
      barcodes = await Navigator.of(context).push<List<String>>(
        MaterialPageRoute<List<String>>(
          builder: (BuildContext context) => PriceScanPage(
            latestScannedBarcode: null,
            isMultiProducts: true,
          ),
        ),
      );
    } else {
      final String? barcode = await showSingleBarcodeScanner(context);
      barcodes = barcode != null ? <String>[barcode] : null;
    }

    if (barcodes == null || barcodes.isEmpty) {
      return;
    }
    if (!context.mounted) {
      return;
    }
    await _addBarcodesToList(barcodes, context);
  }
}
