import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:smooth_app/l10n/app_localizations.dart';

extension DiscountTypeExtension on DiscountType {
  String getTitle(final AppLocalizations appLocalizations) {
    switch (this) {
      case DiscountType.quantity:
        return appLocalizations.prices_discount_quantity;
      case DiscountType.sale:
        return appLocalizations.prices_discount_sale;
      case DiscountType.seasonal:
        return appLocalizations.prices_discount_seasonal;
      case DiscountType.loyaltyProgram:
        return appLocalizations.prices_discount_loyalty;
      case DiscountType.expiresSoon:
        return appLocalizations.prices_discount_expires_soon;
      case DiscountType.pickItYourself:
        return appLocalizations.prices_discount_pick_it_yourself;
      case DiscountType.secondHand:
        return appLocalizations.prices_discount_second_hand;
      case DiscountType.other:
        return appLocalizations.prices_discount_other;
    }
  }
}
