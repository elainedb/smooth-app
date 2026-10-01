import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smooth_app/helpers/provider_helper.dart';
import 'package:smooth_app/pages/prices/price_amount_model.dart';
import 'package:smooth_app/pages/prices/price_model.dart';
import 'package:smooth_app/resources/app_icons.dart' as icons;
import 'package:smooth_app/themes/smooth_theme_colors.dart';

class PriceAmountSum extends StatelessWidget {
  const PriceAmountSum({super.key});

  @override
  Widget build(BuildContext context) {
    final PriceModel model = context.watch<PriceModel>();
    final SmoothColorsThemeExtension theme =
        Theme.of(context).extension<SmoothColorsThemeExtension>()!;

    return MultipleChangeNotifierBuilder<PriceAmountModel>(
      notifiers: model.priceAmountModels,
      builder: (BuildContext context, List<PriceAmountModel> notifiers) {
        double sum = 0.0;
        for (final PriceAmountModel amountModel in notifiers) {
          final double? value = double.tryParse(amountModel.paidPrice.replaceAll(',', '.'));
          if (value != null) {
            sum += value;
          }
        }

        final NumberFormat format = NumberFormat.simpleCurrency(
          name: model.currency.name,
        );

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(16.0)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              icons.Currency(
                size: 16.0,
                color: theme.primaryDark,
              ),
              const SizedBox(width: 4.0),
              Text(
                format.format(sum),
                style: TextStyle(
                  color: theme.primaryDark,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
