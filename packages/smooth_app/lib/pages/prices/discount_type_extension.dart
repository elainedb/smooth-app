import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:smooth_app/l10n/app_localizations.dart';

extension DiscountTypeExtension on DiscountType {
  String getTitle(final AppLocalizations appLocalizations) => switch (this) {
    DiscountType.quantity =>
      appLocalizations.prices_amount_discount_type_quantity_discount,
    DiscountType.sale => appLocalizations.prices_amount_discount_type_sale,
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

String getDiscountTypeL10n(
  final DiscountType discountType,
  final AppLocalizations appLocalizations,
) => discountType.getTitle(appLocalizations);
