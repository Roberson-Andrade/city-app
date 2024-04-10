import 'package:city/app.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart';

void main() {
  setLocaleMessages('pt_BR', PtBrMessages());

  runApp(const App());
}
