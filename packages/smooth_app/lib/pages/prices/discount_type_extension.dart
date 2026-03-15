import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:smooth_app/l10n/app_localizations.dart';

/// Extension on [DiscountType] to get localized strings.
extension DiscountTypeExtension on DiscountType {
  /// Returns a localized title.
  String getTitle(final AppLocalizations appLocalizations) => switch (this) {
        DiscountType.quantityDiscount =>
          appLocalizations.prices_amount_discount_type_quantity_discount,
        DiscountType.sale =>
          appLocalizations.prices_amount_discount_type_sale,
        DiscountType.seasonal =>
          appLocalizations.prices_amount_discount_type_seasonal,
        DiscountType.loyaltyProgram =>
          appLocalizations.prices_amount_discount_type_loyalty_program,
        DiscountType.expiresSoon =>
          appLocalizations.prices_amount_discount_type_expires_soon,
        DiscountType.pickItYourself =>
          appLocalizations.prices_amount_discount_type_pick_it_yourself,
        DiscountType.secondHand =>
          appLocalizations.prices_amount_discount_type_second_hand,
        DiscountType.other => appLocalizations.prices_amount_discount_type_other,
      };
}
