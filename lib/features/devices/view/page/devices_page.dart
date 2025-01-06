import 'package:clean_breathe/features/devices/view/page/edit_device_page.dart';
import 'package:clean_breathe/features/login/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../view-model/device_view_model.dart';
import 'add_device_page.dart';

class DevicesPage extends StatelessWidget {
  const DevicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Devices'),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
        elevation: 0,
        actions: [
          Container(
            child: TextButton(
              onPressed: () => _logout(context),
              child: const Text(
                'Logout',
                style: TextStyle(color: Colors.white),

              ),
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.black)),

            ),
            margin: const EdgeInsets.only(right: 10.0)
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
        child: Consumer<DeviceViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                ),
              );
            }

            if (viewModel.devices.isEmpty) {
              return const Center(child: Text('No devices available.'));
            }

            return ListView.builder(
              itemCount: viewModel.devices.length,
              itemBuilder: (context, index) {
                final device = viewModel.devices[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 20.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  elevation: 5,
                  color: Colors.white,
                  child: ExpansionTile(
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(
                            device.deviceId,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                device.status == "active"
                                    ? Icons.toggle_on
                                    : Icons.toggle_off,
                                color: device.status == "active"
                                    ? Colors.black
                                    : Colors.black38,
                              ),
                              onPressed: () {
                                viewModel.toggleDeviceStatus(device);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.black),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) =>
                                      EditDevicePage(device: device)),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(
                                  Icons.delete, color: Colors.black),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Delete Device'),
                                      content: const Text(
                                          'Are you sure you want to delete this device?'),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.zero,
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Cancel',
                                            style: TextStyle(
                                                color: Colors.black),),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            viewModel.deleteDevice(device);
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text(
                                            'Delete',
                                            style: TextStyle(
                                                color: Colors.black),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    children: [
                      _buildDeviceDetail(
                          'Sensor ID', device.sensorId.toString()),
                      _buildDeviceDetail('Device ID', device.deviceId),
                      _buildDeviceDetail('Position',
                          '${device.longitude}, ${device.latitude}'),
                      _buildDeviceDetail('Comment', device.comment),
                      _buildDeviceDetail('Description', device.description),
                      _buildDeviceDetail('Type', device.type),
                      _buildDeviceDetail('Status', device.status),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AddDevicePage()),
          );
        },
        backgroundColor: Colors.white,
        child: const Icon(Icons.add, color: Colors.black),
        tooltip: 'Add New Device',
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
      ),
    );
  }

  Widget _buildDeviceDetail(String label, String value) {
    return ListTile(
      title: Text('$label: $value',
          style: const TextStyle(fontSize: 14, color: Colors.black)),
    );
  }

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('user_logged_in', false);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }
}
