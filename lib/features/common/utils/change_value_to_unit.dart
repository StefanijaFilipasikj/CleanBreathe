String changeValueToUnit(String value) {
  return switch (value) {
    "noise" => "dBA",
    "temperature" => "°C",
    "humidity" => "%",
    "pressure" => "hPa",
    _ => "μg/m³",
  };
}