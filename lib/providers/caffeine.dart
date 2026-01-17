import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/caffeine_state.dart';
import '../services/storage_service.dart';

class CaffeineNotifier extends StateNotifier<CaffeineState> {
  CaffeineNotifier()
      : super(CaffeineState(
          total: StorageService.todayCaffeine,
          limit: StorageService.caffeineLimit,
        ));

  void addCaffeine(int mg) {
    StorageService.addCaffeine(mg);
    state = CaffeineState(total: StorageService.todayCaffeine, limit: state.limit);
  }

  void setLimit(int value) {
    StorageService.setLimit(value);
    state = CaffeineState(total: state.total, limit: value);
  }

  void resetDay() {
    StorageService.resetDay();
    state = CaffeineState(total: 0, limit: state.limit);
  }
}

final caffeineProvider =
    StateNotifierProvider<CaffeineNotifier, CaffeineState>((ref) {
  return CaffeineNotifier();
});
