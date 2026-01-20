// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'Theo Dõi Caffeine';

  @override
  String get historyTitle => 'Lịch Sử';

  @override
  String get noHistory => 'Chưa có lịch sử';

  @override
  String get startTracking => 'Bắt đầu theo dõi lượng caffeine của bạn';

  @override
  String get today => 'Hôm nay';

  @override
  String get yesterday => 'Hôm qua';

  @override
  String get drinksConsumed => 'Đồ uống đã dùng';

  @override
  String get deleteEntry => 'Xóa mục';

  @override
  String deleteConfirmation(Object drinkName, Object amount) {
    return 'Xóa $drinkName ($amount mg) khỏi lịch sử?';
  }

  @override
  String get cancel => 'Hủy';

  @override
  String get delete => 'Xóa';

  @override
  String get save => 'Lưu thay đổi';

  @override
  String get editDrink => 'Chỉnh sửa đồ uống';

  @override
  String get drinkName => 'Tên đồ uống';

  @override
  String get caffeineContent => 'Hàm lượng caffeine';

  @override
  String get fillAllFields => 'Vui lòng điền tất cả các trường';

  @override
  String get settings => 'Cài đặt';

  @override
  String get language => 'Ngôn ngữ';

  @override
  String get theme => 'Giao diện';

  @override
  String get selectLanguage => 'Chọn ngôn ngữ';

  @override
  String get dailyLimit => 'Giới hạn hàng ngày';

  @override
  String get addCustom => 'Thêm đồ uống tùy chỉnh';
}
