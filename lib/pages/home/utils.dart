import 'package:flutter/material.dart';

enum CategoryType { basicSanitation, signage, lighting, hole, trash, others }

class Category {
  static const Map<CategoryType, Map<String, dynamic>> _categoryData = {
    CategoryType.basicSanitation: {
      'label': 'Saneamento básico',
      'icon': Icons.water_drop_outlined,
    },
    CategoryType.signage: {
      'label': 'Sinalização',
      'icon': Icons.dangerous_outlined,
    },
    CategoryType.lighting: {
      'label': 'Iluminação',
      'icon': Icons.lightbulb_outline,
    },
    CategoryType.hole: {
      'label': 'Buraco',
      'icon': Icons.remove_road_outlined,
    },
    CategoryType.trash: {
      'label': 'Lixo',
      'icon': Icons.recycling_outlined,
    },
    CategoryType.others: {
      'label': 'Outros',
      'icon': Icons.more_horiz_outlined,
    },
  };

  final CategoryType type;

  Category(this.type);

  String get label => _categoryData[type]!['label'] ?? '';
  IconData get icon => _categoryData[type]!['icon'] ?? Icons.error_outline;

  static List<Category> getAllCategories() {
    return CategoryType.values.map((type) => Category(type)).toList();
  }
}
