part of '../price_add_product_action.dart';

class _PriceAddProductActionBarcodeReader extends PriceAddProductAction {
  @override
  String label(AppLocalizations appLocalizations) =>
      appLocalizations.prices_barcode_reader_action;

  @override
  Widget icon(BuildContext context) => const Icon(Icons.barcode_reader);

  @override
  Future<void> execute(BuildContext context) async {
    final List<String>? barcodes = await Navigator.of(context).push<List<String>>(
      MaterialPageRoute<List<String>>(
        builder: (BuildContext context) => const PriceScanPage(
          latestScannedBarcode: null,
          isMultiProducts: false,
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
  }
}
