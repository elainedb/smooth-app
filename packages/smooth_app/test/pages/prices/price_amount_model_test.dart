import 'package:flutter_test/flutter_test.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:smooth_app/pages/prices/price_amount_model.dart';
import 'package:smooth_app/pages/prices/price_meta_product.dart';

void main() {
  group('PriceAmountModel tests', () {
    test('discountType property', () {
      final PriceAmountModel model = PriceAmountModel(
        product: PriceMetaProduct.product(
          Product(barcode: '12345678'),
        ),
      );

      expect(model.discountType, isNull);
      expect(model.hasChanged, isFalse);

      model.discountType = DiscountType.sale;
      expect(model.discountType, equals(DiscountType.sale));
      expect(model.hasChanged, isTrue);

      model.discountType = null;
      expect(model.discountType, isNull);
    });
  });
}
