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
  String get caffeineLimit => 'Giới Hạn Caffeine';

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

  @override
  String get systemTheme => 'Giao Diện Hệ Thống';

  @override
  String get lightTheme => 'Chủ đề sáng';

  @override
  String get darkTheme => 'Chủ đề tối';

  @override
  String get drinkEspresso => 'Espresso';

  @override
  String get drinkCappuccino => 'Cappuccino';

  @override
  String get drinkLatte => 'Latte';

  @override
  String get drinkAmericano => 'Americano';

  @override
  String get drinkFilter => 'Cà phê phin';

  @override
  String get drinkInstant => 'Cà phê hòa tan';

  @override
  String get hintDrinkName => 'ví dụ: Cà phê đá';

  @override
  String get hintCaffeine => 'ví dụ: 95';

  @override
  String get unitMg => 'mg';

  @override
  String get saveDrink => 'Lưu';

  @override
  String get filterByDate => 'Lọc theo ngày';

  @override
  String filteredLabel(Object label) {
    return 'Lọc: $label';
  }

  @override
  String totalLabel(Object amount) {
    return 'Tổng: $amount mg';
  }

  @override
  String get clearFilter => 'Xóa bộ lọc';

  @override
  String get noRecordsFound => 'Không có lịch sử';

  @override
  String get tryDifferentDateRange => 'Thử chọn một khoảng thời gian khác';

  @override
  String overLimit(Object amount) {
    return 'Vượt quá giới hạn $amount mg';
  }

  @override
  String get withinLimit => 'Trong giới hạn';

  @override
  String get noDrinkRecords => 'Không có lịch sử';

  @override
  String get specificDay => 'Thời gian cụ thể';

  @override
  String get dateRange => 'Khoảng thời gian';

  @override
  String get specificMonth => 'Tháng cụ thể';

  @override
  String get selectMonth => 'CHỌN THÁNG (CHỌN NGÀY BẤT KỲ)';

  @override
  String get deleteDrinkTitle => 'Xóa đồ uống?';

  @override
  String deleteDrinkContent(Object drinkName) {
    return 'Bạn có chắc chắn muốn xóa không \"$drinkName\"?';
  }

  @override
  String confirmAddTitle(Object drinkName) {
    return 'Thêm $drinkName?';
  }

  @override
  String get confirm => 'Confirm';

  @override
  String get editDefaultDrink => 'Chỉnh sửa đồ uống mặc định';

  @override
  String get invalidCaffeineNumber =>
      'Vui lòng nhập một số hợp lệ cho caffeine';

  @override
  String get errorSavingDrink => 'Lỗi khi lưu đồ uống. Vui lòng thử lại.';

  @override
  String get deleteDrinkTooltip => 'Xóa đồ uống';

  @override
  String get quickAdd => 'Thêm nhanh';

  @override
  String get manualAdd => 'Thêm thủ công';

  @override
  String get manualReduce => 'Giảm thủ công';

  @override
  String get remaining => 'Còn lại';

  @override
  String get statusOverLimit => 'Vượt quá giới hạn';

  @override
  String dailyGoalPercent(Object percent) {
    return '$percent% của Mục tiêu hàng ngày';
  }

  @override
  String get chooseIcon => 'Chọn Icon';

  @override
  String get editDrinkIcon => 'Chỉnh sửa Icon';
}
