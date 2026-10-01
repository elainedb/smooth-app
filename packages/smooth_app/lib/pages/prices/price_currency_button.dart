import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_app/l10n/app_localizations.dart';
import 'package:smooth_app/pages/prices/currency_extension.dart';
import 'package:smooth_app/pages/prices/price_currency_selector.dart';
import 'package:smooth_app/pages/prices/price_model.dart';
import 'package:smooth_app/themes/smooth_theme_colors.dart';

class PriceCurrencyButton extends StatelessWidget {
  const PriceCurrencyButton({super.key});

  @override
  Widget build(BuildContext context) {
    final PriceModel model = context.watch<PriceModel>();
    final AppLocalizations appLocalizations = AppLocalizations.of(context);
    final SmoothColorsThemeExtension theme =
        Theme.of(context).extension<SmoothColorsThemeExtension>()!;

    return Tooltip(
      message: appLocalizations.prices_amount_update_currency,
      child: Material(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(16.0)),
        child: InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(16.0)),
          onTap: () => PriceCurrencySelector.openSelector(context: context),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  model.currency.getFullName(),
                  style: TextStyle(
                    color: theme.primaryDark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 4.0),
                Icon(
                  Icons.arrow_drop_down,
                  size: 20.0,
                  color: theme.primaryDark,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
