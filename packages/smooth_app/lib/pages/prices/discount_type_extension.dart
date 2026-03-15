import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

/// Extension on [DiscountType] to provide a localized title.
extension DiscountTypeExtension on DiscountType {
  String getTitle(AppLocalizations appLocalizations) => switch (this) {
        DiscountType.quantity => appLocalizations.prices_discount_type_quantity,
        DiscountType.sale => appLocalizations.prices_discount_type_sale,
        DiscountType.seasonal => appLocalizations.prices_discount_type_seasonal,
        DiscountType.loyaltyProgram =>
          appLocalizations.prices_discount_type_loyalty_program,
        DiscountType.expiresSoon =>
          appLocalizations.prices_discount_type_expires_soon,
        DiscountType.pickItYourself =>
          appLocalizations.prices_discount_type_pick_it_yourself,
        DiscountType.secondHand =>
          appLocalizations.prices_discount_type_second_hand,
        DiscountType.other => appLocalizations.prices_discount_type_other,
      };
}
