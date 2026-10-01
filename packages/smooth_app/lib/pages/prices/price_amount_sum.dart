import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smooth_app/helpers/provider_helper.dart';
import 'package:smooth_app/pages/prices/price_amount_model.dart';
import 'package:smooth_app/pages/prices/price_model.dart';
import 'package:smooth_app/query/product_query.dart';
import 'package:smooth_app/resources/app_icons.dart' as icons;

/// Shows the total paid price sum as a white pill badge.
class PriceAmountSum extends StatelessWidget {
  const PriceAmountSum();

  @override
  Widget build(BuildContext context) {
    final PriceModel model = context.watch<PriceModel>();

    return MultipleChangeNotifierBuilder<PriceAmountModel>(
      notifiers: model.priceAmountModels,
      builder: (BuildContext context, List<PriceAmountModel> notifiers) {
        double total = 0.0;
        for (final PriceAmountModel amountModel in notifiers) {
          final double? value = double.tryParse(
            amountModel.paidPrice.replaceAll(',', '.'),
          );
          if (value != null && value > 0) {
            total += value;
          }
        }

        final NumberFormat currencyFormat = NumberFormat.simpleCurrency(
          locale: ProductQuery.getLocaleString(),
          name: model.currency.name,
        );

        return Material(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(16.0)),
          child: Padding(
            padding: const EdgeInsetsDirectional.symmetric(
              horizontal: 8.0,
              vertical: 4.0,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const icons.Currency(size: 12.0),
                const SizedBox(width: 4.0),
                Text(
                  currencyFormat.format(total),
                  style: const TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
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
