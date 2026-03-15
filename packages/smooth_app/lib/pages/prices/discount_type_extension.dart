import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

/// Extension on [DiscountType] to get a localized title.
extension DiscountTypeExtension on DiscountType {
  String getTitle(final AppLocalizations appLocalizations) {
    switch (this) {
      case DiscountType.quantity:
        return appLocalizations.prices_discount_type_quantity;
      case DiscountType.sale:
        return appLocalizations.prices_discount_type_sale;
      case DiscountType.seasonal:
        return appLocalizations.prices_discount_type_seasonal;
      case DiscountType.loyaltyProgram:
        return appLocalizations.prices_discount_type_loyalty_program;
      case DiscountType.expiresSoon:
        return appLocalizations.prices_discount_type_expires_soon;
      case DiscountType.pickItYourself:
        return appLocalizations.prices_discount_type_pick_it_yourself;
      case DiscountType.secondHand:
        return appLocalizations.prices_discount_type_second_hand;
      case DiscountType.other:
        return appLocalizations.prices_discount_type_other;
    }
  }
}
