class PredefinedDrink {
  final String id;
  final String name;
  final int caffeine;
  final String icon;

  final bool isModified;

  const PredefinedDrink({
    required this.id,
    required this.name,
    required this.caffeine,
    this.icon = 'local_cafe',
    this.isModified = false,
  });

  static const List<PredefinedDrink> defaults = [
    PredefinedDrink(
        id: 'espresso', name: 'Espresso', caffeine: 63, icon: 'local_cafe'),
    PredefinedDrink(
        id: 'cappuccino',
        name: 'Cappuccino',
        caffeine: 75,
        icon: 'emoji_food_beverage'),
    PredefinedDrink(
        id: 'latte', name: 'Latte', caffeine: 75, icon: 'local_cafe'),
    PredefinedDrink(
        id: 'americano', name: 'Americano', caffeine: 95, icon: 'local_cafe'),
    PredefinedDrink(
        id: 'filter', name: 'Filter', caffeine: 120, icon: 'coffee_maker'),
    PredefinedDrink(id: 'instant', name: 'Instant', caffeine: 60, icon: 'bolt'),
  ];
}
