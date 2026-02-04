import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:caffeine_tracker/l10n/app_localizations.dart';
import '../services/storage_service.dart';
import '../models/drink_entry.dart';

class HistoryScreen extends StatefulWidget {
  final VoidCallback? onHistoryChanged;
  const HistoryScreen({super.key, this.onHistoryChanged});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late Map<String, int> history;
  int caffeineLimit = StorageService.caffeineLimit;

  // --- NEW STATE START ---
  DateTimeRange? _filterRange;
  String? _filterLabel;
  // --- NEW STATE END ---

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  void _loadHistory() {
    setState(() {
      history = StorageService.getCaffeineHistory();
      caffeineLimit = StorageService.caffeineLimit;
    });
  }

  // --- NEW FILTER METHODS START ---
  void _clearFilter() {
    setState(() {
      _filterRange = null;
      _filterLabel = null;
    });
  }

  Future<void> _showFilterOptions() async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final now = DateTime.now();

    await showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.calendar_view_day),
              title: Text(AppLocalizations.of(context)!.specificDay),
              onTap: () async {
                Navigator.pop(context);
                final picked = await showDatePicker(
                  context: context,
                  initialDate: now,
                  firstDate: DateTime(2020),
                  lastDate: now,
                );
                if (picked != null) {
                  setState(() {
                    _filterRange = DateTimeRange(start: picked, end: picked);
                    _filterLabel =
                        "${picked.day}/${picked.month}/${picked.year}";
                  });
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.date_range),
              title: Text(AppLocalizations.of(context)!.dateRange),
              onTap: () async {
                Navigator.pop(context);
                final picked = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2020),
                  lastDate: now,
                );
                if (picked != null) {
                  setState(() {
                    _filterRange = picked;
                    _filterLabel =
                        "${picked.start.day}/${picked.start.month} - ${picked.end.day}/${picked.end.month}";
                  });
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_month),
              title: Text(AppLocalizations.of(context)!.specificMonth),
              onTap: () async {
                Navigator.pop(context);
                _pickMonth(context);
              },
            ),
            if (_filterRange != null)
              ListTile(
                leading: const Icon(Icons.clear, color: Colors.red),
                title: Text(AppLocalizations.of(context)!.clearFilter,
                    style: const TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  _clearFilter();
                },
              ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Future<void> _pickMonth(BuildContext context) async {
    final now = DateTime.now();
    // Native workaround for Month Picker: Ask user to pick any day in that month
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2020),
      lastDate: now,
      helpText: AppLocalizations.of(context)!.selectMonth,
    );

    if (picked != null) {
      final start = DateTime(picked.year, picked.month, 1);
      final end =
          DateTime(picked.year, picked.month + 1, 0); // Last day of month
      setState(() {
        _filterRange = DateTimeRange(start: start, end: end);
        _filterLabel = "${_getMonthName(picked.month)} ${picked.year}";
      });
    }
  }

  String _getMonthName(int month) {
    return DateFormat.MMM(AppLocalizations.of(context)!.localeName)
        .format(DateTime(2024, month));
  }
  // --- NEW FILTER METHODS END ---

  Future<void> _confirmDelete(DateTime date, DrinkEntry entry) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.deleteEntry),
        content: Text(AppLocalizations.of(context)!
            .deleteConfirmation(entry.name, entry.caffeine)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(AppLocalizations.of(context)!.delete),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await StorageService.deleteDrink(date, entry);
      _loadHistory();
      if (widget.onHistoryChanged != null) {
        widget.onHistoryChanged!();
      }
    }
  }

  List<MapEntry<String, int>> _getSortedHistory() {
    var entries = history.entries.toList();

    // --- NEW: Apply Date Filter ---
    if (_filterRange != null) {
      entries = entries.where((e) {
        final date = _parseDate(e.key);
        if (date == null) return false;

        final entryDate = DateUtils.dateOnly(date);
        final start = DateUtils.dateOnly(_filterRange!.start);
        final end = DateUtils.dateOnly(_filterRange!.end);

        return (entryDate.isAtSameMomentAs(start) ||
                entryDate.isAfter(start)) &&
            (entryDate.isAtSameMomentAs(end) || entryDate.isBefore(end));
      }).toList();
    }

    entries.sort((a, b) => b.key.compareTo(a.key)); // Sort by date descending
    return entries;
  }

  String _formatDateKey(String key) {
    // key format: 'caffeine_YYYY_MM_DD'
    final parts = key.split('_');
    if (parts.length == 4) {
      final year = parts[1];
      final month = parts[2].padLeft(2, '0');
      final day = parts[3].padLeft(2, '0');
      return '$day/$month/$year';
    }
    return key;
  }

  DateTime? _parseDate(String key) {
    final parts = key.split('_');
    if (parts.length == 4) {
      try {
        return DateTime(
          int.parse(parts[1]),
          int.parse(parts[2]),
          int.parse(parts[3]),
        );
      } catch (_) {}
    }
    return null;
  }

  String _getDayName(BuildContext context, DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly == today) {
      return AppLocalizations.of(context)!.today;
    } else if (dateOnly == yesterday) {
      return AppLocalizations.of(context)!.yesterday;
    }

    return DateFormat.E(AppLocalizations.of(context)!.localeName).format(date);
  }

  String _getLocalizedDrinkName(BuildContext context, String name) {
    // Check for internal tokens first
    if (name == '__MANUAL_ADD__') {
      return AppLocalizations.of(context)!.manualAdd;
    }
    if (name == '__MANUAL_REDUCE__') {
      return AppLocalizations.of(context)!.manualReduce;
    }

    // Fallback for legacy strings or exact matches in other languages
    // This is a bit of a bridge for existing data
    final manualAddStrings = [
      'Manual Add',
      '手动添加',
      'Añadir rápidamente',
      'Thêm nhanh',
      'Қолмен қосу'
    ];
    final manualReduceStrings = [
      'Manual Reduce',
      '手动缩减',
      'Reducción Manual',
      'Giảm thủ công',
      'Қолмен азайту'
    ];

    if (manualAddStrings.contains(name)) {
      return AppLocalizations.of(context)!.manualAdd;
    }
    if (manualReduceStrings.contains(name)) {
      return AppLocalizations.of(context)!.manualReduce;
    }

    // Also check for localized predefined drink names if they match
    // (though most are already localized at the time of addition in current logic)
    // but better to keep them as stored unless it's a manual adjustment.

    return name;
  }

  @override
  Widget build(BuildContext context) {
    final sortedHistory = _getSortedHistory();
    // --- NEW: Calculate Total for Period ---
    final periodTotal =
        sortedHistory.fold<int>(0, (sum, item) => sum + item.value);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.historyTitle),
        backgroundColor: Colors.transparent,
        elevation: 0,
        // --- NEW: Filter Action ---
        actions: [
          IconButton(
            icon: Icon(
              _filterRange != null
                  ? Icons.filter_alt
                  : Icons.filter_alt_outlined,
              color:
                  _filterRange != null ? Theme.of(context).primaryColor : null,
            ),
            tooltip: AppLocalizations.of(context)!.filterByDate,
            onPressed: _showFilterOptions,
          ),
        ],
      ),
      body: Column(
        children: [
          // --- NEW: Filter Summary Header ---
          if (_filterRange != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF2A2A2A) : Colors.grey[100],
                border: Border(
                  bottom: BorderSide(
                    color: isDark ? Colors.black12 : Colors.grey[300]!,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!
                              .filteredLabel(_filterLabel!),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          AppLocalizations.of(context)!.totalLabel(periodTotal),
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: _clearFilter,
                    tooltip: AppLocalizations.of(context)!.clearFilter,
                  ),
                ],
              ),
            ),

          // --- MODIFIED: List wrapped in Expanded ---
          Expanded(
            child: sortedHistory.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.history,
                              size: 64, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          Text(
                            _filterRange != null
                                ? AppLocalizations.of(context)!.noRecordsFound
                                : AppLocalizations.of(context)!.noHistory,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _filterRange != null
                                ? AppLocalizations.of(context)!
                                    .tryDifferentDateRange
                                : AppLocalizations.of(context)!.startTracking,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Colors.grey[600],
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: sortedHistory.length,
                    itemBuilder: (context, index) {
                      final entry = sortedHistory[index];
                      final caffeine = entry.value;
                      final date = _parseDate(entry.key);
                      final dateStr = _formatDateKey(entry.key);
                      final dayName =
                          date != null ? _getDayName(context, date) : '';
                      final exceeded = caffeine > caffeineLimit;
                      final progress =
                          (caffeine / caffeineLimit).clamp(0.0, 1.5);

                      // Get drink entries for this date
                      final drinkEntries = date != null
                          ? StorageService.getDrinkEntriesForDate(date)
                          : <DrinkEntry>[];

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Theme.of(context).cardTheme.color,
                            border: Border.all(
                              color: Theme.of(context)
                                  .dividerColor
                                  .withValues(alpha: 0.1),
                              width: 1,
                            ),
                          ),
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                            ),
                            child: ExpansionTile(
                              tilePadding: const EdgeInsets.all(16),
                              childrenPadding:
                                  const EdgeInsets.fromLTRB(16, 0, 16, 16),
                              title: Row(
                                children: [
                                  // Progress ring
                                  SizedBox(
                                    width: 70,
                                    height: 70,
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        SizedBox(
                                          width: 60,
                                          height: 60,
                                          child: CircularProgressIndicator(
                                            value: progress,
                                            strokeWidth: 5,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                              exceeded
                                                  ? Colors.red[400]!
                                                  : Theme.of(context)
                                                      .primaryColor,
                                            ),
                                            backgroundColor: Theme.of(context)
                                                .colorScheme
                                                .surfaceContainerHighest,
                                          ),
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '$caffeine',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                            ),
                                            Text(
                                              'mg',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelSmall,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  // Date and status info
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          dayName,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall
                                              ?.copyWith(
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                        Text(
                                          dateStr,
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall
                                              ?.copyWith(
                                                color: isDark
                                                    ? Colors.grey[400]
                                                    : Colors.grey[600],
                                              ),
                                        ),
                                        const SizedBox(height: 8),
                                        if (exceeded)
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              color: Colors.red[50],
                                            ),
                                            child: Text(
                                              AppLocalizations.of(context)!
                                                  .overLimit(
                                                      caffeine - caffeineLimit),
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.red[600],
                                              ),
                                            ),
                                          )
                                        else
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              color: Colors.green[50],
                                            ),
                                            child: Text(
                                              AppLocalizations.of(context)!
                                                  .withinLimit,
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.green[700],
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              children: [
                                Divider(
                                  color: Theme.of(context)
                                      .dividerColor
                                      .withValues(alpha: 0.1),
                                  height: 1,
                                  indent: 0,
                                  endIndent: 0,
                                ),
                                const SizedBox(height: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!
                                          .drinksConsumed,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 12),
                                    if (drinkEntries.isEmpty)
                                      Text(
                                        AppLocalizations.of(context)!
                                            .noDrinkRecords,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              color: isDark
                                                  ? Colors.grey[400]
                                                  : Colors.grey[600],
                                            ),
                                      )
                                    else
                                      ...drinkEntries.map((entry) {
                                        final time = entry.timestamp;
                                        final timeStr =
                                            '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      _getLocalizedDrinkName(
                                                          context, entry.name),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodySmall
                                                          ?.copyWith(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                    ),
                                                    Text(
                                                      timeStr,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .labelSmall
                                                          ?.copyWith(
                                                            color: isDark
                                                                ? Colors
                                                                    .grey[400]
                                                                : Colors
                                                                    .grey[600],
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    '${entry.caffeine} mg',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall
                                                        ?.copyWith(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                        ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  if (date != null)
                                                    SizedBox(
                                                      width: 32,
                                                      height: 32,
                                                      child: IconButton(
                                                        padding:
                                                            EdgeInsets.zero,
                                                        icon: Icon(
                                                          Icons.delete_outline,
                                                          size: 18,
                                                          color: isDark
                                                              ? Colors.grey[500]
                                                              : Colors
                                                                  .grey[400],
                                                        ),
                                                        onPressed: () =>
                                                            _confirmDelete(
                                                                date, entry),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        );
                                      }),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
