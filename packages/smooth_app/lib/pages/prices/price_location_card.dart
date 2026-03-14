import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_app/database/dao_osm_location.dart';
import 'package:smooth_app/database/local_database.dart';
import 'package:smooth_app/generic_lib/buttons/smooth_large_button_with_icon.dart';
import 'package:smooth_app/generic_lib/design_constants.dart';
import 'package:smooth_app/generic_lib/widgets/smooth_back_button.dart';
import 'package:smooth_app/generic_lib/widgets/smooth_card.dart';
import 'package:smooth_app/helpers/launch_url_helper.dart';
import 'package:smooth_app/l10n/app_localizations.dart';
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
      contentPadding: const EdgeInsetsDirectional.symmetric(
        horizontal: SMALL_SPACE,
        vertical: MEDIUM_SPACE,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (location != null)
            Padding(
              padding: const EdgeInsets.only(bottom: SMALL_SPACE),
              child: Text(
                location.getTitle() ??
                    location.getSubtitle() ??
                    location.getLatLng().toString(),
                style: const TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          SmoothLargeButtonWithIcon(
            text: location == null
                ? appLocalizations.prices_location_find
                : appLocalizations.prices_location_open_map,
            leadingIcon: const icons.Location(),
            trailingIcon: location == null
                ? const icons.Chevron.right(size: 10.0)
                : const icons.ExternalLink(size: 15.0),
            onPressed: () async {
              if (location == null) {
                if (model.proof != null) return;
                await _selectLocation(context, model);
              } else {
                LaunchUrlHelper.launchURL(
                  'https://www.openstreetmap.org/${location.osmType.name.toLowerCase()}/${location.osmId}',
                );
              }
            },
          ),
          if (location != null && model.proof == null)
            Padding(
              padding: const EdgeInsets.only(top: SMALL_SPACE),
              child: SmoothLargeButtonWithIcon(
                text: appLocalizations.prices_location_edit,
                leadingIcon: const icons.Edit(size: 15.0),
                onPressed: () => _selectLocation(context, model),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _selectLocation(BuildContext context, PriceModel model) async {
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
