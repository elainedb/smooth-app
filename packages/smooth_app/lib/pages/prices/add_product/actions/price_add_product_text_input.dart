part of '../price_add_product_action.dart';

class _PriceAddProductActionBarcodeInput extends PriceAddProductAction {
  static const TextInputType _textInputType = TextInputType.number;

  @override
  String label(AppLocalizations appLocalizations) =>
      appLocalizations.prices_barcode_enter;

  @override
  Widget icon(BuildContext context) => const Icon(Icons.text_fields);

  @override
  Future<void> execute(BuildContext context) async {
    final String? barcode = await _textInput(context);
    if (barcode == null) {
      return;
    }
    if (!context.mounted) {
      return;
    }
    await _addBarcodesToList(<String>[barcode], context);
  }

  Future<String?> _textInput(BuildContext context) async {
    final TextEditingController controller = TextEditingController();
    final AppLocalizations appLocalizations = AppLocalizations.of(context);
    return showDialog<String>(
      context: context,
      builder: (final BuildContext context) => StatefulBuilder(
        builder: (
          final BuildContext context,
          void Function(VoidCallback fn) setState,
        ) {
          // Import needed for SmoothTextFormField
          return SmoothAlertDialog(
            title: appLocalizations.prices_add_an_item,
            body: _BarcodeTextField(
              controller: controller,
              appLocalizations: appLocalizations,
              onChanged: () => setState(() {}),
              onSubmitted: () => !_isValidBarcode(controller.text)
                  ? null
                  : Navigator.of(context).pop(controller.text),
            ),
            positiveAction: SmoothActionButton(
              text: appLocalizations.validate,
              onPressed: !_isValidBarcode(controller.text)
                  ? null
                  : () => Navigator.of(context).pop(controller.text),
            ),
            negativeAction: SmoothActionButton(
              text: appLocalizations.cancel,
              onPressed: () => Navigator.of(context).pop(),
            ),
          );
        },
      ),
    );
  }

  static bool _isValidBarcode(String barcode) => barcode.length >= 8;

  static String _getCleanBarcode(String input) {
    const int ascii0 = 48;
    const int ascii9 = 48 + 10 - 1;

    final StringBuffer buffer = StringBuffer();
    for (int i = 0; i < input.length; i++) {
      final int charCode = input.codeUnitAt(i);
      if (charCode >= ascii0 && charCode <= ascii9) {
        buffer.writeCharCode(charCode);
      }
    }
    return buffer.toString();
  }
}

class _BarcodeTextField extends StatelessWidget {
  const _BarcodeTextField({
    required this.controller,
    required this.appLocalizations,
    required this.onChanged,
    required this.onSubmitted,
  });

  final TextEditingController controller;
  final AppLocalizations appLocalizations;
  final VoidCallback onChanged;
  final VoidCallback onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: true,
      controller: controller,
      keyboardType: _PriceAddProductActionBarcodeInput._textInputType,
      decoration: InputDecoration(
        hintText: appLocalizations.barcode,
      ),
      onChanged: (_) {
        final String barcode = controller.text;
        final String cleanBarcode =
            _PriceAddProductActionBarcodeInput._getCleanBarcode(barcode);
        if (cleanBarcode != barcode) {
          controller.text = cleanBarcode;
        }
        onChanged();
      },
      onSubmitted: (_) => onSubmitted(),
    );
  }
}
