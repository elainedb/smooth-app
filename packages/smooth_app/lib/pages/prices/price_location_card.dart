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

    return SmoothCardWithRoundedHeader(
      title: appLocalizations.prices_location_subtitle,
      leading: const icons.Shopping.cart(),
      titlePadding: const EdgeInsetsDirectional.only(
        top: 2.0,
        start: LARGE_SPACE,
        end: SMALL_SPACE,
        bottom: 2.0,
      ),
      trailing: location != null
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
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
                  child: const icons.Location(size: 12.0),
                ),
                if (model.cropParameters != null)
                  SmoothCardHeaderButton(
                    circled: true,
                    tooltip: appLocalizations.prices_location_edit,
                    onTap: () => _onTap(context),
                    child: const icons.Edit(size: 12.0),
                  ),
              ],
            )
          : null,
      contentPadding: const EdgeInsetsDirectional.symmetric(
        horizontal: SMALL_SPACE,
        vertical: MEDIUM_SPACE,
      ),
      child: location == null
          ? _PriceLocationCardEmptyLocation(
              onLocationChanged: onLocationChanged,
            )
          : _PriceLocationCardFullAddress(location: location),
    );
  }

  Future<void> _onTap(BuildContext context) async {
    final PriceModel model = context.read<PriceModel>();
    if (model.proof != null) {
      return;
    }
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
  const _PriceLocationCardEmptyLocation({required this.onLocationChanged});

  final Function(OsmLocation location) onLocationChanged;

  @override
  Widget build(BuildContext context) {
    final PriceModel model = context.watch<PriceModel>();
    final AppLocalizations appLocalizations = AppLocalizations.of(context);

    return SmoothLargeButtonWithIcon(
      text: appLocalizations.prices_location_find,
      leadingIcon: const icons.Location(),
      trailingIcon: const icons.Chevron.right(size: 10.0),
      onPressed: model.proof != null
          ? null
          : () async {
              final LocalDatabase localDatabase =
                  context.read<LocalDatabase>();
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
                  SearchLocationPreloadedItem(
                    osmLocation,
                    popFirst: false,
                  ),
                );
              }
              final OsmLocation? osmLocation =
                  await Navigator.push<OsmLocation>(
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
            },
    );
  }
}

class _PriceLocationCardFullAddress extends StatelessWidget {
  const _PriceLocationCardFullAddress({required this.location});

  final OsmLocation location;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: <Widget>[
        Expanded(
          child: RichText(
            text: TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: <TextSpan>[
                if (location.getTitle() != null)
                  TextSpan(
                    text: '${location.getTitle()}\n',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                if (location.street != null)
                  TextSpan(text: '${location.street}\n'),
                TextSpan(
                  text:
                      '${location.postcode ?? ''} ${location.city ?? ''}\n'
                          .trim(),
                ),
                if (location.country != null)
                  TextSpan(text: '${location.country}'),
              ],
            ),
          ),
        ),
        Container(
          padding: const EdgeInsetsDirectional.all(8.0),
          decoration: BoxDecoration(
            color: colorScheme.secondary,
            shape: BoxShape.circle,
          ),
          child: const icons.Shop(
            size: 20.0,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
