import 'package:city/model/user.dart';
import 'package:city/pages/home/home.dart';
import 'package:city/pages/irregularities/irregularities.dart';
import 'package:city/pages/irregularity_form/irregularity_form.dart';
import 'package:city/pages/profile/profile.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: (RouteSettings settings) {
        var routes = <String, WidgetBuilder>{
          '/': (context) => const HomePage(),
          '/profile': (context) => Profile(user: settings.arguments as User),
          '/irregularities': (context) => const IrregularitiesPage(),
          '/irregularities/new': (context) => IrregularityForm(
              initialCategoryType: settings.arguments as IrregularityFormArgs)
        };
        WidgetBuilder builder = routes[settings.name]!;
        return MaterialPageRoute(builder: (ctx) => builder(ctx));
      },
      locale: const Locale('pt', 'BR'),
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple, brightness: Brightness.dark),
      ),
    );
  }
}
