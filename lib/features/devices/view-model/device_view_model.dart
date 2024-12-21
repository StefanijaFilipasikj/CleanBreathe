import 'package:flutter/material.dart';
import '../model/device.dart';
import '../repository/device_repository.dart';

class DeviceViewModel extends ChangeNotifier {
  final DeviceRepository _repository = DeviceRepository();

  List<Device> _devices = [];
  List<Device> get devices => _devices;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  DeviceViewModel() {
    fetchDevices();
  }

  Future<void> fetchDevices() async {
    _isLoading = true;
    notifyListeners();

    _devices = await _repository.getDevices();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addDevice(Device device) async {
    await _repository.addDevice(device);
    await fetchDevices();
  }

  void toggleDeviceStatus(Device device) async {
    _repository.toggleDeviceStatus(device);
    await fetchDevices();
  }

  void editDevice(Device device) async {
    _repository.editDevice(device);
    await fetchDevices();
  }

  void deleteDevice(Device device) async {
    _repository.deleteDevice(device);
    await fetchDevices();
  }
}
