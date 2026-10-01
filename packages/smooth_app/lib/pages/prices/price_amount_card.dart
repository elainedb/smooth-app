import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_app/generic_lib/design_constants.dart';
import 'package:smooth_app/generic_lib/widgets/smooth_sliver_card.dart';
import 'package:smooth_app/l10n/app_localizations.dart';
import 'package:smooth_app/pages/prices/price_amount_card_item.dart';
import 'package:smooth_app/pages/prices/price_amount_quantity.dart';
import 'package:smooth_app/pages/prices/price_amount_sum.dart';
import 'package:smooth_app/pages/prices/price_model.dart';

/// Card that displays the amounts for all products in a single sliver card.
class PriceAmountCard extends StatelessWidget {
  const PriceAmountCard();

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context);
    final PriceModel model = Provider.of<PriceModel>(context);

    return SliverCardWithRoundedHeader(
      title: appLocalizations.prices_amount_subtitle,
      leading: const Icon(Icons.calculate_rounded),
      trailing: !model.multipleProducts
          ? null
          : const Row(
              mainAxisSize: MainAxisSize.min,
              spacing: SMALL_SPACE,
              children: <Widget>[
                PriceAmountQuantity(),
                PriceAmountSum(),
              ],
            ),
      contentPadding: const EdgeInsetsDirectional.symmetric(
        horizontal: SMALL_SPACE,
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: model.length,
        separatorBuilder: (BuildContext context, int index) => const Divider(),
        itemBuilder: (BuildContext context, int index) =>
            PriceAmountCardItem(key: UniqueKey(), index: index),
      ),
    );
  }
}
