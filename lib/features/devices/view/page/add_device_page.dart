import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:location/location.dart';

import '../../model/device.dart';
import '../../view-model/device_view_model.dart';

class AddDevicePage extends StatefulWidget {
  const AddDevicePage({super.key});

  @override
  State<AddDevicePage> createState() => _AddDevicePageState();
}

class _AddDevicePageState extends State<AddDevicePage> {
  final _formKey = GlobalKey<FormState>();
  final MapController _mapController = MapController();

  int _sensorId = -1;
  String _deviceId = '';
  LatLng _selectedLocation = LatLng(42.0, 21.0);
  String _comment = '';
  String _description = '';
  String _type = 'WIFI_SENSOR_V2';
  String _status = 'active';

  bool _useCurrentLocation = true;

  @override
  void initState() {
    super.initState();
    _useCurrentLocation = true;
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    final hasPermission = await _locationService.requestPermission();
    if (hasPermission == PermissionStatus.granted) {
      final currentLocation = await _locationService.getLocation();
      setState(() {
        _selectedLocation = LatLng(currentLocation.latitude!, currentLocation.longitude!);
        _useCurrentLocation = true;
        _mapController.move(_selectedLocation, 13.0);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location permission denied')),
      );
    }
  }

  final List<String> _deviceTypes = [
    'WIFI_SENSOR_V2',
    'LORAWAN_TTN_SENSOR_V3',
    'TTGO_SENSOR_V3_LORA',
    'TTGO_SENSOR_V3_WIFI',
    'PENGY_V1',
    'SENSOR_COMMUNITY',
    'SMART CITIZEN'
  ];

  final Location _locationService = Location();
  PageController _pageController = PageController();

  void _showInfoModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
            child: Container(
              height: 450,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 20.0, right: 20.0, top: 10.0, bottom: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'How to Add a Device',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    Expanded(
                      child: _InstructionPages(),
                    ),
                  ],
                ),
              ),
            ));
      },
    );
  }

  Widget _InstructionPages() {
    return PageView(
      controller: _pageController,
      scrollDirection: Axis.horizontal,
      children: [
        _buildInstructionPage(
          title: 'Step 1: Build the Device',
          content:
              'Before planning on constructing a pulse.eco device, see if your community has a lead and if you need to contact them. You can still add your device, but in the case of managed communities, it\'s up to them to finally \'confirm\' your device as valid.\n'
              '(Wi-Fi sensor steps example):\n'
              '1. Buy the core components.\n' //': NodeMCU, Grove sensor (based on BME680), Nova SDS011 PM sensor, Resistors: 100kOhms and 220kOhms.\n'
              '2. Buy the optional components.\n' //': 5x7cm PCB, mixed short jumper cables set, grove female jumper cables, Micro USB cable, 5V / 1A DC adapter.\n'
              '3. Assemble the components and package them in a plastic container.\n'
              '4. Flash the software.' //': plugin the device to the computer via a data Micro-USB cable, start the NodeMUC PyFlasher, choose the correct serial port, locate the downloaded firmware location...\n'
        ),
        _buildInstructionPage(
          title: 'Step 2: Place the Device',
          content:
              '1. Place the device outside (balcony or yard), fixed to a wall or a post, and protected from direct sunlight and rain.\n'
              '2. Make sure that the Wi-Fi reception at the place of installation is solid.\n'
              '3. Place the device away from active sources of contamination.\n' //' (anything that produces smoke, vibration or sound, e.g.: ashtray, airconditioner, construction site.\n'
              '4. Make sure the device faces the louder side of the object, so that the noise measurement is more realistic.\n'
              '5. Make sure the device is installed very high (more than 3 or 4 stories) so that the measurements will be reliable.',
        ),
        _buildInstructionPage(
          title: 'Step 3: Complete the process',
          content:
              'Click out of this window and fill out the form. You\'re device will then be added to our platform.\n'
              '\n(RECOMMENDED)\nFor detailed information on building and placing you device check out the following links: \n'
              '-https://pulse.eco/requestDeviceInfo \n'
              '-https://pulse.eco/construct \n'
              '-https://pulse.eco/constructWiFi\n'
              '-https://pulse.eco/constructTTNUno\n'
              '-https://pulse.eco/faq'
        ),
      ],
    );
  }

  Widget _buildInstructionPage(
      {required String title, required String content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Text(content),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              color: Colors.black,
              onPressed: () {
                if (_pageController.page! > 0) {
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward),
              color: Colors.black,
              onPressed: () {
                if (_pageController.page! < 2) {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              },
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Add Device'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed:
                _showInfoModal,
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: SingleChildScrollView(
            child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Device Type Dropdown
              DropdownButtonFormField<String>(
                isExpanded: true,
                value: _type,
                items: _deviceTypes
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => _type = value!),
                decoration: const InputDecoration(labelText: 'Device type'),
              ),
              const SizedBox(height: 30),
              const Text('Position', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              SizedBox(
                height: 220,
                child: FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    center: _selectedLocation,
                    zoom: 13.0,
                    onTap: (_, latLng) {
                      setState(() {
                        _selectedLocation = latLng;
                        _useCurrentLocation = false;
                      });
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      subdomains: const ['a', 'b', 'c'],
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: _selectedLocation,
                          builder: (ctx) => const Icon(Icons.location_on, color: Colors.black, size: 40),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              GestureDetector(
                onTap: () async {
                  if (!_useCurrentLocation) {
                    await _getCurrentLocation();
                  } else {
                    setState(() => _useCurrentLocation = false);
                  }
                },
                child: Row(
                  children: [
                    Transform.scale(
                      scale: 1.3,
                      child: Checkbox(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity(horizontal: -4),
                        value: _useCurrentLocation,
                        onChanged: (value) async {
                          if (value == true) {
                            await _getCurrentLocation();
                          } else {
                            setState(() => _useCurrentLocation = false);
                          }
                        },
                        activeColor: Colors.green,
                        checkColor: Colors.white,
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(left: 5),
                        child: Text('Use my current location')
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Description',
                ),
                onSaved: (value) => _description = value ?? '',
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Comment',
                ),
                onSaved: (value) => _comment = value ?? '',
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();

                      final newDevice = Device(
                        sensorId: _sensorId,
                        deviceId: _deviceId,
                        latitude: _selectedLocation.latitude,
                        longitude: _selectedLocation.longitude,
                        comment: _comment,
                        description: _description,
                        type: _type,
                        status: _status,
                      );

                      Provider.of<DeviceViewModel>(context, listen: false).addDevice(newDevice);
                      Navigator.of(context).pop();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Submit', style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
