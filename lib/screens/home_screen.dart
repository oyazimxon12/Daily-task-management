import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/task_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/locale_provider.dart';
import '../providers/weather_provider.dart';
import '../l10n/app_strings.dart';
import '../models/task.dart' hide TimeOfDay;
import '../widgets/task_detail_sheet.dart';
import '../widgets/completion_celebration.dart';
import 'calendar_screen.dart';
import 'tasks_list_screen.dart';
import 'ai_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskProvider>().loadTasks().catchError((_) {});
      context.read<WeatherProvider>().load();
    });
  }

  void _showLanguageMenu() {
    final localeProvider = context.read<LocaleProvider>();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.withOpacity(0.3), borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 20),
              ...[
                {'code': 'uz', 'label': "O'zbekcha", 'flag': '🇺🇿'},
                {'code': 'ru', 'label': 'Русский', 'flag': '🇷🇺'},
                {'code': 'en', 'label': 'English', 'flag': '🇬🇧'},
              ].map((lang) {
                final selected = localeProvider.locale == lang['code'];
                return ListTile(
                  leading: Text(lang['flag']!, style: const TextStyle(fontSize: 24)),
                  title: Text(lang['label']!, style: GoogleFonts.dmSans(fontWeight: selected ? FontWeight.bold : FontWeight.normal)),
                  trailing: selected ? Icon(Icons.check_circle, color: Theme.of(context).colorScheme.primary) : null,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  onTap: () { localeProvider.setLocale(lang['code']!); Navigator.pop(context); },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    final themeProvider = context.watch<ThemeProvider>();

    final screens = [
      const _DashboardScreen(),
      const TasksListScreen(),
      const CalendarScreen(),
      const AiScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      extendBody: true,
      appBar: _selectedIndex < 3
          ? AppBar(
              title: Text(s.appTitle, style: GoogleFonts.syne(fontWeight: FontWeight.w800)),
              actions: [
                IconButton(
                  icon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Icon(themeProvider.isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded, key: ValueKey(themeProvider.isDark)),
                  ),
                  onPressed: () => context.read<ThemeProvider>().toggle(),
                ),
                IconButton(icon: const Icon(Icons.language_rounded), onPressed: _showLanguageMenu),
              ],
            )
          : null,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        child: screens[_selectedIndex],
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 5)),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: NavigationBar(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (i) => setState(() => _selectedIndex = i),
            elevation: 0,
            destinations: [
              NavigationDestination(icon: const Icon(Icons.grid_view_rounded), label: s.navHome),
              NavigationDestination(icon: const Icon(Icons.task_alt_rounded), label: s.navTasks),
              NavigationDestination(icon: const Icon(Icons.calendar_today_rounded), label: s.navCalendar),
              NavigationDestination(icon: const Icon(Icons.auto_awesome_rounded), label: s.navAi),
              NavigationDestination(icon: const Icon(Icons.settings_rounded), label: s.navProfile),
            ],
          ),
        ),
      ),
      floatingActionButton: (_selectedIndex < 3)
          ? FloatingActionButton.extended(
              onPressed: () => showDialog(context: context, builder: (_) => _AddTaskDialog()),
              label: Text(s.add, style: GoogleFonts.syne(fontWeight: FontWeight.bold)),
              icon: const Icon(Icons.add_rounded),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            )
          : null,
    );
  }
}

class _DashboardScreen extends StatelessWidget {
  const _DashboardScreen();

  String _greeting(AppStrings s) {
    final h = DateTime.now().hour;
    if (h < 12) return s.goodMorning;
    if (h < 18) return s.goodAfternoon;
    return s.goodEvening;
  }

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    final theme = Theme.of(context);

