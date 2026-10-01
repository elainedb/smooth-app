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
    final DaoOsmLocation daoOsmLocation = DaoOsmLocation(
      localDatabase,
    );
    await daoOsmLocation.put(osmLocation);

    onLocationChanged.call(osmLocation);
  }

  @override
  Widget build(BuildContext context) {
    final PriceModel model = context.watch<PriceModel>();
    final AppLocalizations appLocalizations = AppLocalizations.of(context);
    final OsmLocation? location = model.location;
    final bool editable = model.proof == null;

    return SmoothCardWithRoundedHeader(
      title: appLocalizations.prices_location_subtitle,
      leading: const icons.Shopping.cart(),
      titlePadding: const EdgeInsetsDirectional.only(start: SMALL_SPACE),
      trailing: location == null
          ? null
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SmoothCardHeaderButton(
                  circled: true,
                  tooltip: appLocalizations.prices_location_open_map,
                  child: const Icon(Icons.map, size: 12.0),
                  onTap: () => Navigator.push<void>(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) =>
                          LocationMapPage(location, popFirst: false),
                    ),
                  ),
                ),
                if (editable)
                  SmoothCardHeaderButton(
                    circled: true,
                    tooltip: appLocalizations.prices_location_edit,
                    child: const icons.Edit(size: 12.0),
                    onTap: () => _onTap(context),
                  ),
              ],
            ),
      contentPadding: const EdgeInsetsDirectional.symmetric(
        horizontal: SMALL_SPACE,
        vertical: MEDIUM_SPACE,
      ),
      child: location == null
          ? _PriceLocationCardEmptyLocation(onTap: () => _onTap(context))
          : _PriceLocationCardLocationSet(location: location),
    );
  }
}

class _PriceLocationCardEmptyLocation extends StatelessWidget {
  const _PriceLocationCardEmptyLocation({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context);
    return SmoothLargeButtonWithIcon(
      text: appLocalizations.prices_location_find,
      leadingIcon: const icons.Location(),
      trailingIcon: const icons.Chevron.right(size: 10.0),
      onPressed: onTap,
    );
  }
}

class _PriceLocationCardLocationSet extends StatelessWidget {
  const _PriceLocationCardLocationSet({required this.location});

  final OsmLocation location;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Row(
      children: <Widget>[
        Expanded(
          child: RichText(
            text: TextSpan(
              style: theme.textTheme.bodyMedium,
              children: <TextSpan>[
                if (location.name != null)
                  TextSpan(
                    text: '${location.name}\n',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                if (location.street != null)
                  TextSpan(text: '${location.street}\n'),
                if (location.postcode != null || location.city != null)
                  TextSpan(
                    text: '${'${location.postcode ?? ''} ${location.city ?? ''}'.trim()}\n',
                  ),
                if (location.country != null)
                  TextSpan(text: '${location.country}\n'),
              ],
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: theme.colorScheme.secondary,
            shape: BoxShape.circle,
          ),
          child: const icons.Shop(
            size: 24.0,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
