import 'dart:ui';
import 'package:flutter_test/flutter_test.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:smooth_app/l10n/app_localizations.dart';
import 'package:smooth_app/pages/prices/discount_type_extension.dart';

void main() {
  group('DiscountTypeExtension', () {
    test('getTitle returns correct localization for each DiscountType', () async {
      final AppLocalizations appLocalizations = await AppLocalizations.delegate.load(const Locale('en'));

      expect(DiscountType.quantity.getTitle(appLocalizations), appLocalizations.prices_discount_type_quantity);
      expect(DiscountType.sale.getTitle(appLocalizations), appLocalizations.prices_discount_type_sale);
      expect(DiscountType.seasonal.getTitle(appLocalizations), appLocalizations.prices_discount_type_seasonal);
      expect(DiscountType.loyaltyProgram.getTitle(appLocalizations), appLocalizations.prices_discount_type_loyalty_program);
      expect(DiscountType.expiresSoon.getTitle(appLocalizations), appLocalizations.prices_discount_type_expires_soon);
      expect(DiscountType.pickItYourself.getTitle(appLocalizations), appLocalizations.prices_discount_type_pick_it_yourself);
      expect(DiscountType.secondHand.getTitle(appLocalizations), appLocalizations.prices_discount_type_second_hand);
      expect(DiscountType.other.getTitle(appLocalizations), appLocalizations.prices_discount_type_other);
    });
  });
}
