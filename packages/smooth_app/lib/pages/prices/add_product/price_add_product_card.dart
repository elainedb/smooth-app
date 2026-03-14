import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_app/l10n/app_localizations.dart';
import 'package:smooth_app/generic_lib/buttons/smooth_large_button_with_icon.dart';
import 'package:smooth_app/generic_lib/design_constants.dart';
import 'package:smooth_app/generic_lib/widgets/smooth_card.dart';
import 'package:smooth_app/pages/prices/add_product/price_add_product_action.dart';
import 'package:smooth_app/pages/prices/price_model.dart';
import 'package:smooth_app/resources/app_icons.dart' as icons;

class PriceAddProductCard extends StatelessWidget {
  const PriceAddProductCard({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context);
    final PriceModel model = context.watch<PriceModel>();

    if (!model.multipleProducts || model.length > 0) {
      return EMPTY_WIDGET;
    }

    return SmoothCardWithRoundedHeader(
      title: appLocalizations.prices_add_an_item,
      leading: const icons.Add.circled(),
      contentPadding: const EdgeInsetsDirectional.symmetric(
        horizontal: SMALL_SPACE,
        vertical: MEDIUM_SPACE,
      ),
      child: Column(
        children: priceAddProductActions.map((PriceAddProductAction action) {
          return SmoothLargeButtonWithIcon(
            text: action.label(appLocalizations),
            leadingIcon: action.icon(context),
            onPressed: () => action.execute(context),
          );
        }).toList(growable: false),
      ),
    );
  }
}
