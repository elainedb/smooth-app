import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_app/pages/prices/price_model.dart';
import 'package:smooth_app/resources/app_icons.dart' as icons;
import 'package:smooth_app/themes/smooth_theme_colors.dart';
import 'package:smooth_app/themes/theme_provider.dart';

class PriceAmountQuantity extends StatelessWidget {
  const PriceAmountQuantity({super.key});

  @override
  Widget build(BuildContext context) {
    final PriceModel model = context.watch<PriceModel>();
    final SmoothColorsThemeExtension extension =
        Theme.of(context).extension<SmoothColorsThemeExtension>()!;

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
            icons.Ingredients.basket(
              size: 14.0,
              color: extension.primaryBlack,
            ),
            const SizedBox(width: 4.0),
            Text(
              '${model.length}',
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
  }
}
