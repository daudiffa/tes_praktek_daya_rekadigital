// Struktur XML: data -> forecast -> issue/area
// issue isinya timestamp
// area ada banyak, datanya mulai dari data lokasi, lalu
//  humidity (hourly, max, min), temperature (hourly, max, min), weather, wind speed, wind direction
// Setiap data cuaca isinya daftar timerange yang mengandung datetime dan value

import 'package:tes_praktek_daya_rekadigital/utils/date_utils.dart';
import 'package:xml/xml.dart';
import 'package:xml/xpath.dart';

class ProvinceForecastModel {
  final String provinceName;
  final List<RegencyForecastModel> regencyForecast;

  ProvinceForecastModel({
    required this.provinceName,
    required this.regencyForecast
  });

  /// XML is expected to be the root node of an XML file given in
  /// https://data.bmkg.go.id/prakiraan-cuaca/
  factory ProvinceForecastModel.fromXML(XmlNode xml) => ProvinceForecastModel(
      provinceName: xml.xpath("/data/forecast/area").first.getAttribute("domain")!,
      regencyForecast: xml.xpath("/data/forecast/area").map(
              (e) => RegencyForecastModel.fromXML(e)
      ).toList()
  );

  /// Get a regency model by the regency's name
  RegencyForecastModel getRegencyModel(String regencyName) {
    return regencyForecast.where((e) => e.regencyName == regencyName).single;
  }
}

class RegencyForecastModel {
  final String regencyName;
  final List<ForecastModel> forecastModel;

  RegencyForecastModel({
    required this.regencyName,
    required this.forecastModel
  });

  /// XML is expected to be a "/data/forecast/area" path node
  factory RegencyForecastModel.fromXML(XmlNode xml) {
    final availableTemperatureTimestamp = xml.xpath("parameter[@id='t']/timerange")
        .map((e) => e.getAttribute("datetime")).toSet();
    final availableWeatherTimestamp = xml.xpath("parameter[@id='weather']/timerange")
        .map((e) => e.getAttribute("datetime")).toSet();
    final availableTimestamp = availableWeatherTimestamp.intersection(availableTemperatureTimestamp)..remove(null);
    return RegencyForecastModel(
      regencyName: xml.getAttribute("description")!,
      forecastModel: availableTimestamp.map((e) => ForecastModel.fromXML(xml, e!)).toList()
    );
  }

  /// Get a forecast model by timestamp
  ForecastModel getForecastModel(String timestamp) {
    print(forecastModel.map((e) => e.timestamp));
    print(timestamp);
    return forecastModel.where((e) => e.timestamp.toBMKG() == timestamp).single;
  }
}

class ForecastModel {
  final DateTime timestamp;
  final String temperature;
  final String weather;

  ForecastModel({
    required this.timestamp,
    required this.temperature,
    required this.weather
  });

  /// XML is expected to be a "/data/forecast/area" path node
  factory ForecastModel.fromXML(XmlNode xml, String timestamp) => ForecastModel(
    timestamp: DateUtils.fromBMKG(timestamp),
    temperature: xml.xpath("parameter[@id='t']/timerange[@datetime='$timestamp']/value[@unit='C']").single.innerText,
    weather: xml.xpath("parameter[@id='weather']/timerange[@datetime='$timestamp']/value").single.innerText,
  );
}