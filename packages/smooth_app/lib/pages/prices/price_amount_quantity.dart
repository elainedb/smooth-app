import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_app/pages/prices/price_model.dart';
import 'package:smooth_app/resources/app_icons.dart' as icons;

/// Shows the count of items as a white pill badge.
class PriceAmountQuantity extends StatelessWidget {
  const PriceAmountQuantity();

  @override
  Widget build(BuildContext context) {
    final PriceModel model = context.watch<PriceModel>();

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
            const icons.Ingredients.basket(size: 12.0),
            const SizedBox(width: 4.0),
            Text(
              '${model.length}',
              style: const TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
