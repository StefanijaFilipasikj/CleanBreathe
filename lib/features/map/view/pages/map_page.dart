import 'package:clean_breathe/features/map/view/widgets/average_in_city.dart';
import 'package:clean_breathe/features/map/view/widgets/locator_button.dart';
import 'package:clean_breathe/features/map/view/widgets/disclaimer_button.dart';
import 'package:clean_breathe/features/map/view/widgets/disclaimer_dialog.dart';
import 'package:clean_breathe/features/map/view/widgets/location_map.dart';
import 'package:clean_breathe/features/map/view/widgets/pollutants_heading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
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
    return Consumer<MapViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading || viewModel.loadingSensors) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Scaffold(
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(kToolbarHeight),
                child: NavBar(cityName: viewModel.currentCity),
              ),
              body: Column(
                children: [
                  PollutantsHeading(
                    selectedPollutant: viewModel.selectedPollutant,
                    onPollutantSelected: viewModel.changePollutant,
                  ),
                  DatesHeading(
                    selectedDate: viewModel.selectedDate,
                    onDateSelected: viewModel.changeDate,
                  ),
                  Expanded(child: Stack(
                    children: [
                      LocationMap(_mapController, viewModel.currentLocation, viewModel.sensorMarkers, viewModel.sensors),
                      AverageInCityDisplay(viewModel.cityAverage(), viewModel.pollutantMeasure()),
                      CenterPositionButton(_zoomToCurrentLocation(viewModel.currentLocation)),
                      DisclaimerButton(onPressed: _showDisclaimerDialog)
                    ],
                  ),
                  )
                ],
              )
          );
        }
    );
  }
}
