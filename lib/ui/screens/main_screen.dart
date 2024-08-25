import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:tes_praktek_daya_rekadigital/ui/controllers/main_controllers.dart';
import 'package:tes_praktek_daya_rekadigital/utils/date_utils.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = MainController.instance;
    controller.fetchData();

    SchedulerBinding.instance.platformDispatcher.onPlatformBrightnessChanged;

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
                    height: 500,
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
                        DropdownButtonHideUnderline(
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
                        Text(controller.currentRegency),
                        Text(controller.currentTimestamp),
                        Text(controller.currentTemperature),
                        Text(controller.currentWeather),
                        Icon(controller.getWeatherIcon(controller.currentWeather))
                      ],
                    ),
                  );

                case 1:
                  return TabBar(
                    controller: controller.tabController,
                    tabs: controller.dayList.map((day) => Text(day)).toList()
                  );

                case 2:
                  return SizedBox(
                    height: 100,
                    child: TabBarView(
                        controller: controller.tabController,
                        children: List.generate(
                          controller.forecastList.length, (index) {
                            final dayForecast = controller.forecastList.entries.toList()[index];
                            return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: dayForecast.value.length,
                              itemBuilder: (context, index) {
                                final hourForecast = dayForecast.value[index];
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(hourForecast.timestamp.toHourMinute()),
                                    Icon(controller.getWeatherIcon(hourForecast.weather)),
                                    Text(hourForecast.temperature),
                                  ],
                                );
                              }
                            );
                          }
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