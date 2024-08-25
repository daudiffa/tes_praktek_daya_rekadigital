import 'package:flutter/material.dart';
import 'package:tes_praktek_daya_rekadigital/ui/controllers/main_controllers.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = MainController.instance;
    controller.fetchData();

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
                            "https://upload.wikimedia.org/wikipedia/commons/5/52/Sky_surface.jpg"
                        )
                      )
                    ),
                    child: Column(
                      children: [
                        Text("Aceh"),
                        Text(controller.currentRegency),
                        Text(controller.currentTimestamp),
                        Text(controller.currentTemperature),
                        Text(controller.currentWeather),
                      ],
                    ),
                  );

                case 1:
                  return TabBar(
                    controller: controller.tabController,
                    tabs: [
                      Text("Hari Ini"),
                      Text("Besok"),
                    ]
                  );

                case 2:
                  return SizedBox(
                    height: 100,
                    child: TabBarView(
                        controller: controller.tabController,
                        children: [
                          Text("Hari Ini"),
                          Text("Besok"),
                        ],
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