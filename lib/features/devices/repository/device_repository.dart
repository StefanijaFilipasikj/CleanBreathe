import 'package:clean_breathe/features/devices/model/device.dart';

//TODO: this is just a mock, replace the logic
class DeviceRepository {
  final deviceExample1 = Device(sensorId: 1, deviceId: 'skp-sfl-idk', latitude: 41.98, longitude: 21.43, comment: 'mock', description: 'mock', type: 'WIFI_SENSOR_V2', status: 'active');
  final deviceExample2 = Device(sensorId: 2, deviceId: 'skp-sfl-idn', latitude: 41.99, longitude: 21.42, comment: 'mock', description: 'mock', type: 'WIFI_SENSOR_V2', status: 'active');
  int _sensorId = 3;

  final List<Device> _devices = [];

  Future<List<Device>> getDevices() async {
    print(_sensorId);
    print(_devices.isEmpty);
    if (_devices.isEmpty && _sensorId == 3) {
      _devices.addAll([deviceExample1, deviceExample2]);
    }
    return _devices;
  }

  Future<void> addDevice(Device device) async {
    device.sensorId = _sensorId++;
    device.deviceId = 'skp' + '-' + 'sfl' + '-' + device.description.substring(0, 3); //TODO: city + user initials + desc
    _devices.add(device);
  }

  void toggleDeviceStatus(Device device){
    print(device.status);
    device.status = device.status == "active"? "not-active" : "active";
  }

  void editDevice(Device updatedDevice) {
    final index = _devices.indexWhere((device) => device.deviceId == updatedDevice.deviceId);
    if (index != -1) {
      updatedDevice.deviceId = 'skp' + '-' + 'sfl' + '-' + updatedDevice.description.substring(0, 3); //TODO: city + user initials + desc
      _devices[index] = updatedDevice;
    }
  }

  void deleteDevice(Device device) {
    _devices.remove(device);
  }
}
