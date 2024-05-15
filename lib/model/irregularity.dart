import 'package:uuid/uuid.dart';

class Irregularity {
  final String id;
  final String description;
  final String address;
  final List<String> imagesUrl;
  final String userId;
  final int likes;
  final DateTime createdAt;

  Irregularity({
    String? id,
    required this.description,
    required this.address,
    required this.imagesUrl,
    required this.userId,
    this.likes = 0,
    required this.createdAt,
  }) : id = id ?? Uuid().v4();

  Irregularity.fromJson(Map<String, dynamic> json)
      : this(
            id: json['id'] as String,
            description: json['description'] as String,
            address: json['address'] as String,
            imagesUrl: List<String>.from(json['imagesUrl']),
            createdAt: json['createdAt'].toDate(),
            userId: json['userId'] as String,
            likes: json['likes'] as int);

  Irregularity copyWith({
    String? id,
    String? description,
    String? address,
    List<String>? imagesUrl,
    String? userId,
    int? likes,
    DateTime? createdAt,
  }) {
    return Irregularity(
      id: id ?? this.id,
      description: description ?? this.description,
      address: address ?? this.address,
      imagesUrl: imagesUrl ?? this.imagesUrl,
      userId: userId ?? this.userId,
      likes: likes ?? this.likes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'description': description,
      'address': address,
      'imagesUrl': imagesUrl,
      'userId': userId,
      'likes': likes,
      'createdAt': createdAt
    };
  }
}
