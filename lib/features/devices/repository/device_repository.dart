import 'package:clean_breathe/features/devices/model/device.dart';

/// this is a mock
class DeviceRepository {
  final deviceExample1 = Device(sensorId: 1, deviceId: 'skp-sfl-idk', latitude: 41.98, longitude: 21.43, comment: 'mock', description: 'mock', type: 'WIFI_SENSOR_V2', status: 'active');
  final deviceExample2 = Device(sensorId: 2, deviceId: 'skp-sfl-idn', latitude: 41.99, longitude: 21.42, comment: 'mock', description: 'mock', type: 'WIFI_SENSOR_V2', status: 'not-active');
  final deviceExample3 = Device(sensorId: 3, deviceId: 'skp-sfl-grs', latitude: 41.99, longitude: 21.42, comment: 'mock', description: 'mock', type: 'WIFI_SENSOR_V2', status: 'active');
  final deviceExample4 = Device(sensorId: 4, deviceId: 'skp-sfl-fka', latitude: 41.99, longitude: 21.42, comment: 'mock', description: 'mock', type: 'WIFI_SENSOR_V2', status: 'not-active');
  final deviceExample5 = Device(sensorId: 4, deviceId: 'skp-sfl-fka', latitude: 41.99, longitude: 21.42, comment: 'mock', description: 'mock', type: 'WIFI_SENSOR_V2', status: 'active');

  int _sensorId = 6;

  final List<Device> _devices = [];

  Future<List<Device>> getDevices() async {
    if (_devices.isEmpty && _sensorId == 6) {
      _devices.addAll([deviceExample1, deviceExample2, deviceExample3, deviceExample4, deviceExample5]);
    }
    return _devices;
  }

  Future<void> addDevice(Device device) async {
    device.sensorId = _sensorId++;
    // city code + user initials + desc
    device.deviceId = 'skp' + '-' + 'sfl' + '-' + device.description.substring(0, 3);
    _devices.add(device);
  }

  void toggleDeviceStatus(Device device){
    device.status = device.status == "active"? "not-active" : "active";
  }

  void editDevice(Device updatedDevice) {
    final index = _devices.indexWhere((device) => device.deviceId == updatedDevice.deviceId);
    if (index != -1) {
      // city code + user initials + desc
      updatedDevice.deviceId = 'skp' + '-' + 'sfl' + '-' + updatedDevice.description.substring(0, 3);
      _devices[index] = updatedDevice;
    }
  }

  void deleteDevice(Device device) {
    _devices.remove(device);
  }
}
