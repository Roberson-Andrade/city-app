import 'package:city/model/user.dart';

class Irregularity {
  final String title;
  final String description;
  final List<String> imagesUrl;
  final User user;

  Irregularity(
      {required this.title,
      required this.description,
      required this.imagesUrl,
      required this.user});
}
