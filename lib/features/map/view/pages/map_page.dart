import 'package:clean_breathe/features/common/average_display/view/widgets/average_in_city.dart';
import 'package:clean_breathe/features/map/view-model/toggling_view_model.dart';
import 'package:clean_breathe/features/map/view/widgets/locator_button.dart';
import 'package:clean_breathe/features/map/view/widgets/disclaimer_button.dart';
import 'package:clean_breathe/features/map/view/widgets/disclaimer_dialog.dart';
import 'package:clean_breathe/features/map/view/widgets/location_map.dart';
import 'package:clean_breathe/features/map/view/widgets/pollutants_heading.dart';
import 'package:clean_breathe/features/map/view/widgets/pollutants_history_toggler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../../common/navigation/view/widgets/bottom_buttons.dart';
import '../../../common/navigation/view/widgets/navbar.dart';
import '../../view-model/map_view_model.dart';
import '../widgets/dates_heading.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final MapController _mapController = MapController();

  VoidCallback _zoomToCurrentLocation(LatLng? currentLocation) {
    return () => {
      if (currentLocation != null) {
        _mapController.move(currentLocation, 15.0) // Zoom level
      }
    };
  }

  void _showDisclaimerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DisclaimerDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _mainContent(context),
            ),
            BottomButtons(),
          ],
        ),
      ),
    );
  }

  Widget _mainContent(BuildContext context) {
    final mapViewModel = Provider.of<MapViewModel>(context);
    final togglingViewModel = Provider.of<TogglingViewModel>(context);

    if (mapViewModel.isLoading || mapViewModel.loadingSensors) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: NavBar(cityName: mapViewModel.currentCity),
        ),
        body: Column(
          children: [
            PollutantsHistoryToggler(
                togglingViewModel.toggle,
                togglingViewModel.isExpanded
            ),
            if (togglingViewModel.isExpanded) ...[
              PollutantsHeading(
                selectedPollutant: mapViewModel.selectedPollutant,
                onPollutantSelected: mapViewModel.changePollutant,
              ),
              DatesHeading(
                selectedDate: mapViewModel.selectedDate,
                onDateSelected: mapViewModel.changeDate,
              ),
            ],
            Expanded(child: Stack(
              children: [
                LocationMap(_mapController, mapViewModel.currentLocation, mapViewModel.sensorMarkers, mapViewModel.sensors),
                AverageInCityDisplay(mapViewModel.cityAverage(), mapViewModel.pollutantMeasure(), true),
                CenterPositionButton(_zoomToCurrentLocation(mapViewModel.currentLocation)),
                DisclaimerButton(onPressed: _showDisclaimerDialog)
              ],
            ),
            )
          ],
        )
    );
  }
}
