import 'package:city/repositories/user_repository.dart';
import 'package:city/utils/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Auth().authStateChanges,
        builder: ((context, snapshot) {
          var widget = const Center(child: CircularProgressIndicator());

          if (snapshot.connectionState == ConnectionState.waiting) {
            return widget;
          }

          if (snapshot.hasData) {
            context.read<UserRepository>().getCurrentUser(snapshot.data!.uid);

            SchedulerBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pushReplacementNamed('/home');
            });

            return widget;
          }

          SchedulerBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushReplacementNamed('/login');
          });

          return widget;
        }));
  }
}
