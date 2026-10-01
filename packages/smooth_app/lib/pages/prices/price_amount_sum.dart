import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smooth_app/helpers/provider_helper.dart';
import 'package:smooth_app/pages/prices/price_amount_model.dart';
import 'package:smooth_app/pages/prices/price_model.dart';
import 'package:smooth_app/resources/app_icons.dart' as icons;

class PriceAmountSum extends StatelessWidget {
  const PriceAmountSum({super.key});

  @override
  Widget build(BuildContext context) {
    final PriceModel priceModel = context.watch<PriceModel>();

    return MultipleChangeNotifierBuilder<PriceAmountModel>(
      notifiers: priceModel.priceAmountModels,
      builder: (BuildContext context, List<PriceAmountModel> models) {
        double total = 0.0;
        for (final PriceAmountModel model in models) {
          final double? value = double.tryParse(model.paidPrice.replaceAll(',', '.'));
          if (value != null) {
            total += value;
          }
        }

        final NumberFormat formatter = NumberFormat.simpleCurrency(
          locale: Localizations.localeOf(context).toString(),
          name: priceModel.currency.name,
        );

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const icons.Currency(
                size: 16.0,
                color: Colors.black,
              ),
              const SizedBox(width: 4.0),
              Text(
                formatter.format(total),
                style: const TextStyle(
                  color: Colors.black,
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
