import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:smooth_app/generic_lib/design_constants.dart';
import 'package:smooth_app/pages/prices/discount_type_extension.dart';
import 'package:smooth_app/widgets/smooth_dropdown.dart';

/// Dropdown to select a [DiscountType].
class PriceDiscountTypeDropdown extends StatelessWidget {
  const PriceDiscountTypeDropdown({
    required this.value,
    required this.onChanged,
  });

  final DiscountType? value;
  final ValueChanged<DiscountType?> onChanged;

  @override
  Widget build(final BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: SMALL_SPACE),
      child: SmoothDropdownButton<DiscountType?>(
        isExpanded: true,
        value: value,
        items: <DropdownMenuItem<DiscountType?>>[
          DropdownMenuItem<DiscountType?>(
            value: null,
            child: Text(appLocalizations.prices_discount_type),
          ),
          ...DiscountType.values.map(
            (final DiscountType discountType) =>
                DropdownMenuItem<DiscountType?>(
              value: discountType,
              child: Text(discountType.getTitle(appLocalizations)),
            ),
          ),
        ],
        onChanged: (final DiscountType? value) {
          if (value != null) {
            onChanged(value);
          }
        },
      ),
    );
  }
}
