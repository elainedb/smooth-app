import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smooth_app/helpers/provider_helper.dart';
import 'package:smooth_app/pages/prices/price_amount_model.dart';
import 'package:smooth_app/pages/prices/price_model.dart';
import 'package:smooth_app/resources/app_icons.dart' as icons;
import 'package:smooth_app/themes/smooth_theme_colors.dart';
import 'package:smooth_app/themes/theme_provider.dart';

class PriceAmountSum extends StatelessWidget {
  const PriceAmountSum({super.key});

  @override
  Widget build(BuildContext context) {
    final PriceModel model = context.watch<PriceModel>();
    final SmoothColorsThemeExtension extension =
        Theme.of(context).extension<SmoothColorsThemeExtension>()!;

    return MultipleChangeNotifierBuilder<PriceAmountModel>(
      notifiers: model.priceAmountModels,
      builder: (BuildContext context, List<PriceAmountModel> notifiers) {
        double total = 0.0;
        for (final PriceAmountModel amountModel in notifiers) {
          final double? value = double.tryParse(
            amountModel.paidPrice.replaceAll(',', '.'),
          );
          if (value != null) {
            total += value;
          }
        }

        final NumberFormat format = NumberFormat.simpleCurrency(
          name: model.currency.name,
        );

        return Material(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(16.0)),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 4.0,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                icons.Currency(
                  size: 14.0,
                  color: extension.primaryBlack,
                ),
                const SizedBox(width: 4.0),
                Text(
                  format.format(total),
                  style: TextStyle(
                    color: extension.primaryBlack,
                    fontWeight: FontWeight.w600,
                    fontSize: 12.0,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
