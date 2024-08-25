import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

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
}

/// Custom ticker used for `TabController` objects
class TabTickerProvider extends TickerProvider {
  @override
  Ticker createTicker(TickerCallback onTick) {
    return Ticker(onTick);
  }
}