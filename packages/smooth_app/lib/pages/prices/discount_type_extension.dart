import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:smooth_app/l10n/app_localizations.dart';

/// Extension on [DiscountType] to provide localized titles.
extension DiscountTypeExtension on DiscountType {
  String getTitle(final AppLocalizations appLocalizations) => switch (this) {
    DiscountType.quantity => appLocalizations.discount_type_quantity_discount,
    DiscountType.sale => appLocalizations.discount_type_sale,
    DiscountType.seasonal => appLocalizations.discount_type_seasonal,
    DiscountType.loyaltyProgram =>
      appLocalizations.discount_type_loyalty_program,
    DiscountType.expiresSoon => appLocalizations.discount_type_expires_soon,
    DiscountType.pickItYourself =>
      appLocalizations.discount_type_pick_it_yourself,
    DiscountType.secondHand => appLocalizations.discount_type_second_hand,
    DiscountType.other => appLocalizations.discount_type_other,
  };
}
