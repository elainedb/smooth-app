import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_app/generic_lib/bottom_sheets/smooth_bottom_sheet.dart';
import 'package:smooth_app/l10n/app_localizations.dart';
import 'package:smooth_app/pages/prices/add_product/price_add_product_action.dart';
import 'package:smooth_app/pages/prices/price_model.dart';
import 'package:smooth_app/resources/app_icons.dart' as icons;
import 'package:smooth_app/themes/smooth_theme_colors.dart';

class PriceAddProductButton extends StatelessWidget {
  const PriceAddProductButton({super.key});

  @override
  Widget build(BuildContext context) {
    final PriceModel model = context.watch<PriceModel>();
    if (!model.multipleProducts || model.length == 0) {
      return const SizedBox.shrink();
    }

    final AppLocalizations appLocalizations = AppLocalizations.of(context);
    final SmoothColorsThemeExtension theme =
        Theme.of(context).extension<SmoothColorsThemeExtension>()!;

    return FloatingActionButton(
      onPressed: () async {
        final PriceAddProductAction? action =
            await showSmoothListOfChoicesModalSheet<PriceAddProductAction>(
          context: context,
          title: appLocalizations.prices_add_an_item,
          labels: priceAddProductActions.map<String>(
            (PriceAddProductAction action) => action.label(appLocalizations),
          ),
          values: priceAddProductActions,
          prefixIcons: priceAddProductActions.map<Widget>(
            (PriceAddProductAction action) => action.icon(context),
          ),
        );
        if (action != null && context.mounted) {
          await action.execute(context);
        }
      },
      backgroundColor: theme.secondaryVibrant,
      tooltip: appLocalizations.prices_add_an_item,
      shape: const CircleBorder(),
      child: const icons.Add.circled(color: Colors.white),
    );
  }
}
