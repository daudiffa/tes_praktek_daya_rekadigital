import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:tes_praktek_daya_rekadigital/data/remote/bmkg_data.dart';
import 'package:tes_praktek_daya_rekadigital/data/models/forecast_model.dart';
import 'package:tes_praktek_daya_rekadigital/utils/date_utils.dart';
import 'package:weather_icons/weather_icons.dart';

/// The main `ChangeNotifier` class of this application.
///
/// To get an instance of this class, use the `instance` static attribute.
class MainController extends ChangeNotifier {
  // ---- Constructor and instance ----
  /// The singleton instance of this controller.
  static final instance = MainController._();

  /// The private constructor used to create the singleton instance
  ///
  /// This constructor also calls the necessary initial methods such as
  /// `fetchData`
  MainController._() {
    _initBrightnessListener();
    fetchData();
  }

  // ---- Static data ----
  final provinceList = [
    "Aceh",
    "Bali",
    "Bangka Belitung",
    "Banten",
    "Bengkulu",
    "DI Yogyakarta",
    "DKI Jakarta",
    "Gorontalo",
    "Jambi",
    "Jawa Barat",
    "Jawa Tengah",
    "Jawa Timur",
    "Kalimantan Barat",
    "Kalimantan Selatan",
    "Kalimantan Tengah",
    "Kalimantan Timur",
    "Kalimantan Utara",
    "Kepulauan Riau",
    "Lampung",
    "Maluku",
    "Maluku Utara",
    "Nusa Tenggara Barat",
    "Nusa Tenggara Timur",
    "Papua",
    "Papua Barat",
    "Riau",
    "Sulawesi Barat",
    "Sulawesi Selatan",
    "Sulawesi Tengah",
    "Sulawesi Tenggara",
    "Sulawesi Utara",
    "Sumatera Barat",
    "Sumatera Selatan",
    "Sumatera Utara",
  ];

  // ---- States ----
  /// Get and set whether the dark mode is being used
  bool useDarkMode =
      SchedulerBinding.instance.platformDispatcher.platformBrightness == Brightness.dark;

  /// The controller for the main `TabBar` and `TabBarView`
  TabController tabController = TabController(length: 0, vsync: TabTickerProvider());

  /// The data model to be displayed in the screen
  ProvinceForecastModel? _dataModel;

  /// The currently-displayed city/regency name
  String _currentProvince = "Aceh";

  /// The currently-displayed city/regency name
  String? _currentRegency;

  /// The currently-displayed date and time
  DateTime? _currentTimestamp;

  // ---- Getters ----
  /// Get the appropriate background for the screen, based on the theme mode
  String get backgroundImage => (useDarkMode)
      ? "https://upload.wikimedia.org/wikipedia/commons/9/98/C%C3%A9vennes_France_night_sky_with_stars_03.jpg"
      : "https://upload.wikimedia.org/wikipedia/commons/f/f9/Sky_gradient_mid_afternoon_looking_north.jpg";

  /// Get the current province name
  String get currentProvince => _currentProvince;

  /// Get the current city/regency name
  String get currentRegency => _currentRegency ?? "";

  /// Get the currently-displayed date and time
  String get currentTimestamp => (_currentTimestamp != null)
      ? DateFormat("EEEE, d MMMM hh:mm", "id_ID").format(_currentTimestamp!) : "";

  /// Get the currently-displayed temperature
  String get currentTemperature => "${_dataModel?.getRegencyModel(currentRegency)
      .getForecastModel(_currentTimestamp?.toBMKG() ?? "").temperature}°";

  /// Get the currently-displayed weather
  String get currentWeather => _dataModel?.getRegencyModel(currentRegency)
      .getForecastModel(_currentTimestamp?.toBMKG() ?? "").weather ?? "";

  /// Get the list of available day for the current regency
  List<String> get dayList => _dataModel?.getRegencyModel(currentRegency)
      .forecastModel.map((e) => e.timestamp.toDayMonth()).toSet().toList()
      ?? const [];

  /// Get the list of forecast data in the current regency, grouped by date
  Map<String, List<ForecastModel>> get forecastList =>
      groupBy<ForecastModel, String>(
          _dataModel?.getRegencyModel(currentRegency).forecastModel ?? [],
              (e) => e.timestamp.toDayMonth()
      );

  // ---- Setters ----
  set currentProvince(String selectedProvince) {
    _currentProvince = selectedProvince;
    fetchData();
    notifyListeners();
  }

  // ---- Methods ----
  /// Get the icon for the currently-displayed weather
  IconData? getWeatherIcon(String weather) => switch (weather) {
    "Cerah" => WeatherIcons.day_sunny,
    "Cerah Berawan" => WeatherIcons.day_sunny_overcast,
    "Berawan" => WeatherIcons.day_cloudy,
    "Berawan Tebal" => WeatherIcons.cloud,
    "Udara Kabur" => WeatherIcons.day_haze,
    "Asap" => WeatherIcons.smoke,
    "Kabut" => WeatherIcons.fog,
    "Hujan Ringan" => WeatherIcons.showers,
    "Hujan Sedang" => WeatherIcons.rain_mix,
    "Hujan Lebat" => WeatherIcons.rain,
    "Hujan Lokal" => WeatherIcons.day_rain,
    "Hujan Petir" => WeatherIcons.thunderstorm,
    _ => null,
  };

  void _initBrightnessListener() {
    final dispatcher = SchedulerBinding.instance.platformDispatcher;
    dispatcher.onPlatformBrightnessChanged = () {
      useDarkMode = dispatcher.platformBrightness == Brightness.dark;
      notifyListeners();
    };
  }

  /// Method to get the BMKG data and display it on the screen
  void fetchData() {
    BMKGData.fetchData(currentProvince).then((value) {
      _dataModel = value;

      final regencyList = value.regencyForecast.map((e) => e.regencyName).toList()..shuffle();
      _currentRegency = regencyList.first;

      final timestampList = value.getRegencyModel(regencyList.first).forecastModel
          .map((e) => e.timestamp).toList()..shuffle();
      _currentTimestamp = timestampList.first;

      tabController = TabController(length: dayList.length, vsync: TabTickerProvider());

      notifyListeners();
    });
  }

}

/// Custom ticker used for `TabController` objects
class TabTickerProvider extends TickerProvider {
  @override
  Ticker createTicker(TickerCallback onTick) {
    return Ticker(onTick);
  }
}