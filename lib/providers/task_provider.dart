import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/task.dart';
import '../services/notification_service.dart';

class TaskProvider extends ChangeNotifier {
  static const _storageKey = 'tasks_v2';
  final List<Task> _tasks = [];
  DateTime _selectedDate = DateTime.now();
  final _uuid = const Uuid();

  List<Task> get tasks => _tasks;
  DateTime get selectedDate => _selectedDate;

  List<Task> getTasksForDate(DateTime date) {
    return _tasks.where((t) =>
      t.date.year == date.year &&
      t.date.month == date.month &&
      t.date.day == date.day,
    ).toList();
  }

  List<Task> getTodaysTasks() => getTasksForDate(DateTime.now());

  int getCompletedTasksCount() => _tasks.where((t) => t.isCompleted).length;

  Future<String> addTask({
    required String title,
    required String description,
    required DateTime date,
    TaskTime? time,
    String? category,
  }) async {
    final task = Task(
      id: _uuid.v4(),
      title: title,
      description: description,
      date: date,
      time: time,
      category: category,
      isCompleted: false,
    );
    _tasks.add(task);
    await _save();
    notifyListeners();

    if (time != null) {
      final taskDateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
      await NotificationService.scheduleTaskReminder(
        taskId: task.id,
        taskTitle: title,
        taskDateTime: taskDateTime,
      );
    }

    return task.id;
  }

  Future<void> deleteTask(String taskId) async {
    await NotificationService.cancelTaskReminder(taskId);
    _tasks.removeWhere((t) => t.id == taskId);
    await _save();
    notifyListeners();
  }

  Future<void> toggleTaskCompletion(String taskId) async {
    final i = _tasks.indexWhere((t) => t.id == taskId);
    if (i != -1) {
      _tasks[i].isCompleted = !_tasks[i].isCompleted;
      await _save();
      notifyListeners();
    }
  }

  Future<void> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw == null) return;
    try {
      final list = jsonDecode(raw) as List;
      _tasks.clear();
      _tasks.addAll(list.map((j) => Task.fromJson(j as Map<String, dynamic>)));
      notifyListeners();
    } catch (_) {}
  }

  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  void clear() {
    _tasks.clear();
    notifyListeners();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, jsonEncode(_tasks.map((t) => t.toJson()).toList()));
  }
}
