import 'package:flutter/material.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:smooth_app/design/app_themes.dart';
import 'package:smooth_app/design/spacing.dart';
import 'package:smooth_app/l10n/app_localizations.dart';
import 'package:smooth_app/pages/prices/discount_type_extension.dart';
import 'package:smooth_app/widgets/smooth_dropdown.dart';

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
    final ThemeData themeData = Theme.of(context);
    final bool isDark = themeData.brightness == Brightness.dark;
    final Color? foregroundColor = isDark
        ? themeData.colorScheme.onSurface
        : themeData.colorScheme.primary;
    final List<DropdownMenuItem<DiscountType?>> items =
        <DropdownMenuItem<DiscountType?>>[
      DropdownMenuItem<DiscountType?>(
        value: null,
        child: Text(
          appLocalizations.prices_discount_type,
          style: themeData.textTheme.bodyMedium?.copyWith(
            color: foregroundColor,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
      for (final DiscountType discountType in DiscountType.values)
        DropdownMenuItem<DiscountType>(
          value: discountType,
          child: Text(
            context.getDiscountTypeTitle(discountType),
            style: themeData.textTheme.bodyMedium?.copyWith(
              color: foregroundColor,
            ),
          ),
        ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: SMALL_SPACE),
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
