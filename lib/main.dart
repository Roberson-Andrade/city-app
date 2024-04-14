import 'package:city/app.dart';
import 'package:city/repositories/irregularity_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:flutter_config/flutter_config.dart';
import 'package:timeago/timeago.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();

  // await FlutterConfig.loadEnvVariables();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  setLocaleMessages('pt_BR', PtBrMessages());

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => IrregularityRepository())
    ],
    child: const App(),
  ));
}
