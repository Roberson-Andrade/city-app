import 'package:city/model/user.dart';
import 'package:uuid/uuid.dart';

class Irregularity {
  final String id;
  final String description;
  final String address;
  final List<String> imagesUrl;
  final User user;
  final int likes;
  final DateTime createdAt;

  Irregularity({
    String? id,
    required this.description,
    required this.address,
    required this.imagesUrl,
    required this.user,
    this.likes = 0,
    required this.createdAt,
  }) : id = id ?? Uuid().v4();
}
