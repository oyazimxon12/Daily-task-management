import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../l10n/app_strings.dart';

Future<void> showTaskDetail(BuildContext context, Task task) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => _TaskDetailSheet(task: task),
  );
}

class _TaskDetailSheet extends StatefulWidget {
  final Task task;
  const _TaskDetailSheet({required this.task});

  @override
  State<_TaskDetailSheet> createState() => _TaskDetailSheetState();
}

class _TaskDetailSheetState extends State<_TaskDetailSheet> {
  Uint8List? _photoBytes;

  @override
  void initState() {
    super.initState();
    _loadPhoto();
  }

  Future<void> _loadPhoto() async {
    final prefs = await SharedPreferences.getInstance();
    final b64 = prefs.getString('photo_${widget.task.id}');
    if (b64 != null && mounted) {
      setState(() => _photoBytes = base64Decode(b64));
    }
  }

  @override
  Widget build(BuildContext context) {
    final task = widget.task;
    final s = AppStrings.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final maxHeight = MediaQuery.of(context).size.height * 0.85;

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Title
              Row(
                children: [
                  Expanded(
                    child: Text(
                      task.title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                      ),
                    ),
                  ),
                  if (task.isCompleted)
                    const Icon(Icons.check_circle, color: Colors.green, size: 24),
                ],
              ),
              const SizedBox(height: 12),

              // Status + Category chips
              Wrap(
                spacing: 8,
                children: [
                  if (task.category != null)
                    Chip(
                      label: Text(task.category!, style: const TextStyle(fontSize: 12)),
                      backgroundColor: colorScheme.primaryContainer,
                      visualDensity: VisualDensity.compact,
                    ),
                  Chip(
                    label: Text(
                      task.isCompleted ? s.completed : s.pending,
                      style: const TextStyle(fontSize: 12),
                    ),
                    backgroundColor: task.isCompleted
                        ? Colors.green.withValues(alpha: 0.2)
                        : Colors.orange.withValues(alpha: 0.2),
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Date and time
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                  const SizedBox(width: 6),
                  Text(
                    '${task.date.day}/${task.date.month}/${task.date.year}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  if (task.time != null) ...[
                    const SizedBox(width: 16),
                    const Icon(Icons.access_time, size: 16, color: Colors.grey),
                    const SizedBox(width: 6),
                    Text(
                      '${task.time!.hour.toString().padLeft(2, '0')}:${task.time!.minute.toString().padLeft(2, '0')}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ],
              ),

              // Description
              if (task.description.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(s.description, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                const SizedBox(height: 6),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(task.description, style: const TextStyle(fontSize: 14)),
                ),
              ],

              // Photo proof - Adjusted size
              if (_photoBytes != null) ...[
                const SizedBox(height: 16),
                Text(s.proofAdded, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                const SizedBox(height: 8),
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 200), // Limit height
                      child: Image.memory(
                        _photoBytes!,
                        fit: BoxFit.contain, // Contain to show full image without cropping too much
                      ),
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 24),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        context.read<TaskProvider>().toggleTaskCompletion(task.id);
                        Navigator.pop(context);
                      },
                      icon: Icon(task.isCompleted ? Icons.refresh : Icons.check_circle_outline),
                      label: Text(task.isCompleted ? s.pending : s.completed),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () async {
                        await context.read<TaskProvider>().deleteTask(task.id);
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.remove('photo_${task.id}');
                        if (context.mounted) Navigator.pop(context);
                      },
                      icon: const Icon(Icons.delete_outline),
                      label: const Text("O'chirish"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
