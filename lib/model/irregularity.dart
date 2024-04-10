import 'package:city/model/user.dart';

class Irregularity {
  final String title;
  final String description;
  final String address;
  final List<String> imagesUrl;
  final User user;
  final int likes;
  final DateTime createdAt;

  Irregularity(
      {required this.title,
      required this.description,
      required this.address,
      required this.imagesUrl,
      required this.user,
      required this.likes,
      required this.createdAt});
}
