class CaffeineState {
  final int total;
  final int limit;

  const CaffeineState({required this.total, required this.limit});

  bool get exceeded => total > limit;
  double get progress => (total / limit).clamp(0.0, 1.5);
}
