import 'package:city/pages/home/utils.dart';
import 'package:city/pages/irregularity_form/irregularity_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16, top: 16),
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                  "https://avatars.githubusercontent.com/u/78360479?v=4"),
            ),
          )
        ],
      ),
      body: const Center(child: Text("Mapa em construção...")),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildFloatingActionButton() {
    return Padding(
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
            children: _buildSpeedDialChildren(),
          ),
        ],
      ),
    );
  }

  List<SpeedDialChild> _buildSpeedDialChildren() {
    return Category.getAllCategories().map((category) {
      return SpeedDialChild(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        label: category.label,
        shape: const CircleBorder(),
        onTap: () => {
          Navigator.of(context).pushNamed('/irregularities/new',
              arguments: IrregularityFormArgs(category.type))
        },
        child: Icon(
          category.icon,
        ),
      );
    }).toList();
  }
}
