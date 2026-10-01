import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_app/l10n/app_localizations.dart';
import 'package:smooth_app/pages/prices/currency_extension.dart';
import 'package:smooth_app/pages/prices/price_currency_selector.dart';
import 'package:smooth_app/pages/prices/price_model.dart';
import 'package:smooth_app/themes/smooth_theme_colors.dart';
import 'package:smooth_app/themes/theme_provider.dart';

/// Compact currency button displayed in the proof card header.
class PriceCurrencyButton extends StatelessWidget {
  const PriceCurrencyButton();

  @override
  Widget build(BuildContext context) {
    final PriceModel model = context.watch<PriceModel>();
    final AppLocalizations appLocalizations = AppLocalizations.of(context);
    final SmoothColorsThemeExtension colors =
        context.extension<SmoothColorsThemeExtension>();
    final Color textColor =
        context.lightTheme() ? colors.primaryBlack : Colors.white;

    return Tooltip(
      message: appLocalizations.prices_amount_update_currency,
      child: InkWell(
        onTap: () async => PriceCurrencySelector.openSelector(context: context),
        borderRadius: const BorderRadius.all(Radius.circular(16.0)),
        child: Material(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(16.0)),
          child: Padding(
            padding: const EdgeInsetsDirectional.symmetric(
              horizontal: 10.0,
              vertical: 4.0,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  model.currency.getFullName(),
                  style: TextStyle(
                    color: textColor,
                    fontSize: 12.0,
                  ),
                ),
                const SizedBox(width: 4.0),
                Icon(
                  Icons.keyboard_arrow_down,
                  size: 16.0,
                  color: textColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
