part of '../price_add_product_action.dart';

class _PriceAddProductActionBarcodeReader extends PriceAddProductAction {
  @override
  String label(AppLocalizations appLocalizations) =>
      appLocalizations.prices_barcode_reader_action;

  @override
  Widget icon(BuildContext context) => const Icon(Icons.barcode_reader);

  @override
  Future<void> execute(BuildContext context) async {
    final UserPreferences userPreferences = context.read<UserPreferences>();
    final bool isMultiProducts =
        userPreferences.getFlag(
          UserPreferencesDevMode
              .userPreferencesFlagPricesReceiptMultiSelection,
        ) ??
        false;

    if (isMultiProducts) {
      final List<String>? barcodes =
          await Navigator.of(context).push<List<String>>(
            MaterialPageRoute<List<String>>(
              builder: (BuildContext context) => const PriceScanPage(
                latestScannedBarcode: null,
                isMultiProducts: true,
              ),
            ),
          );
      if (barcodes == null || barcodes.isEmpty) {
        return;
      }
      if (!context.mounted) {
        return;
      }
      await _addBarcodesToList(barcodes, context);
    } else {
      final String? barcode = await showSingleBarcodeScanner(context);
      if (barcode == null) {
        return;
      }
      if (!context.mounted) {
        return;
      }
      await _addBarcodesToList(<String>[barcode], context);
    }
  }
}
