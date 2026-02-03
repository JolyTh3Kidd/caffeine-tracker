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

  @override
  String get drinkEspresso => '浓缩咖啡';

  @override
  String get drinkCappuccino => '卡布奇诺';

  @override
  String get drinkLatte => '拿铁';

  @override
  String get drinkAmericano => '美式咖啡';

  @override
  String get drinkFilter => '过滤咖啡';

  @override
  String get drinkInstant => '速溶咖啡';

  @override
  String get hintDrinkName => '例如，冰拿铁';

  @override
  String get hintCaffeine => '例如，95';

  @override
  String get unitMg => 'mg';

  @override
  String get saveDrink => '保存饮品';

  @override
  String get filterByDate => '按日期筛选';

  @override
  String filteredLabel(Object label) {
    return '筛选: $label';
  }

  @override
  String totalLabel(Object amount) {
    return 'Total: $amount mg';
  }

  @override
  String get clearFilter => '清除筛选';

  @override
  String get noRecordsFound => '没有记录';

  @override
  String get tryDifferentDateRange => '尝试选择不同的日期范围';

  @override
  String overLimit(Object amount) {
    return '超过 $amount mg';
  }

  @override
  String get withinLimit => '在限制内';

  @override
  String get noDrinkRecords => '没有饮品记录';

  @override
  String get specificDay => '特定日期';

  @override
  String get dateRange => '日期范围';

  @override
  String get specificMonth => '特定月份';

  @override
  String get selectMonth => '选择月份 任选日期';

  @override
  String get deleteDrinkTitle => '删除饮品?';

  @override
  String deleteDrinkContent(Object drinkName) {
    return '您确定要删除吗 \"$drinkName\"?';
  }

  @override
  String confirmAddTitle(Object drinkName) {
    return '添加 $drinkName?';
  }

  @override
  String get confirm => '确认';

  @override
  String get editDefaultDrink => '编辑默认饮品';

  @override
  String get invalidCaffeineNumber => '请输入一个有效的咖啡因数字';

  @override
  String get errorSavingDrink => '保存饮品时出错。请重试。';

  @override
  String get deleteDrinkTooltip => '删除饮品';

  @override
  String get quickAdd => '快速添加';

  @override
  String get manualAdd => '手动添加';

  @override
  String get manualReduce => '手动缩减';

  @override
  String get remaining => '剩余';

  @override
  String get statusOverLimit => '超过限制';

  @override
  String dailyGoalPercent(Object percent) {
    return '$percent% 每日目标';
  }

  @override
  String get chooseIcon => '选择图标';

  @override
  String get editDrinkIcon => '编辑饮品图标';
}
