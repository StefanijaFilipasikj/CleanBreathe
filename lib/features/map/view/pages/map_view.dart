import 'dart:convert';
import 'package:clean_breathe/features/map/view/widgets/pollutants_heading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';
import '../../../common/navigation/view/widgets/navbar.dart';
import 'package:http/http.dart' as http;

class MapView extends StatefulWidget {
  const MapView({Key? key}) : super(key: key);

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  LatLng? _currentLocation;
  String? _currentCity;
  bool _isLoading = true;
  bool _loadingSensors = false;
  List<Marker> _sensorMarkers = [];
  String _selectedPollutant = "pm10"; // Default pollutant
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

        await _fetchSensors(_currentCity!);
      }
    } catch (e) {
      debugPrint("Error fetching city name: $e");
    }
  }

  Future<void> _fetchSensors(String cityName) async {
    setState(() {
      _loadingSensors = true;
    });

    final url = Uri.parse("https://$cityName.pulse.eco/rest/data24h");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);

        // Group sensors by sensorId and type
        Map<String, Map<String, List<dynamic>>> groupedData = {};

        for (var sensor in data) {
          String sensorId = sensor['sensorId'];
          String type = sensor['type'];

          if (!groupedData.containsKey(sensorId)) {
            groupedData[sensorId] = {};
          }
          if (!groupedData[sensorId]!.containsKey(type)) {
            groupedData[sensorId]![type] = [];
          }
          groupedData[sensorId]![type]!.add(sensor);
        }

        // Calculate the average value for sensorId and selected type
        List<Marker> markers = [];
        groupedData.forEach((sensorId, sensorTypes) {
          if (sensorTypes.containsKey(_selectedPollutant)) {
            List<dynamic> pm10Data = sensorTypes[_selectedPollutant]!;
            double totalValue = 0;
            int count = 0;

            for (var sensor in pm10Data) {
              totalValue += double.parse(sensor['value']);
              count++;
            }

            double averageValue = totalValue / count;

            var position = pm10Data.last['position'].split(',');
            double lat = double.parse(position[0]);
            double lon = double.parse(position[1]);

            // Determine marker color based on average value
            Color markerColor = _getColorForValue(averageValue);

            markers.add(Marker(
              point: LatLng(lat, lon),
              builder: (ctx) => Icon(
                Icons.location_on,
                color: markerColor,
                size: 40.0,
              ),
            ));
          }
        });

        setState(() {
          _sensorMarkers = markers;
        });
      } else {
        throw Exception("Failed to load sensors");
      }
    } catch (e) {
      debugPrint("Error fetching sensors: $e");
    } finally {
      setState(() {
        _loadingSensors = false;
      });
    }
  }

  void _onPollutantSelected(String pollutant) {
    setState(() {
      _selectedPollutant = pollutant;
    });

    if (_currentCity != null) {
      _fetchSensors(_currentCity!);
    }
  }



  Color _getColorForValue(double value) {
    //TODO make this dynamic, each pollutant has a different color scale
    if(value < 20.0){
      return Color.fromRGBO(37, 143, 48, 1); //dark green
    }else if(value < 50.0){
      return Color.fromRGBO(79, 191, 73, 1); //lighter green
    }else if(value < 80.0){
      return Color.fromRGBO(245, 202, 61, 1); //yellow-orange
    }else if(value < 150.0){
      return Color.fromRGBO(214, 66, 81, 1); //red-pink
    }else{
      return Color.fromRGBO(131, 29, 40, 1.0); //dark-red
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
    if (_isLoading || _loadingSensors) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: NavBar(cityName: _currentCity),
      ),
      body: Column(
        children: [
          PollutantsHeading(
            selectedPollutant: _selectedPollutant,
            onPollutantSelected: _onPollutantSelected,
          ),
          Expanded(child: Stack(
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
                          Icons.location_on,
                          color: Colors.black,
                          size: 40.0,
                        ),
                      ),
                      ..._sensorMarkers,
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
          )
        ],
      )
    );
  }
}
