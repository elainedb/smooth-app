import 'package:flutter/material.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:provider/provider.dart';
import 'package:smooth_app/generic_lib/design_constants.dart';
import 'package:smooth_app/l10n/app_localizations.dart';
import 'package:smooth_app/pages/prices/price_amount_field.dart';
import 'package:smooth_app/pages/prices/price_amount_model.dart';
import 'package:smooth_app/pages/prices/price_discount_type_widget.dart';
import 'package:smooth_app/pages/prices/price_model.dart';
import 'package:smooth_app/pages/prices/price_per_extension.dart';
import 'package:smooth_app/pages/prices/price_product_list_tile.dart';
import 'package:smooth_app/resources/app_icons.dart' as icons;
import 'package:smooth_app/widgets/smooth_dropdown.dart';

/// Displays a single product item within the price amount card.
class PriceAmountCardItem extends StatefulWidget {
  const PriceAmountCardItem({required this.index, super.key});

  final int index;

  @override
  State<PriceAmountCardItem> createState() => _PriceAmountCardItemState();
}

class _PriceAmountCardItemState extends State<PriceAmountCardItem> {
  late final TextEditingController _controllerPaid;
  late final TextEditingController _controllerWithoutDiscount;

  @override
  void initState() {
    super.initState();
    final PriceAmountModel model = Provider.of<PriceModel>(
      context,
      listen: false,
    ).elementAt(widget.index);
    _controllerPaid = TextEditingController(text: model.paidPrice);
    _controllerWithoutDiscount = TextEditingController(
      text: model.priceWithoutDiscount,
    );
    _controllerPaid.addListener(() {
      model.paidPrice = _controllerPaid.text;
    });
    _controllerWithoutDiscount.addListener(() {
      model.priceWithoutDiscount = _controllerWithoutDiscount.text;
    });
  }

  @override
  void dispose() {
    _controllerPaid.dispose();
    _controllerWithoutDiscount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context);
    final PriceModel priceModel = Provider.of<PriceModel>(context);
    final PriceAmountModel model = priceModel.elementAt(widget.index);
    final int total = priceModel.length;

    return Column(
      children: <Widget>[
        PriceProductListTile(
          product: model.product,
          trailing: total == 1
              ? null
              : InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () => priceModel.removeAt(widget.index),
                  child: const icons.Close.circled(size: 15.0),
                ),
        ),
        if (model.product.categoryTag.isNotEmpty)
          const SizedBox(height: SMALL_SPACE),
        if (model.product.categoryTag.isNotEmpty)
          SmoothDropdownButton<PricePer>(
            isExpanded: true,
            value: model.product.pricePer,
            items: PricePer.values
                .map(
                  (final PricePer pricePer) => SmoothDropdownItem<PricePer>(
                    value: pricePer,
                    label: pricePer.getTitle(appLocalizations),
                  ),
                )
                .toList(),
            onChanged: (final PricePer? value) {
              if (value == null) {
                return;
              }
              model.product.pricePer = value;
            },
          ),
        SwitchListTile(
          value: model.promo,
          contentPadding: EdgeInsetsDirectional.zero,
          onChanged: (final bool value) =>
              setState(() => model.promo = !model.promo),
          title: Text(appLocalizations.prices_amount_is_discounted),
          controlAffinity: ListTileControlAffinity.leading,
        ),
        if (model.promo)
          PriceDiscountTypeDropdown(
            value: model.discountType,
            onChanged: (final DiscountType? value) {
              setState(() => model.discountType = value);
            },
          )
        else
          EMPTY_WIDGET,
        const SizedBox(height: SMALL_SPACE),
        Row(
          children: <Widget>[
            Expanded(
              child: PriceAmountField(
                controller: _controllerPaid,
                isPaidPrice: true,
                model: model,
              ),
            ),
            const SizedBox(width: LARGE_SPACE),
            Expanded(
              child: !model.promo
                  ? EMPTY_WIDGET
                  : PriceAmountField(
                      controller: _controllerWithoutDiscount,
                      isPaidPrice: false,
                      model: model,
                    ),
            ),
          ],
        ),
      ],
    );
  }
}
