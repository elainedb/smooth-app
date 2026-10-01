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
        body: Form(
          key: formKey,
          child: SmoothTextFormField(
            type: TextFieldTypes.PLAIN_TEXT,
            controller: barcodeController,
            textInputType: TextInputType.number,
            hintText: appLocalizations.prices_barcode_enter,
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return appLocalizations.prices_barcode_enter;
              }
              final String cleanBarcode = _getCleanBarcode(value);
              if (!_isValidBarcode(cleanBarcode)) {
                return appLocalizations.barcode_invalid_error;
              }
              return null;
            },
          ),
        ),
        positiveAction: SmoothActionButton(
          text: appLocalizations.okay,
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

    if (barcode != null && context.mounted) {
      await _addBarcodesToList(<String>[barcode], context);
    }
  }

  bool _isValidBarcode(final String barcode) => barcode.length >= 8;

  String _getCleanBarcode(final String input) {
    return input.replaceAll(RegExp(r'[^0-9]'), '');
  }
}
