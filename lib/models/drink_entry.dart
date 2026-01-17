import 'dart:convert';

class DrinkEntry {
  final String name;
  final int caffeine;
  final DateTime timestamp;

  DrinkEntry({
    required this.name,
    required this.caffeine,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'caffeine': caffeine,
        'timestamp': timestamp.toIso8601String(),
      };

  factory DrinkEntry.fromJson(Map<String, dynamic> json) => DrinkEntry(
        name: json['name'] as String,
        caffeine: json['caffeine'] as int,
        timestamp: DateTime.parse(json['timestamp'] as String),
      );

  factory DrinkEntry.fromJsonString(String json) =>
      DrinkEntry.fromJson(jsonDecode(json) as Map<String, dynamic>);

  String toJsonString() => jsonEncode(toJson());
}