    return Consumer<TaskProvider>(
      builder: (context, tp, _) {
        final todayTasks = tp.getTodaysTasks();
        final completedToday = todayTasks.where((t) => t.isCompleted).length;
        final progress = todayTasks.isEmpty ? 0.0 : completedToday / todayTasks.length;

        return RefreshIndicator(
          onRefresh: () async {
            await context.read<TaskProvider>().loadTasks();
            await context.read<WeatherProvider>().load();
          },
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
            children: [
              Text(_greeting(s), style: GoogleFonts.dmSans(fontSize: 14, color: theme.colorScheme.onSurface.withOpacity(0.6))),
              Text(s.welcomeBack, style: GoogleFonts.syne(fontSize: 28, fontWeight: FontWeight.w800)),
              const SizedBox(height: 24),

              // Glass Stats
              Row(
                children: [
                  _StatCard(label: s.todaysTasks, value: '${todayTasks.length}', color: theme.colorScheme.primary),
                  const SizedBox(width: 12),
                  _StatCard(label: s.completed, value: '$completedToday', color: Colors.green),
                ],
              ),
              const SizedBox(height: 16),

              _ProgressCard(progress: progress, s: s),
              const SizedBox(height: 16),

              const _WeatherCard(),
              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(s.todaysTasks, style: GoogleFonts.syne(fontSize: 18, fontWeight: FontWeight.bold)),
                  TextButton(onPressed: () {}, child: Text(s.seeAll)),
                ],
              ),
              const SizedBox(height: 12),
              if (todayTasks.isEmpty)
                _EmptyCard(text: s.noTasksToday)
              else
                ...todayTasks.map((task) => _TaskTile(task: task)),

              const SizedBox(height: 24),
              Text(s.aiSuggestions, style: GoogleFonts.syne(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              _AiSuggestionsCard(tasks: todayTasks, s: s),
            ],
          ),
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label, value;
  final Color color;
  const _StatCard({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value, style: GoogleFonts.syne(fontSize: 32, fontWeight: FontWeight.w800, color: color)),
            Text(label, style: GoogleFonts.dmSans(fontSize: 13, fontWeight: FontWeight.w500, color: color.withOpacity(0.8))),
          ],
        ),
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  final double progress;
  final AppStrings s;
  const _ProgressCard({required this.progress, required this.s});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor.withOpacity(0.6),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.dividerColor.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(s.dailyProgress, style: GoogleFonts.syne(fontWeight: FontWeight.bold)),
              Text('${(progress * 100).toInt()}%', style: GoogleFonts.syne(fontWeight: FontWeight.w800, color: theme.colorScheme.primary)),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 12,
              backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(progress == 1.0 ? Colors.green : theme.colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }
}

class _WeatherCard extends StatelessWidget {
  const _WeatherCard();

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    final theme = Theme.of(context);
    return Consumer<WeatherProvider>(
      builder: (ctx, wp, _) {
        if (wp.loading) return const SizedBox.shrink();
        final w = wp.weather;
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [theme.colorScheme.primary.withOpacity(0.8), theme.colorScheme.primary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [BoxShadow(color: theme.colorScheme.primary.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 5))],
          ),
          child: Row(
            children: [
              Text(w?.icon ?? '☀️', style: const TextStyle(fontSize: 40)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(w?.city ?? 'Tashkent', style: GoogleFonts.syne(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                    Text('${w?.temp.toInt() ?? 25}°C • ${w?.condition ?? 'Sunny'}', style: GoogleFonts.dmSans(color: Colors.white.withOpacity(0.9))),
                  ],
                ),
              ),
              const Icon(Icons.cloud_queue_rounded, color: Colors.white, size: 30),
            ],
          ),
        );
      },
    );
  }
}

class _TaskTile extends StatelessWidget {
  final Task task;
  const _TaskTile({required this.task});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.dividerColor.withOpacity(0.5)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        onTap: () => showTaskDetail(context, task),
        leading: Transform.scale(
          scale: 1.2,
          child: Checkbox(
            value: task.isCompleted,
            shape: const CircleBorder(),
            onChanged: (v) {
              final wasIncomplete = !task.isCompleted;
              context.read<TaskProvider>().toggleTaskCompletion(task.id).then((_) {
                if (wasIncomplete && context.mounted) showCompletionCelebration(context);
              });
            },
          ),
        ),
        title: Text(task.title, style: GoogleFonts.dmSans(fontWeight: FontWeight.w600, decoration: task.isCompleted ? TextDecoration.lineThrough : null)),
        subtitle: task.time != null ? Text('${task.time!.hour.toString().padLeft(2,'0')}:${task.time!.minute.toString().padLeft(2,'0')}', style: GoogleFonts.dmSans(fontSize: 12)) : null,
        trailing: const Icon(Icons.chevron_right_rounded, color: Colors.grey),
      ),
    );
  }
}

