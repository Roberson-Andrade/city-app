import 'package:city/pages/home/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _showButtons = false;
  List<Category> buttons = [
    Category(name: "Buraco", icon: Icons.car_crash_outlined),
  ];

  void _toggleShowButtons() {
    setState(() {
      _showButtons = !_showButtons;
    });
  }

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
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        children: buttons
            .map((button) => SpeedDialChild(
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer,
                  label: button.name,
                  child: Icon(
                    button.icon,
                  ),
                ))
            .toList(),
      ),
    );
  }
}
