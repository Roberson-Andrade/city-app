import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(60.0)),
            child: Image.asset('images/profile.jpg'),
          )
        ],
      ),
      body: const Center(
        child: Text('Hello World!'),
      ),
    );
  }
}
