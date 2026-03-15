import 'package:flutter/material.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:smooth_app/design/spacing.dart';
import 'package:smooth_app/generic_lib/widgets/smooth_text_form_field.dart';
import 'package:smooth_app/l10n/app_localizations.dart';
import 'package:smooth_app/pages/prices/discount_type_extension.dart';

class PriceExistingDiscountTypeField extends StatelessWidget {
  PriceExistingDiscountTypeField({required this.value});

  final DiscountType? value;
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context);
    _controller.text =
        value == null ? '' : value!.getTitle(appLocalizations);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: SMALL_SPACE),
      child: SmoothTextFormField(
        type: TextFieldTypes.PLAIN_TEXT,
        controller: _controller,
        enabled: false,
        hintText: appLocalizations.prices_discount_type,
      ),
    );
  }
}
