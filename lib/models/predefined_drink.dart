class PredefinedDrink {
  final String id;
  final String name;
  final int caffeine;

  final bool isModified;

  const PredefinedDrink({
    required this.id,
    required this.name,
    required this.caffeine,
    this.isModified = false,
  });

  static const List<PredefinedDrink> defaults = [
    PredefinedDrink(id: 'espresso', name: 'Espresso', caffeine: 63),
    PredefinedDrink(id: 'cappuccino', name: 'Cappuccino', caffeine: 75),
    PredefinedDrink(id: 'latte', name: 'Latte', caffeine: 75),
    PredefinedDrink(id: 'americano', name: 'Americano', caffeine: 95),
    PredefinedDrink(id: 'filter', name: 'Filter', caffeine: 120),
    PredefinedDrink(id: 'instant', name: 'Instant', caffeine: 60),
  ];
}
