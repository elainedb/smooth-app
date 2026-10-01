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
    final List<String> barcodes = <String>[];
    if (userPreferences.userPricesMultipleScansMode) {
      final List<String>? result =
          await Navigator.of(context).push<List<String>>(
        MaterialPageRoute<List<String>>(
          builder: (BuildContext context) =>
              const PriceScanPage(latestScannedBarcode: null, isMultiProducts: true),
        ),
      );
      if (result != null) {
        barcodes.addAll(result);
      }
    } else {
      final String? barcode = await showSingleBarcodeScanner(context);
      if (barcode != null) {
        barcodes.add(barcode);
      }
    }
    if (context.mounted && barcodes.isNotEmpty) {
      await _addBarcodesToList(barcodes, context);
    }
  }
}
