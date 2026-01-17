class CustomDrink {
  final String id;
  final String name;
  final int caffeine;

  CustomDrink({
    required this.id,
    required this.name,
    required this.caffeine,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'caffeine': caffeine,
      };

  factory CustomDrink.fromJson(Map<String, dynamic> json) => CustomDrink(
        id: json['id'] as String,
        name: json['name'] as String,
        caffeine: json['caffeine'] as int,
      );
}
