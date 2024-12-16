import 'package:clean_breathe/features/common/static_info/colors_by_value.dart';
import 'package:clean_breathe/features/map/model/sensor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:icon_decoration/icon_decoration.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';

class LocationMap extends StatelessWidget {
  final MapController _mapController;
  final LatLng? _currentLocation;
  final List<Sensor> _sensors;
  final void Function(String) _onMarkerPress;

  LocationMap(this._mapController, this._currentLocation, this._sensors, this._onMarkerPress);

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        center: _currentLocation,
        zoom: 13.0,
        maxZoom: 18.0,
      ),
      children: [
        TileLayer(
          urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
          subdomains: ['a', 'b', 'c'],
        ),
        MarkerClusterLayerWidget(
          options: MarkerClusterLayerOptions(
            maxClusterRadius: 55,
            size: const Size(50, 50),
            markers: _sensorMarkers,
            builder: (context, markers) {

              // TODO: think of better solution for calculating average
              var filteredSensors = _sensors.where((sensor) => markers.any((marker) => marker.point.latitude == sensor.latitude && marker.point.longitude == sensor.longitude)).toList();
              double averageValue = filteredSensors.map((sensor) => sensor.value).reduce((a, b) => a + b) / filteredSensors.length;

              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [BoxShadow(color: Colors.black54, offset: Offset(0, 0), blurRadius: 6.0,),],
                  border: Border.all(color: Colors.black54, width: 1.0),
                  color: ColorByValue.get(averageValue),
                ),
                child: Center(
                  child: Text(
                    averageValue.toInt().toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  List<Marker> get _sensorMarkers =>
      [
        ..._sensors.map((sensor) =>
            Marker(
              point: LatLng(sensor.latitude, sensor.longitude),
              builder: (ctx) => GestureDetector(
                onTap: () => _onMarkerPress(sensor.sensorId),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    DecoratedIcon(
                      icon: Icon(
                        FontAwesomeIcons.locationPin, size: 50.0,
                        color: ColorByValue.get(sensor.value),
                        shadows: [
                          Shadow(color: Colors.black54,
                            blurRadius: 10,
                            offset: Offset(0, 0),),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 0.0,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 6.0),
                        child: Text(
                          sensor.value.toInt().toString(),
                          style: TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            )
        )
      ];
}