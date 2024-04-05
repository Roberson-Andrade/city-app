import 'package:city/pages/home/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Category> buttons = [
    Category(name: "Saneamento Básico", icon: Icons.water_drop_outlined),
    Category(name: "Sinalização", icon: Icons.dangerous_outlined),
    Category(name: "Iluminação", icon: Icons.lightbulb_outline),
    Category(name: "Buraco", icon: Icons.remove_road_outlined),
    Category(name: "Lixo", icon: Icons.recycling_outlined),
    Category(name: "Outros", icon: Icons.more_horiz_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16, top: 16),
            child: CircleAvatar(
              backgroundImage: AssetImage('images/profile.jpg'),
            ),
          )
        ],
      ),
      body: const Center(
        child: Text('Hello World!'),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 30),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FloatingActionButton(
              backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
              onPressed: () {
                Navigator.of(context).pushNamed('/irregularities');
              },
              child: const Icon(
                Icons.menu,
              ),
            ),
            SpeedDial(
              spacing: 12,
              icon: Icons.add,
              children: buttons
                  .map((button) => SpeedDialChild(
                        backgroundColor:
                            Theme.of(context).colorScheme.primaryContainer,
                        label: button.name,
                        shape: CircleBorder(),
                        child: Icon(
                          button.icon,
                        ),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
