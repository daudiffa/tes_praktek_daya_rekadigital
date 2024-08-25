import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:tes_praktek_daya_rekadigital/data/remote/bmkg_data.dart';
import 'package:tes_praktek_daya_rekadigital/data/models/forecast_model.dart';
import 'package:tes_praktek_daya_rekadigital/utils/date_utils.dart';

/// The main `ChangeNotifier` class of this application.
///
/// To get an instance of this class, use the `instance` static attribute.
class MainController extends ChangeNotifier {
  // ---- Constructor and instance ----
  /// The singleton instance of this controller.
  static final instance = MainController._();

  /// The private constructor used to create the singleton instance
  MainController._();

  // ---- States ----
  /// The controller for the main `TabBar` and `TabBarView`
  final tabController = TabController(length: 2, vsync: TabTickerProvider());

  /// The data model to be displayed in the screen
  ProvinceForecastModel? _dataModel;

  /// The currently-displayed city/regency name
  String? _currentRegency;

  /// The currently-displayed date and time
  DateTime? _currentTimestamp;

  // ---- Getters ----
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

  // ---- Methods ----
  void fetchData() {
    BMKGData.fetchData().then((value) {
      _dataModel = value;
      final regencyList = value.regencyForecast.map((e) => e.regencyName).toList()..shuffle();
      _currentRegency = regencyList.first;
      final timestampList = value.getRegencyModel(regencyList.first).forecastModel
          .map((e) => e.timestamp).toList()..shuffle();
      _currentTimestamp = timestampList.first;
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