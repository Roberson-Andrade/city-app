import 'package:city/app.dart';
import 'package:city/repositories/irregularity_repository.dart';
import 'package:city/repositories/user_repository.dart';
import 'package:city/services/irregularity_service.dart';
import 'package:city/services/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:timeago/timeago.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FlutterConfig.loadEnvVariables();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseFirestore.instance.settings =
      const Settings(persistenceEnabled: true);

  setLocaleMessages('pt_BR', PtBrMessages());

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
          create: (_) => IrregularityRepository(
              irregularityService: IrregularityService())),
      ChangeNotifierProvider(
        create: (_) => UserRepository(userService: UserService()),
      ),
    ],
    child: const App(),
  ));
}
