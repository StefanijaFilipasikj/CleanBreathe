import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class LocationMap extends StatelessWidget {
  final MapController _mapController;
  final LatLng? _currentLocation;
  final List<Marker> _sensorMarkers;


  LocationMap(this._mapController, this._currentLocation, this._sensorMarkers);

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        center: _currentLocation,
        zoom: 13.0,
      ),
      children: [
        TileLayer(
          urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
          subdomains: ['a', 'b', 'c'],
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: _currentLocation!,
              builder: (ctx) => const Icon(
                Icons.location_on,
                color: Colors.black,
                size: 40.0,
              ),
            ),
            ..._sensorMarkers,
          ],
        ),
      ],
    );
  }
}