class _EmptyCard extends StatelessWidget {
  final String text;
  const _EmptyCard({required this.text});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(40),
    decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(24), border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.3))),
    child: Center(child: Text(text, style: GoogleFonts.dmSans(color: Colors.grey), textAlign: TextAlign.center)),
  );
}

class _AiSuggestionsCard extends StatelessWidget {
  final List tasks;
  final AppStrings s;
  const _AiSuggestionsCard({required this.tasks, required this.s});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.colorScheme.secondary.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome, color: Colors.amber, size: 20),
              const SizedBox(width: 8),
              Text('Smart Tips', style: GoogleFonts.syne(fontWeight: FontWeight.bold, color: theme.colorScheme.secondary)),
            ],
          ),
          const SizedBox(height: 12),
          Text(tasks.isEmpty ? s.noSuggestions : 'Focus on your priority tasks today!', style: GoogleFonts.dmSans(fontSize: 14)),
        ],
      ),
    );
  }
}

class _AddTaskDialog extends StatefulWidget {
  @override
  State<_AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<_AddTaskDialog> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  String? _selectedCategory;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay? _selectedTime;
  XFile? _proofImage;
  final _speech = stt.SpeechToText();
  bool _isListening = false;

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    final theme = Theme.of(context);
    return Dialog(
      backgroundColor: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(s.addTask, style: GoogleFonts.syne(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: s.taskTitle,
                prefixIcon: const Icon(Icons.title_rounded),
                suffixIcon: IconButton(icon: Icon(_isListening ? Icons.mic : Icons.mic_none_rounded, color: _isListening ? Colors.red : null), onPressed: _toggleListening),
              ),
            ),
            const SizedBox(height: 12),
            TextField(controller: _descController, decoration: InputDecoration(hintText: s.description, prefixIcon: const Icon(Icons.notes_rounded)), maxLines: 2),
            const SizedBox(height: 12),
            _buildPicker(Icons.calendar_today_rounded, '${_selectedDate.day}/${_selectedDate.month}', _pickDate),
            const SizedBox(height: 12),
            _buildPicker(Icons.access_time_rounded, _selectedTime?.format(context) ?? s.selectTime, _pickTime),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(child: OutlinedButton(onPressed: () => Navigator.pop(context), child: Text(s.cancel))),
                const SizedBox(width: 12),
                Expanded(child: ElevatedButton(onPressed: _submit, child: Text(s.add))),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPicker(IconData icon, String text, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(color: Theme.of(context).dividerColor.withOpacity(0.05), borderRadius: BorderRadius.circular(16), border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.2))),
        child: Row(children: [Icon(icon, size: 20, color: Colors.grey), const SizedBox(width: 12), Text(text, style: GoogleFonts.dmSans())]),
      ),
    );
  }

  void _toggleListening() async {
    if (_isListening) { await _speech.stop(); setState(() => _isListening = false); }
    else {
      bool available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(onResult: (r) => setState(() => _titleController.text = r.recognizedWords));
      }
    }
  }

  void _pickDate() async {
    final d = await showDatePicker(context: context, initialDate: _selectedDate, firstDate: DateTime.now(), lastDate: DateTime(2100));
    if (d != null) setState(() => _selectedDate = d);
  }

  void _pickTime() async {
    final t = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (t != null) setState(() => _selectedTime = t);
  }

  void _submit() async {
    if (_titleController.text.isEmpty) return;
    final tp = context.read<TaskProvider>();
    await tp.addTask(
      title: _titleController.text,
      description: _descController.text,
      date: _selectedDate,
      time: _selectedTime != null ? TaskTime(hour: _selectedTime!.hour, minute: _selectedTime!.minute) : null,
    );
    if (mounted) Navigator.pop(context);
  }
}
