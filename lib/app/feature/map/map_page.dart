import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:go_router/go_router.dart';
import 'package:valli_di_comacchio/app/feature/trade/presentation/trade_page.dart';
import 'package:valli_di_comacchio/app/shared/components/boarder_text/labelText.dart/label_text.dart';
import 'package:valli_di_comacchio/app/shared/components/valli_app_bar/valli_app_bar.dart';
import 'package:valli_di_comacchio/app/shared/core/routes/routes_paths.dart';
import 'package:valli_di_comacchio/app/shared/style/app_colors.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: ValliAppBar(),
        body:
            // Center(
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: <Widget>[
            //       ElevatedButton(
            //           style: ElevatedButton.styleFrom(
            //             backgroundColor: AppColors.palette_accent,
            //           ),
            //           onPressed: () {
            //             context.push(RoutesPaths.trade,
            //                 extra: const TradePageParameters(npcId: 'npc_1'));
            //           },
            //           child: LabelText('Go to Trade DEMO')),
            //       // H1OnPrimary('h1'),
            //       // H3('h3'),
            //       // LabelText('labelText', withBoarder: true),
            //     ],
            //   ),
            // ),
            OSMFlutter(
          controller: MapController(
            initPosition: GeoPoint(latitude: 47.4358055, longitude: 8.4737324),
            areaLimit: const BoundingBox(
              east: 10.4922941,
              north: 47.8084648,
              south: 45.817995,
              west: 5.9559113,
            ),
          ),
          osmOption: OSMOption(
            userTrackingOption: const UserTrackingOption(
              enableTracking: true,
              unFollowUser: false,
            ),
            zoomOption: const ZoomOption(
              initZoom: 8,
              minZoomLevel: 3,
              maxZoomLevel: 19,
              stepZoom: 1.0,
            ),
            userLocationMarker: UserLocationMaker(
              personMarker: const MarkerIcon(
                icon: Icon(
                  Icons.location_history_rounded,
                  color: Colors.red,
                  size: 48,
                ),
              ),
              directionArrowMarker: const MarkerIcon(
                icon: Icon(
                  Icons.double_arrow,
                  size: 48,
                ),
              ),
            ),
            roadConfiguration: const RoadOption(
              roadColor: Colors.yellowAccent,
            ),
          ),
        ));
  }
}
