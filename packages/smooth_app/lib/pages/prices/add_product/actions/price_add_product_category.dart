part of '../price_add_product_action.dart';

class _PriceAddProductActionCategoryInput extends PriceAddProductAction {
  const _PriceAddProductActionCategoryInput();

  @override
  String label(AppLocalizations appLocalizations) =>
      appLocalizations.prices_category_enter;

  @override
  Widget icon(BuildContext context) => const icons.Ingredients();

  @override
  Future<void> execute(BuildContext context) async {
    final PriceMetaProduct? product = await Navigator.of(context).push<PriceMetaProduct>(
      MaterialPageRoute<PriceMetaProduct>(
        builder: (BuildContext context) => const PriceCategoryInputPage(),
      ),
    );
    if (context.mounted && product != null) {
      _addProductToList(context.read<PriceModel>(), product, context);
    }
  }
}
