import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_app/pages/prices/price_model.dart';
import 'package:smooth_app/resources/app_icons.dart' as icons;

class PriceAmountQuantity extends StatelessWidget {
  const PriceAmountQuantity({super.key});

  @override
  Widget build(BuildContext context) {
    final int count = context.select((PriceModel model) => model.length);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const icons.Ingredients.basket(
            size: 16.0,
            color: Colors.black,
          ),
          const SizedBox(width: 4.0),
          Text(
            count.toString(),
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
