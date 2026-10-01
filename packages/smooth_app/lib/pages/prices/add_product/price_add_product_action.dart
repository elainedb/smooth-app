import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_app/data_models/preferences/user_preferences.dart';
import 'package:smooth_app/database/local_database.dart';
import 'package:smooth_app/generic_lib/dialogs/smooth_alert_dialog.dart';
import 'package:smooth_app/generic_lib/widgets/smooth_text_form_field.dart';
import 'package:smooth_app/l10n/app_localizations.dart';
import 'package:smooth_app/pages/prices/price_amount_model.dart';
import 'package:smooth_app/pages/prices/price_category_input_page.dart';
import 'package:smooth_app/pages/prices/price_meta_product.dart';
import 'package:smooth_app/pages/prices/price_model.dart';
import 'package:smooth_app/pages/prices/price_scan_modal.dart';
import 'package:smooth_app/pages/prices/price_scan_page.dart';
import 'package:smooth_app/resources/app_icons.dart' as icons;

part 'actions/price_add_product_barcode_reader.dart';
part 'actions/price_add_product_text_input.dart';
part 'actions/price_add_product_category.dart';

sealed class PriceAddProductAction {
  const PriceAddProductAction();

  String label(AppLocalizations appLocalizations);
  Widget icon(BuildContext context);
  Future<void> execute(BuildContext context);
}

List<PriceAddProductAction> get priceAddProductActions => const <PriceAddProductAction>[
      _PriceAddProductActionBarcodeReader(),
      _PriceAddProductActionBarcodeInput(),
      _PriceAddProductActionCategoryInput(),
    ];

Future<void> _addBarcodesToList(List<String> barcodes, BuildContext context) async {
  if (barcodes.isEmpty) {
    return;
  }
  if (!context.mounted) {
    return;
  }
  final PriceModel priceModel = context.read<PriceModel>();
  final LocalDatabase localDatabase = context.read<LocalDatabase>();
  final AppLocalizations appLocalizations = AppLocalizations.of(context);

  int duplicateCount = 0;
  for (final String barcode in barcodes) {
    bool found = false;
    for (final PriceAmountModel model in priceModel.priceAmountModels) {
      if (model.product.barcode == barcode) {
        found = true;
        break;
      }
    }
    if (found) {
      duplicateCount++;
      continue;
    }
    _addProductToList(
      priceModel,
      PriceMetaProduct.unknown(barcode, localDatabase, priceModel),
      context,
    );
  }

  if (duplicateCount > 0 && context.mounted) {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) => SmoothAlertDialog(
        body: Text(
          appLocalizations.prices_barcode_already(duplicateCount.toString()),
        ),
        positiveAction: SmoothActionButton(
          text: appLocalizations.okay,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }
}

void _addProductToList(
  PriceModel priceModel,
  PriceMetaProduct product,
  BuildContext context,
) {
  priceModel.add(PriceAmountModel(product: product));
}
