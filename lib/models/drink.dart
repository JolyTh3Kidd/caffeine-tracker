class Drink {
  final String id;
  final String name;
  final int caffeine;
  final int size;

  Drink({
    required this.id,
    required this.name,
    required this.caffeine,
    required this.size,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'caffeine': caffeine,
        'size': size,
      };

  factory Drink.fromJson(Map<String, dynamic> json) => Drink(
        id: json['id'],
        name: json['name'],
        caffeine: json['caffeine'],
        size: json['size'],
      );
}

class CustomDrink {
  final String id;
  final String name;
  final int caffeine;

  CustomDrink({
    required this.id,
    required this.name,
    required this.caffeine,
  });
}
