import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_app/generic_lib/design_constants.dart';
import 'package:smooth_app/generic_lib/widgets/smooth_sliver_card.dart';
import 'package:smooth_app/l10n/app_localizations.dart';
import 'package:smooth_app/pages/prices/price_amount_card_item.dart';
import 'package:smooth_app/pages/prices/price_amount_quantity.dart';
import 'package:smooth_app/pages/prices/price_amount_sum.dart';
import 'package:smooth_app/pages/prices/price_model.dart';

class PriceAmountCard extends StatelessWidget {
  const PriceAmountCard({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context);
    final PriceModel priceModel = Provider.of<PriceModel>(context);

    return SliverCardWithRoundedHeader(
      title: appLocalizations.prices_amount_subtitle,
      leading: const Icon(Icons.calculate_rounded),
      trailing: priceModel.multipleProducts
          ? const Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                PriceAmountQuantity(),
                SizedBox(width: SMALL_SPACE),
                PriceAmountSum(),
              ],
            )
          : null,
      contentPadding: const EdgeInsetsDirectional.symmetric(
        horizontal: SMALL_SPACE,
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: priceModel.length,
        itemBuilder: (BuildContext context, int index) {
          return PriceAmountCardItem(index: index);
        },
        separatorBuilder: (BuildContext context, int index) {
          return const Divider();
        },
      ),
    );
  }
}
