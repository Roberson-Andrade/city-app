import 'package:city/model/user.dart';

class Irregularity {
  final String title;
  final String description;
  final User user;

  Irregularity(
      {required this.title, required this.description, required this.user});
}
