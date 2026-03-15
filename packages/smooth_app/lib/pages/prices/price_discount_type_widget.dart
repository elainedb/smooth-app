import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:smooth_app/design/app_themes.dart';
import 'package:smooth_app/design/design_colors.dart';
import 'package:smooth_app/design/spacing.dart';
import 'package:smooth_app/pages/prices/discount_type_extension.dart';
import 'package:smooth_app/widgets/smooth_dropdown.dart';

/// Dropdown for [DiscountType].
class PriceDiscountTypeDropdown extends StatelessWidget {
  const PriceDiscountTypeDropdown({
    required this.value,
    required this.onChanged,
  });

  final DiscountType? value;
  final ValueChanged<DiscountType?> onChanged;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context);
    final DesignColors colors = Theme.of(context).extension<DesignColors>()!;
    final List<DropdownMenuItem<DiscountType?>> items =
        <DropdownMenuItem<DiscountType?>>[
      DropdownMenuItem<DiscountType?>(
        value: null,
        child: Text(
          appLocalizations.prices_discount_type,
          style: TextStyle(color: colors.primary),
        ),
      ),
    ];
    for (final DiscountType discountType in DiscountType.values) {
      items.add(
        DropdownMenuItem<DiscountType?>(
          value: discountType,
          child: Text(
            discountType.getTitle(appLocalizations),
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: SMALL_SPACE),
      child: SmoothDropdownButton<DiscountType?>(
        items: items,
        value: value,
        onChanged: (final DiscountType? newValue) {
          if (newValue != null) {
            onChanged(newValue);
          }
        },
        isExpanded: true,
      ),
    );
  }
}
