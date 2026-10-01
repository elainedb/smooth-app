import 'package:flutter/material.dart';
import 'package:smooth_app/generic_lib/bottom_sheets/smooth_bottom_sheet.dart';
import 'package:smooth_app/l10n/app_localizations.dart';
import 'package:smooth_app/pages/prices/add_product/price_add_product_action.dart';
import 'package:smooth_app/resources/app_icons.dart' as icons;
import 'package:smooth_app/themes/smooth_theme_colors.dart';

/// FAB for adding more products in multi-product mode.
class PriceAddProductButton extends StatelessWidget {
  const PriceAddProductButton();

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context);
    final SmoothColorsThemeExtension colors = context
        .extension<SmoothColorsThemeExtension>();
    final List<PriceAddProductAction> actions = priceAddProductActions;

    return FloatingActionButton(
      heroTag: 'price_add_product',
      backgroundColor: colors.secondaryVibrant,
      tooltip: appLocalizations.prices_add_an_item,
      onPressed: () async {
        final PriceAddProductAction? action =
            await showSmoothListOfChoicesModalSheet<PriceAddProductAction>(
              context: context,
              title: appLocalizations.prices_add_an_item,
              labels: actions.map<String>(
                (PriceAddProductAction a) => a.label(appLocalizations),
              ),
              prefixIcons: actions
                  .map<Widget>((PriceAddProductAction a) => a.icon(context))
                  .toList(growable: false),
              addEndArrowToItems: true,
              values: actions,
            );
        if (action == null) {
          return;
        }
        if (!context.mounted) {
          return;
        }
        await action.execute(context);
      },
      child: const icons.Add.circled(color: Colors.white),
    );
  }
}
