import 'package:flutter/material.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:provider/provider.dart';
import 'package:smooth_app/data_models/preferences/user_preferences.dart';
import 'package:smooth_app/database/local_database.dart';
import 'package:smooth_app/generic_lib/dialogs/smooth_alert_dialog.dart';
import 'package:smooth_app/generic_lib/widgets/smooth_text_form_field.dart';
import 'package:smooth_app/l10n/app_localizations.dart';
import 'package:smooth_app/pages/preferences/user_preferences_dev_mode.dart';
import 'package:smooth_app/pages/prices/price_amount_model.dart';
import 'package:smooth_app/pages/prices/price_category_input_page.dart';
import 'package:smooth_app/pages/prices/price_meta_product.dart';
import 'package:smooth_app/pages/prices/price_model.dart';
import 'package:smooth_app/pages/prices/price_scan_modal.dart';
import 'package:smooth_app/pages/prices/price_scan_page.dart';

part 'actions/price_add_product_barcode_reader.dart';
part 'actions/price_add_product_text_input.dart';
part 'actions/price_add_product_category.dart';

sealed class PriceAddProductAction {
  const PriceAddProductAction();

  String label(AppLocalizations appLocalizations);
  Widget icon(BuildContext context);
  Future<void> execute(BuildContext context);
}

List<PriceAddProductAction> get priceAddProductActions =>
    const <PriceAddProductAction>[
      _PriceAddProductActionBarcodeReader(),
      _PriceAddProductActionBarcodeInput(),
      _PriceAddProductActionCategoryInput(),
    ];

bool _barcodeAlreadyThere(PriceModel priceModel, String barcode) {
  for (int i = 0; i < priceModel.length; i++) {
    final PriceAmountModel model = priceModel.elementAt(i);
    if (model.product.barcode == barcode) {
      return true;
    }
  }
  if (priceModel.existingPrices != null) {
    for (final Price price in priceModel.existingPrices!) {
      if (price.productCode == barcode) {
        return true;
      }
    }
  }
  return false;
}

Future<void> _addBarcodesToList(
  List<String> barcodes,
  BuildContext context,
) async {
  if (barcodes.isEmpty) {
    return;
  }
  final LocalDatabase localDatabase = context.read<LocalDatabase>();
  final PriceModel model = context.read<PriceModel>();
  final AppLocalizations appLocalizations = AppLocalizations.of(context);
  final Set<String> duplicates = <String>{};

  for (final String barcode in barcodes) {
    if (_barcodeAlreadyThere(model, barcode)) {
      duplicates.add(barcode);
    } else {
      _addProductToList(
        model,
        PriceMetaProduct.unknown(barcode, localDatabase, model),
        context,
      );
    }
  }

  if (duplicates.isNotEmpty) {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) => SmoothAlertDialog(
        body: Text(
          appLocalizations.prices_barcode_already(
            duplicates.join(', '),
          ),
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
  PriceModel model,
  PriceMetaProduct product,
  BuildContext context,
) {
  model.add(PriceAmountModel(product: product));
}
