import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/storage_service.dart';

/// Daily caffeine limit in mg
const int dailyCaffeineLimit = 400;

/// Riverpod provider
final caffeineProvider = StateNotifierProvider<CaffeineNotifier, CaffeineState>(
  (ref) => CaffeineNotifier(),
);

/// Immutable state class
class CaffeineState {
  final int totalMg;
  final bool isLimitExceeded;

  const CaffeineState({
    required this.totalMg,
    required this.isLimitExceeded,
  });

  double get progress => (totalMg / dailyCaffeineLimit).clamp(0.0, 1.5);

  CaffeineState copyWith({
    int? totalMg,
    bool? isLimitExceeded,
  }) {
    return CaffeineState(
      totalMg: totalMg ?? this.totalMg,
      isLimitExceeded: isLimitExceeded ?? this.isLimitExceeded,
    );
  }
}

/// StateNotifier that controls all caffeine logic
class CaffeineNotifier extends StateNotifier<CaffeineState> {
  CaffeineNotifier()
      : super(
          CaffeineState(
            totalMg: StorageService.todayCaffeine,
            isLimitExceeded: StorageService.todayCaffeine > dailyCaffeineLimit,
          ),
        );

  /// Add caffeine (mg)
  Future<void> addCaffeine(int mg) async {
    final newTotal = state.totalMg + mg;

    await StorageService.addCaffeine(mg);

    state = state.copyWith(
      totalMg: newTotal,
      isLimitExceeded: newTotal > dailyCaffeineLimit,
    );
  }

  /// Reset daily intake
  Future<void> resetDay() async {
    await StorageService.resetDay();

    state = const CaffeineState(
      totalMg: 0,
      isLimitExceeded: false,
    );
  }
}
