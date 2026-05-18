import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../l10n/app_strings.dart';
import '../widgets/task_detail_sheet.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedMonth = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(s.calendarView, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chevron_left),
                        onPressed: () => setState(() => _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1)),
                      ),
                      Text(
                        _formatMonth(_focusedMonth, s.locale),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.chevron_right),
                        onPressed: () => setState(() => _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            _buildCalendarGrid(context, taskProvider),
            
            const Divider(height: 1),
            
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                '${s.tasksForSelectedDate}: ${_formatDate(taskProvider.selectedDate, s.locale)}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            
            Expanded(
              child: _buildTasksList(context, taskProvider, s),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCalendarGrid(BuildContext context, TaskProvider taskProvider) {
    final daysInMonth = _daysInMonth(_focusedMonth.year, _focusedMonth.month);
    final firstWeekday = DateTime(_focusedMonth.year, _focusedMonth.month, 1).weekday;
    
    // Adjust for Monday start (Dart weekday: 1=Mon, 7=Sun)
    final emptySlots = firstWeekday - 1; 

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          childAspectRatio: 1,
        ),
        itemCount: daysInMonth + emptySlots,
        itemBuilder: (context, index) {
          if (index < emptySlots) return const SizedBox.shrink();
          
          final day = index - emptySlots + 1;
          final date = DateTime(_focusedMonth.year, _focusedMonth.month, day);
          final tasksForDay = taskProvider.getTasksForDate(date);
          
          final isSelected = taskProvider.selectedDate.day == day &&
              taskProvider.selectedDate.month == _focusedMonth.month &&
              taskProvider.selectedDate.year == _focusedMonth.year;
          
          final now = DateTime.now();
          final isToday = now.day == day && now.month == _focusedMonth.month && now.year == _focusedMonth.year;

          return GestureDetector(
            onTap: () => taskProvider.setSelectedDate(date),
            child: Container(
              margin: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : isToday
                        ? Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5)
                        : null,
                borderRadius: BorderRadius.circular(8),
                border: isToday ? Border.all(color: Theme.of(context).colorScheme.primary, width: 1) : null,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Text(
                    day.toString(),
                    style: TextStyle(
                      fontWeight: isSelected || isToday ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? Colors.white : null,
                    ),
                  ),
                  if (tasksForDay.isNotEmpty)
                    Positioned(
                      bottom: 4,
                      child: Container(
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected ? Colors.white : Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTasksList(BuildContext context, TaskProvider taskProvider, AppStrings s) {
    final tasksForDate = taskProvider.getTasksForDate(taskProvider.selectedDate);

    if (tasksForDate.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_busy, size: 48, color: Colors.grey.withOpacity(0.5)),
            const SizedBox(height: 12),
            Text(s.noTasksForDate, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: tasksForDate.length,
      itemBuilder: (context, index) {
        final task = tasksForDate[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            onTap: () => showTaskDetail(context, task),
            leading: Checkbox(
              value: task.isCompleted,
              onChanged: (_) => taskProvider.toggleTaskCompletion(task.id),
            ),
            title: Text(
              task.title,
              style: TextStyle(
                decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Row(
              children: [
                if (task.time != null) ...[
                  const Icon(Icons.access_time, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    '${task.time!.hour.toString().padLeft(2, '0')}:${task.time!.minute.toString().padLeft(2, '0')}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(width: 12),
                ],
                if (task.category != null)
                  Text(
                    task.category!,
                    style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.primary),
                  ),
              ],
            ),
            trailing: const Icon(Icons.chevron_right, size: 18, color: Colors.grey),
          ),
        );
      },
    );
  }

  int _daysInMonth(int year, int month) => DateTime(year, month + 1, 0).day;

  String _formatMonth(DateTime date, String locale) {
    final monthsUz = ['Yanvar', 'Fevral', 'Mart', 'Aprel', 'May', 'Iyun', 'Iyul', 'Avgust', 'Sentabr', 'Oktabr', 'Noyabr', 'Dekabr'];
    final monthsRu = ['Январь', 'Февраль', 'Март', 'Апрель', 'Май', 'Июнь', 'Июль', 'Август', 'Сентябрь', 'Октябрь', 'Ноябрь', 'Декабрь'];
    final monthsEn = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    
    final months = locale == 'ru' ? monthsRu : locale == 'en' ? monthsEn : monthsUz;
    return '${months[date.month - 1]} ${date.year}';
  }

  String _formatDate(DateTime date, String locale) {
    return '${date.day}.${date.month}.${date.year}';
  }
}
