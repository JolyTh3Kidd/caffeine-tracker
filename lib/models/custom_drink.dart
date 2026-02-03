class CustomDrink {
  final String id;
  final String name;
  final int caffeine;
  final String icon;

  CustomDrink({
    required this.id,
    required this.name,
    required this.caffeine,
    this.icon = 'local_cafe',
  });

  CustomDrink copyWith({
    String? id,
    String? name,
    int? caffeine,
    String? icon,
  }) {
    return CustomDrink(
      id: id ?? this.id,
      name: name ?? this.name,
      caffeine: caffeine ?? this.caffeine,
      icon: icon ?? this.icon,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'caffeine': caffeine,
        'icon': icon,
      };

  factory CustomDrink.fromJson(Map<String, dynamic> json) => CustomDrink(
        id: json['id'] as String,
        name: json['name'] as String,
        caffeine: json['caffeine'] as int,
        icon: json['icon'] as String? ?? 'local_cafe',
      );
}
