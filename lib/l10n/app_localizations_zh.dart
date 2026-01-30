// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '咖啡因追踪';

  @override
  String get historyTitle => '历史记录';

  @override
  String get caffeineLimit => '咖啡因限量';

  @override
  String get noHistory => '暂无记录';

  @override
  String get startTracking => '开始追踪您的咖啡因摄入量';

  @override
  String get today => '今天';

  @override
  String get yesterday => '昨天';

  @override
  String get drinksConsumed => '已饮用饮品';

  @override
  String get deleteEntry => '删除记录';

  @override
  String deleteConfirmation(Object drinkName, Object amount) {
    return '从历史记录中删除 $drinkName ($amount mg)?';
  }

  @override
  String get cancel => '取消';

  @override
  String get delete => '删除';

  @override
  String get save => '保存更改';

  @override
  String get editDrink => '编辑饮品';

  @override
  String get drinkName => '饮品名称';

  @override
  String get caffeineContent => '咖啡因含量';

  @override
  String get fillAllFields => '请填写所有字段';

  @override
  String get settings => '设置';

  @override
  String get language => '语言';

  @override
  String get theme => '主题';

  @override
  String get selectLanguage => '选择语言';

  @override
  String get dailyLimit => '每日限额';

  @override
  String get addCustom => '添加自定义饮品';

  @override
  String get systemTheme => '系统主题';

  @override
  String get lightTheme => '浅色主题';

  @override
  String get darkTheme => '深色主题';
}
