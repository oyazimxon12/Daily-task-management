import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../l10n/app_strings.dart';
import '../models/task.dart';
import '../widgets/task_detail_sheet.dart';
import '../widgets/completion_celebration.dart';

enum TaskFilter { all, done, pending, missed }

class TasksListScreen extends StatefulWidget {
  const TasksListScreen({super.key});

  @override
  State<TasksListScreen> createState() => _TasksListScreenState();
}

class _TasksListScreenState extends State<TasksListScreen> {
  TaskFilter _currentFilter = TaskFilter.all;

  bool _isMissed(Task task) {
    if (task.isCompleted) return false;
    final now = DateTime.now();
    final taskDate = DateTime(task.date.year, task.date.month, task.date.day);
    final today = DateTime(now.year, now.month, now.day);

    if (taskDate.isBefore(today)) return true;
    if (taskDate.isAtSameMomentAs(today) && task.time != null) {
      if (task.time!.hour < now.hour) return true;
      if (task.time!.hour == now.hour && task.time!.minute < now.minute) return true;
    }
    return false;
  }

  List<Task> _filterTasks(List<Task> tasks) {
    switch (_currentFilter) {
      case TaskFilter.done:
        return tasks.where((t) => t.isCompleted).toList();
      case TaskFilter.pending:
        return tasks.where((t) => !t.isCompleted && !_isMissed(t)).toList();
      case TaskFilter.missed:
        return tasks.where((t) => _isMissed(t)).toList();
      case TaskFilter.all:
      default:
        return tasks;
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);

    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        final filteredTasks = _filterTasks(taskProvider.tasks);

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(s.allTasks, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              
              // Filter Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _filterChip(s.filterAll, TaskFilter.all),
                    const SizedBox(width: 8),
                    _filterChip(s.filterDone, TaskFilter.done),
                    const SizedBox(width: 8),
                    _filterChip(s.filterPending, TaskFilter.pending),
                    const SizedBox(width: 8),
                    _filterChip(s.filterMissed, TaskFilter.missed),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              if (filteredTasks.isEmpty)
                Expanded(
                  child: Center(
                    child: Text(s.noTasksYet, style: const TextStyle(color: Colors.grey, fontSize: 16)),
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredTasks.length,
                    itemBuilder: (context, index) {
                      final task = filteredTasks[index];
                      final missed = _isMissed(task);
                      
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: missed ? Colors.red.withValues(alpha: 0.3) : Colors.transparent,
                            width: 1,
                          ),
                        ),
                        child: ListTile(
                          onTap: () => showTaskDetail(context, task),
                          leading: Checkbox(
                            value: task.isCompleted,
                            onChanged: (_) {
                              final wasIncomplete = !task.isCompleted;
                              taskProvider.toggleTaskCompletion(task.id).then((_) {
                                if (wasIncomplete && context.mounted) {
                                  showCompletionCelebration(context);
                                }
                              });
                            },
                          ),
                          title: Text(
                            task.title,
                            style: TextStyle(
                              decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                              fontWeight: FontWeight.w600,
                              color: missed ? Colors.red.shade700 : null,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (task.description.isNotEmpty) 
                                Text(task.description, maxLines: 1, overflow: TextOverflow.ellipsis),
                              Row(
                                children: [
                                  if (task.category != null)
                                    Padding(
                                      padding: const EdgeInsets.only(right: 8.0),
                                      child: Text(task.category!, style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.primary)),
                                    ),
                                  Text(
                                    '${task.date.day}/${task.date.month}',
                                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                                  ),
                                  if (task.time != null) ...[
                                    const SizedBox(width: 6),
                                    Text(
                                      '${task.time!.hour.toString().padLeft(2, '0')}:${task.time!.minute.toString().padLeft(2, '0')}',
                                      style: TextStyle(fontSize: 12, color: missed ? Colors.red : Colors.grey),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.grey, size: 20),
                            onPressed: () => taskProvider.deleteTask(task.id),
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _filterChip(String label, TaskFilter filter) {
    final isSelected = _currentFilter == filter;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (val) {
        if (val) setState(() => _currentFilter = filter);
      },
    );
  }
}
