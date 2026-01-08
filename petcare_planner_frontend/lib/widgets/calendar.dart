import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:petcare_planner_frontend/utils/app_colors.dart';

class CalendarComponent extends StatefulWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const CalendarComponent({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  State<CalendarComponent> createState() => _CalendarComponentState();
}

class _CalendarComponentState extends State<CalendarComponent> {
  DateTime focusedMonth = DateTime.now();

  String get currentMonthYear => DateFormat('MMMM yyyy').format(focusedMonth);

  int get daysInMonth =>
      DateUtils.getDaysInMonth(focusedMonth.year, focusedMonth.month);

  int get firstWeekdayOffset {
    final firstDayOfMonth = DateTime(focusedMonth.year, focusedMonth.month, 1);
    return firstDayOfMonth.weekday % 7;
  }

  @override
  Widget build(BuildContext context) {
    return _calendarCard();
  }

  Widget _calendarCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 12)],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _arrowButton(Icons.chevron_left, _previousMonth),
              Text(
                currentMonthYear,
                style: const TextStyle(
                  fontFamily: "Poppins-Medium",
                  fontSize: 16,
                  color: AppColors.textPrimary,
                ),
              ),
              _arrowButton(Icons.chevron_right, _nextMonth),
            ],
          ),

          const SizedBox(height: 8),

          const Divider(),

          const SizedBox(height: 12),

          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _WeekDay("Sun"),
              SizedBox(width: 20),
              _WeekDay("Mon"),
              SizedBox(width: 20),
              _WeekDay("Tue"),
              SizedBox(width: 20),
              _WeekDay("Wed"),
              SizedBox(width: 20),
              _WeekDay("Thu"),
              SizedBox(width: 20),
              _WeekDay("Fri"),
              SizedBox(width: 20),
              _WeekDay("Sat"),
            ],
          ),

          GridView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: firstWeekdayOffset + daysInMonth,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 4,
            ),
            itemBuilder: (context, index) {
              if (index < firstWeekdayOffset) {
                return const SizedBox.shrink();
              }

              final day = index - firstWeekdayOffset + 1;
              final date = DateTime(focusedMonth.year, focusedMonth.month, day);

              final isSelected = DateUtils.isSameDay(date, widget.selectedDate);
              final isToday = DateUtils.isSameDay(date, DateTime.now());

              return GestureDetector(
                onTap: () {
                  widget.onDateSelected(date); // Notify parent
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: isSelected ? AppColors.primary : null,
                    border: !isSelected && isToday
                        ? Border.all(color: AppColors.primary)
                        : null,
                  ),
                  child: Text(
                    day.toString(),
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 14,
                      color: isSelected
                          ? AppColors.textSecondary
                          : Colors.black,
                      fontWeight: isToday && !isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _previousMonth() {
    setState(() {
      focusedMonth = DateTime(focusedMonth.year, focusedMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      focusedMonth = DateTime(focusedMonth.year, focusedMonth.month + 1);
    });
  }

  Widget _arrowButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 36,
        width: 36,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.61),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
        ),
        child: Icon(icon),
      ),
    );
  }
}

/// --- WEEKDAY LABEL ---
class _WeekDay extends StatelessWidget {
  final String label;

  const _WeekDay(this.label);

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontFamily: "Poppins-Medium",
        fontSize: 15,
        color: AppColors.textPrimary,
      ),
    );
  }
}
