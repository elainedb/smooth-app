import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:smooth_app/generic_lib/design_constants.dart';
import 'package:smooth_app/pages/prices/discount_type_extension.dart';
import 'package:smooth_app/widgets/smooth_dropdown.dart';

/// A dropdown widget for selecting a [DiscountType].
class PriceDiscountTypeDropdown extends StatelessWidget {
  const PriceDiscountTypeDropdown({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final DiscountType? value;
  final ValueChanged<DiscountType?> onChanged;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: SMALL_SPACE),
      child: SmoothDropdownButton<DiscountType?>(
        value: value,
        isExpanded: true,
        items: <DropdownMenuItem<DiscountType?>>[
          DropdownMenuItem<DiscountType?>(
            value: null,
            child: Text(appLocalizations.prices_discount_type),
          ),
          for (final DiscountType discountType in DiscountType.values)
            DropdownMenuItem<DiscountType?>(
              value: discountType,
              child: Text(discountType.getTitle(appLocalizations)),
            ),
        ],
        onChanged: (DiscountType? newValue) {
          if (newValue != null) {
            onChanged(newValue);
          }
        },
      ),
    );
  }
}
