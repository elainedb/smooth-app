import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:smooth_app/design/app_themes.dart';
import 'package:smooth_app/pages/prices/discount_type_extension.dart';
import 'package:smooth_app/widgets/smooth_dropdown.dart';

class PriceDiscountTypeDropdown extends StatelessWidget {
  const PriceDiscountTypeDropdown({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final DiscountType? value;
  final ValueChanged<DiscountType?> onChanged;

  @override
  Widget build(final BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context);
    final ThemeData themeData = Theme.of(context);
    final ColorScheme colorScheme = themeData.colorScheme;
    final List<DropdownMenuItem<DiscountType?>> items =
        <DropdownMenuItem<DiscountType?>>[];
    items.add(
      DropdownMenuItem<DiscountType?>(
        value: null,
        child: Text(
          appLocalizations.prices_discount_type,
          style: themeData.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface,
          ),
        ),
      ),
    );
    for (final DiscountType discountType in DiscountType.values) {
      items.add(
        DropdownMenuItem<DiscountType?>(
          value: discountType,
          child: Text(
            discountType.getTitle(appLocalizations),
            style: themeData.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: SmoothDropdownButton<DiscountType?>(
        items: items,
        value: value,
        onChanged: (final DiscountType? newValue) {
          if (newValue == null) {
            return;
          }
          onChanged(newValue);
        },
        isExpanded: true,
      ),
    );
  }
}
