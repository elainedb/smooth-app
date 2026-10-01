import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_app/database/dao_osm_location.dart';
import 'package:smooth_app/database/local_database.dart';
import 'package:smooth_app/generic_lib/buttons/smooth_large_button_with_icon.dart';
import 'package:smooth_app/generic_lib/design_constants.dart';
import 'package:smooth_app/generic_lib/widgets/smooth_back_button.dart';
import 'package:smooth_app/generic_lib/widgets/smooth_card.dart';
import 'package:smooth_app/l10n/app_localizations.dart';
import 'package:smooth_app/pages/locations/location_map_page.dart';
import 'package:smooth_app/pages/locations/osm_location.dart';
import 'package:smooth_app/pages/locations/search_location_helper.dart';
import 'package:smooth_app/pages/locations/search_location_preloaded_item.dart';
import 'package:smooth_app/pages/prices/price_model.dart';
import 'package:smooth_app/pages/search/search_page.dart';
import 'package:smooth_app/resources/app_icons.dart' as icons;

/// Card that displays the location for price adding.
class PriceLocationCard extends StatelessWidget {
  const PriceLocationCard({required this.onLocationChanged});

  final Function(OsmLocation location) onLocationChanged;

  @override
  Widget build(BuildContext context) {
    final PriceModel model = context.watch<PriceModel>();
    final AppLocalizations appLocalizations = AppLocalizations.of(context);
    final OsmLocation? location = model.location;

    final List<Widget> trailingButtons = <Widget>[];
    if (location != null) {
      trailingButtons.add(
        SmoothCardHeaderButton(
          circled: true,
          tooltip: appLocalizations.prices_location_open_map,
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (BuildContext context) => LocationMapPage(
                location,
                popFirst: false,
              ),
            ),
          ),
          child: const icons.Map(size: 12.0),
        ),
      );
      if (model.cropParameters != null) {
        trailingButtons.add(
          SmoothCardHeaderButton(
            circled: true,
            tooltip: appLocalizations.prices_location_edit,
            onTap: () => _onTap(context),
            child: const icons.Edit(size: 12.0),
          ),
        );
      }
    }

    return SmoothCardWithRoundedHeader(
      title: appLocalizations.prices_location_subtitle,
      leading: const icons.Shopping.cart(),
      titlePadding: const EdgeInsetsDirectional.only(
        top: 2.0,
        start: LARGE_SPACE,
        end: SMALL_SPACE,
        bottom: 2.0,
      ),
      trailing: trailingButtons.isEmpty
          ? null
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: trailingButtons,
            ),
      contentPadding: const EdgeInsetsDirectional.symmetric(
        horizontal: SMALL_SPACE,
        vertical: MEDIUM_SPACE,
      ),
      child: location == null
          ? _PriceLocationCardEmptyLocation(
              onPressed: model.proof != null ? null : () => _onTap(context),
            )
          : _PriceLocationCardAddress(location: location),
    );
  }

  Future<void> _onTap(BuildContext context) async {
    final LocalDatabase localDatabase = context.read<LocalDatabase>();
    final List<SearchLocationPreloadedItem> preloadedList =
        <SearchLocationPreloadedItem>[];
    final List<OsmLocation> locations = await DaoOsmLocation(
      localDatabase,
    ).getAll();
    if (!context.mounted) {
      return;
    }
    for (final OsmLocation osmLocation in locations) {
      preloadedList.add(
        SearchLocationPreloadedItem(osmLocation, popFirst: false),
      );
    }
    final OsmLocation? osmLocation = await Navigator.push<OsmLocation>(
      context,
      MaterialPageRoute<OsmLocation>(
        builder: (BuildContext context) => SearchPage(
          SearchLocationHelper(),
          preloadedList: preloadedList,
          autofocus: false,
          backButtonType: BackButtonType.close,
        ),
      ),
    );
    if (osmLocation == null) {
      return;
    }
    final DaoOsmLocation daoOsmLocation = DaoOsmLocation(localDatabase);
    await daoOsmLocation.put(osmLocation);

    onLocationChanged.call(osmLocation);
  }
}

class _PriceLocationCardEmptyLocation extends StatelessWidget {
  const _PriceLocationCardEmptyLocation({required this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context);
    return SmoothLargeButtonWithIcon(
      text: appLocalizations.prices_location_find,
      leadingIcon: const icons.Location(),
      trailingIcon: const icons.Chevron.right(size: 10.0),
      onPressed: onPressed,
    );
  }
}

class _PriceLocationCardAddress extends StatelessWidget {
  const _PriceLocationCardAddress({required this.location});

  final OsmLocation location;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final List<InlineSpan> spans = <InlineSpan>[];

    final String? name = location.name;
    if (name != null && name.isNotEmpty) {
      spans.add(
        TextSpan(
          text: name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
        ),
      );
    }
    final String? street = location.street;
    if (street != null && street.isNotEmpty) {
      if (spans.isNotEmpty) {
        spans.add(const TextSpan(text: '\n'));
      }
      spans.add(TextSpan(text: street));
    }
    final String postcodeCity = <String?>[
      location.postcode,
      location.city,
    ].where((String? s) => s != null && s.isNotEmpty).join(' ');
    if (postcodeCity.isNotEmpty) {
      if (spans.isNotEmpty) {
        spans.add(const TextSpan(text: '\n'));
      }
      spans.add(TextSpan(text: postcodeCity));
    }
    final String? country = location.country;
    if (country != null && country.isNotEmpty) {
      if (spans.isNotEmpty) {
        spans.add(const TextSpan(text: '\n'));
      }
      spans.add(TextSpan(text: country));
    }

    return Row(
      children: <Widget>[
        Expanded(
          child: RichText(
            text: TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: spans,
            ),
          ),
        ),
        const SizedBox(width: SMALL_SPACE),
        DecoratedBox(
          decoration: BoxDecoration(
            color: colorScheme.secondary,
            shape: BoxShape.circle,
          ),
          child: const Padding(
            padding: EdgeInsetsDirectional.all(8.0),
            child: icons.Shop(color: Colors.white, size: 20.0),
          ),
        ),
      ],
    );
  }
}
