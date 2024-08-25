import 'package:flutter/material.dart';
import 'package:tes_praktek_daya_rekadigital/ui/controllers/main_controllers.dart';
import 'package:tes_praktek_daya_rekadigital/utils/date_utils.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = MainController.instance;

    final isPortrait = MediaQuery.orientationOf(context) == Orientation.portrait;

    return Material(
      child: ListenableBuilder(
        listenable: controller,
        builder: (context, staticChild) {
          return ListView.builder(
            itemCount: 3,
            itemBuilder: (context, index) {
              switch (index) {
                case 0:
                  return Container(
                    height: (isPortrait) ? 500 : 350,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                          controller.backgroundImage
                        ),
                        fit: BoxFit.cover
                      )
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(color: (controller.useDarkMode)
                                ? Colors.white : Colors.black),
                            borderRadius: const BorderRadius.all(Radius.circular(8))
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              isDense: true,
                              value: controller.currentProvince,
                              items: List.generate(controller.provinceList.length, (index) {
                                return DropdownMenuItem(
                                    value: controller.provinceList[index],
                                    child: Text(controller.provinceList[index])
                                  );
                                }),
                              onChanged: (value) => controller.currentProvince = value!
                            )
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(controller.currentRegency),
                        Text(controller.currentTimestamp),
                        const SizedBox(height: 16),
                        Text(controller.currentTemperature, style: const TextStyle(fontSize: 36),),
                        const SizedBox(height: 32),
                        Icon(controller.getWeatherIcon(controller.currentWeather), size: 54),
                        const SizedBox(height: 16),
                        Text(controller.currentWeather),
                      ],
                    ),
                  );

                case 1:
                  return TabBar(
                    controller: controller.tabController,
                    tabs: controller.dayList.map((day) => Text(day)).toList(),
                    labelPadding: const EdgeInsets.all(16),
                  );

                case 2:
                  return SizedBox(
                    height: 200,
                    child: Center(
                      child: TabBarView(
                          controller: controller.tabController,
                          children: List.generate(
                            controller.forecastList.length, (index) {
                              final dayForecast = controller.forecastList.entries.toList()[index];
                              return ListView.builder(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                                scrollDirection: Axis.horizontal,
                                itemCount: dayForecast.value.length,
                                itemBuilder: (context, index) {
                                  final hourForecast = dayForecast.value[index];
                                  return SizedBox(
                                    width: 90,
                                    height: 100,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(hourForecast.timestamp.toHourMinute()),
                                        const SizedBox(height: 16,),
                                        Icon(controller.getWeatherIcon(hourForecast.weather)),
                                        const SizedBox(height: 16,),
                                        Text("${hourForecast.temperature}°", style: const TextStyle(fontSize: 20),),
                                      ],
                                    ),
                                  );
                                }
                              );
                            }
                          ),
                        ),
                    ),
                  );

                case _: throw IndexError;
              }
            }
          );
        }
      ),
    );
  }
}