import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';
import 'navbar.dart';

class MapView extends StatefulWidget {
  const MapView({Key? key}) : super(key: key);

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  LatLng? _currentLocation;
  String? _currentCity;
  bool _isLoading = true;
  MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception("Location services are disabled.");
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception("Location permissions are denied.");
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception(
          "Location permissions are permanently denied. Cannot request permissions.",
        );
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
        _isLoading = false;
      });

      // Fetch city name from latitude and longitude
      _getCityName(position.latitude, position.longitude);
    } catch (e) {
      debugPrint("Error determining location: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _getCityName(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        setState(() {
          _currentCity = placemarks[0].locality; // City name
        });
      }
    } catch (e) {
      debugPrint("Error fetching city name: $e");
    }
  }

  void _zoomToCurrentLocation() {
    if (_currentLocation != null) {
      _mapController.move(_currentLocation!, 15.0); // Zoom level
    }
  }

  void _showDisclaimerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Disclaimer',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'The data presented is crowdsourced. We do not guarantee its correctness. '
                          'The third-party sensor data is stored as received from their service, while '
                          'the pulse.eco devices depend on the correctness of the used sensors and the '
                          'conditions in their nearest surroundings. Please refer to the FAQ for details.',
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              Positioned(
                top: 5,
                right: 5,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator()
      );
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: NavBar(cityName: _currentCity),
      ),
      body: Stack(
        children: [
          FlutterMap(
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
                      Icons.location_pin,
                      color: Colors.black,
                      size: 40.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            bottom: 55.0,
            right: 10.0,
            child: Container(
              width: 40.0,
              height: 40.0,
              child: FloatingActionButton(
                onPressed: _zoomToCurrentLocation,
                child: const Icon(
                  Icons.my_location,
                  color: Colors.black,
                  size: 30.0,
                ),
                backgroundColor: Color.fromRGBO(255, 255, 255, 0.8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 10.0,
            right: 10.0,
            child: Container(
              width: 100.0,
              height: 35.0,
              child: TextButton(
                onPressed: _showDisclaimerDialog,
                style: TextButton.styleFrom(
                  backgroundColor: Color.fromRGBO(255, 255, 255, 0.8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Disclaimer',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
