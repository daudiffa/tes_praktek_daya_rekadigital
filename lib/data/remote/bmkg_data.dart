import 'package:http/http.dart' as http;
import 'package:tes_praktek_daya_rekadigital/data/models/forecast_model.dart';
import 'package:xml/xml.dart';

abstract class BMKGData {
  static Future<ProvinceForecastModel> fetchData(String province) async {
    final rawData = await http.get(
        Uri.parse("https://data.bmkg.go.id/DataMKG/MEWS/DigitalForecast/DigitalForecast-${province.replaceAll(" ", "")}.xml")
    );
    return ProvinceForecastModel.fromXML(XmlDocument.parse(rawData.body));
  }
}