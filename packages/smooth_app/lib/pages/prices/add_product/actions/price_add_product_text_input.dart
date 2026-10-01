part of '../price_add_product_action.dart';

class _PriceAddProductActionBarcodeInput extends PriceAddProductAction {
  const _PriceAddProductActionBarcodeInput();

  @override
  String label(AppLocalizations appLocalizations) =>
      appLocalizations.prices_barcode_enter;

  @override
  Widget icon(BuildContext context) => const Icon(Icons.text_fields);

  @override
  Future<void> execute(BuildContext context) async {
    final AppLocalizations appLocalizations = AppLocalizations.of(context);
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final TextEditingController barcodeController = TextEditingController();

    final String? barcode = await showDialog<String>(
      context: context,
      builder: (BuildContext context) => SmoothAlertDialog(
        title: appLocalizations.prices_barcode_enter,
        body: Form(
          key: formKey,
          child: SmoothTextFormField(
            type: TextFieldTypes.PLAIN_TEXT,
            controller: barcodeController,
            textInputType: TextInputType.number,
            hintText: appLocalizations.barcode_invalid_error,
            validator: (String? value) {
              if (value == null || !_isValidBarcode(value)) {
                return appLocalizations.barcode_invalid_error;
              }
              return null;
            },
          ),
        ),
        positiveAction: SmoothActionButton(
          text: appLocalizations.add,
          onPressed: () {
            if (formKey.currentState!.validate()) {
              Navigator.of(context).pop(_getCleanBarcode(barcodeController.text));
            }
          },
        ),
        negativeAction: SmoothActionButton(
          text: appLocalizations.cancel,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
    );

    barcodeController.dispose();

    if (context.mounted && barcode != null && barcode.isNotEmpty) {
      await _addBarcodesToList(<String>[barcode], context);
    }
  }

  bool _isValidBarcode(String barcode) {
    final String clean = _getCleanBarcode(barcode);
    return clean.length >= 8;
  }

  String _getCleanBarcode(String barcode) {
    return barcode.replaceAll(RegExp(r'[^0-9]'), '');
  }
}
