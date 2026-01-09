class Recipe {
  final int? id;
  final String title;
  final String category;
  final String ingredients;
  final String steps;
  final String note;
  final String createdAt;

  Recipe({
    this.id,
    required this.title,
    required this.category,
    required this.ingredients,
    required this.steps,
    required this.note,
    required this.createdAt,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'],
      title: json['title'] ?? '',
      category: json['category'] ?? '',
      ingredients: json['ingredients'] ?? '',
      steps: json['steps'] ?? '',
      note: json['note'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'category': category,
      'ingredients': ingredients,
      'steps': steps,
      'note': note,
    };
  }
}