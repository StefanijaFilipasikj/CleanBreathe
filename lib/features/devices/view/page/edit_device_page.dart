import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:location/location.dart';

import '../../model/device.dart';
import '../../view-model/device_view_model.dart';

class EditDevicePage extends StatefulWidget {
  final Device device;

  const EditDevicePage({super.key, required this.device});

  @override
  State<EditDevicePage> createState() => _EditDevicePageState();
}

class _EditDevicePageState extends State<EditDevicePage> {
  final _formKey = GlobalKey<FormState>();
  final MapController _mapController = MapController();

  late int _sensorId;
  late String _deviceId;
  late LatLng _selectedLocation;
  late String _comment;
  late String _description;
  late String _type;
  late String _status;

  bool _useCurrentLocation = true;

  @override
  void initState() {
    super.initState();
    _sensorId = widget.device.sensorId;
    _deviceId = widget.device.deviceId;
    _selectedLocation = LatLng(widget.device.latitude, widget.device.longitude);
    _comment = widget.device.comment;
    _description = widget.device.description;
    _type = widget.device.type;
    _status = widget.device.status;
  }

  final Location _locationService = Location();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Edit Device'),
        centerTitle: true,
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
                  DropdownButtonFormField<String>(
                    isExpanded: true,
                    value: _type,
                    items: [
                      'WIFI_SENSOR_V2',
                      'LORAWAN_TTN_SENSOR_V3',
                      'TTGO_SENSOR_V3_LORA',
                      'TTGO_SENSOR_V3_WIFI',
                      'PENGY_V1',
                      'SENSOR_COMMUNITY',
                      'SMART CITIZEN'
                    ]
                        .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        ))
                        .toList(),
                    onChanged: (value) => setState(() => _type = value!),
                    decoration: const InputDecoration(labelText: 'Device type'),
                  ),
                  const SizedBox(height: 20),
                  const Text('Position', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 230,
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
                          urlTemplate:
                          'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                          subdomains: const ['a', 'b', 'c'],
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: _selectedLocation,
                              builder: (ctx) => const Icon(Icons.location_on,
                                  color: Colors.black, size: 40),
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
                            side: WidgetStateBorderSide.resolveWith(
                                  (Set<WidgetState> states) {
                                if (states.contains(WidgetState.selected)) {
                                  return const BorderSide(width: 1, color: Colors.green);
                                }
                                return const BorderSide(width: 1, color: Colors.black87);
                              },
                            ),
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
                  const SizedBox(height: 25),
                  TextFormField(
                    initialValue: _description,
                    decoration: InputDecoration(
                      labelText: 'Description',
                    ),
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    onSaved: (value) => _description = value ?? '',
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    initialValue: _comment,
                    decoration: InputDecoration(
                      labelText: 'Comment',
                    ),
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    onSaved: (value) => _comment = value ?? '',
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          final updatedDevice = Device(
                            sensorId: _sensorId,
                            deviceId: _deviceId,
                            latitude: _selectedLocation.latitude,
                            longitude: _selectedLocation.longitude,
                            comment: _comment,
                            description: _description,
                            type: _type,
                            status: _status,
                          );
                          Provider.of<DeviceViewModel>(context, listen: false).editDevice(updatedDevice);
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
                      child: const Text('Submit',
                          style: TextStyle(
                              fontSize: 16, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
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
}
