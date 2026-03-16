import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:smooth_app/l10n/app_localizations.dart';

/// Extension for [DiscountType] to get localized strings.
extension DiscountTypeExtension on DiscountType {
  /// Returns the localized title of the discount type.
  String getTitle(final AppLocalizations appLocalizations) {
    switch (this) {
      case DiscountType.quantity:
        return appLocalizations.prices_discount_quantity;
      case DiscountType.sale:
        return appLocalizations.prices_discount_sale;
      case DiscountType.seasonal:
        return appLocalizations.prices_discount_seasonal;
      case DiscountType.loyaltyProgram:
        return appLocalizations.prices_discount_loyaltyProgram;
      case DiscountType.expiresSoon:
        return appLocalizations.prices_discount_expiresSoon;
      case DiscountType.pickItYourself:
        return appLocalizations.prices_discount_pickItYourself;
      case DiscountType.secondHand:
        return appLocalizations.prices_discount_secondHand;
      case DiscountType.other:
        return appLocalizations.prices_discount_other;
    }
  }
}
