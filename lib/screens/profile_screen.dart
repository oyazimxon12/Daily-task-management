import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/locale_provider.dart';
import '../providers/task_provider.dart';
import '../l10n/app_strings.dart';

const _kPrimary = Color(0xFF4F6EF7);

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s              = AppStrings.of(context);
    final themeProvider  = context.watch<ThemeProvider>();
    final localeProvider = context.watch<LocaleProvider>();
    final taskProvider   = context.watch<TaskProvider>();
    final isDark         = themeProvider.isDark;

    final totalTasks     = taskProvider.tasks.length;
    final completedTasks = taskProvider.getCompletedTasksCount();

    return Scaffold(
      appBar: AppBar(title: Text(s.profile)), // s.profile is now "Settings"
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── Header ────────────────────────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [_kPrimary, Color(0xFF7B8FFF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white.withValues(alpha: 0.4), width: 2),
                    ),
                    child: const Icon(Icons.settings_suggest_rounded, size: 44, color: Colors.white),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    s.appTitle,
                    style: GoogleFonts.syne(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _StatBadge(label: s.allTasks, value: '$totalTasks'),
                      const SizedBox(width: 24),
                      _StatBadge(label: s.completed, value: '$completedTasks'),
                      const SizedBox(width: 24),
                      _StatBadge(label: s.pending, value: '${totalTasks - completedTasks}'),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── Ilova sozlamalari ─────────────────────────────────────────────
            _SectionHeader(title: s.appSettings),
            _SettingsTile(
              icon: isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
              title: isDark ? s.lightMode : s.darkMode,
              trailing: Switch(
                value: themeProvider.isDark,
                onChanged: (_) => themeProvider.toggle(),
                activeThumbColor: _kPrimary,
              ),
            ),
            _SettingsTile(
              icon: Icons.language_rounded,
              title: s.language,
              trailing: _LanguageSelector(localeProvider: localeProvider),
            ),

            const SizedBox(height: 8),

            // ── Qo'shimcha ──────────────────────────────────────────────────
            _SectionHeader(title: s.other),
            _SettingsTile(
              icon: Icons.mosque_outlined,
              title: s.qibla,
              subtitle: s.qiblaDirection,
              onTap: () => Navigator.of(context).pushNamed('/qibla'),
            ),
            _SettingsTile(
              icon: Icons.info_outline_rounded,
              title: s.about,
              subtitle: '1.0.0 · Smart Daily Planner',
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _StatBadge extends StatelessWidget {
  final String label;
  final String value;
  const _StatBadge({required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Text(value, style: GoogleFonts.syne(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white)),
      Text(label, style: TextStyle(fontSize: 10, color: Colors.white.withValues(alpha: 0.75))),
    ],
  );
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
    child: Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.syne(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: _kPrimary,
          letterSpacing: 1.4,
        ),
      ),
    ),
  );
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: cs.primaryContainer,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 20, color: _kPrimary),
      ),
      title: Text(title, style: GoogleFonts.dmSans(fontWeight: FontWeight.w500)),
      subtitle: subtitle != null
          ? Text(subtitle!, style: GoogleFonts.dmSans(fontSize: 12, color: cs.onSurfaceVariant))
          : null,
      trailing: trailing ?? (onTap != null ? const Icon(Icons.chevron_right, color: _kPrimary) : null),
      onTap: onTap,
    );
  }
}

class _LanguageSelector extends StatelessWidget {
  final LocaleProvider localeProvider;
  const _LanguageSelector({required this.localeProvider});

  @override
  Widget build(BuildContext context) {
    final langs = [
      {'code': 'uz', 'label': "O'z"},
      {'code': 'ru', 'label': 'Рус'},
      {'code': 'en', 'label': 'Eng'},
    ];
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: langs.map((lang) {
        final selected = localeProvider.locale == lang['code'];
        return GestureDetector(
          onTap: () => localeProvider.setLocale(lang['code']!),
          child: Container(
            margin: const EdgeInsets.only(left: 4),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: selected ? _kPrimary : Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              lang['label']!,
              style: GoogleFonts.syne(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: selected ? Colors.white : Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
