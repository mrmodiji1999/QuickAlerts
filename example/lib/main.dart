import 'package:flutter/material.dart';
import 'package:quick_alerts/quick_alerts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QuickAlerts Demo',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
          brightness: Brightness.dark,
        ),
      ),
      home: MyHomePage(
        themeMode: _themeMode,
        onThemeToggle: _toggleTheme,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final ThemeMode themeMode;
  final VoidCallback onThemeToggle;

  const MyHomePage({
    super.key,
    required this.themeMode,
    required this.onThemeToggle,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _subtitleController = TextEditingController();
  QuickAlertType _selectedType = QuickAlertType.success;
  QuickAlertLayout _selectedLayout = QuickAlertLayout.dialog;
  bool _autoClose = false;
  int _autoCloseSeconds = 5;
  bool _incomingFromTop = true;
  bool _disappearToTop = true;
  bool _fullWidth = false;
  bool _flushToTop = false;

  @override
  void initState() {
    super.initState();
    _resetToDefaults();
  }

  void _resetToDefaults() {
    setState(() {
      _titleController.text = _getDefaultTitle(_selectedType);
      _subtitleController.text = _getDefaultSubtitle(_selectedType);
    });
  }

  String _getDefaultTitle(QuickAlertType type) {
    switch (type) {
      case QuickAlertType.success:
        return 'Payment Successful';
      case QuickAlertType.failure:
        return 'Upload Failed';
      case QuickAlertType.warning:
        return 'Discard Changes?';
    }
  }

  String _getDefaultSubtitle(QuickAlertType type) {
    switch (type) {
      case QuickAlertType.success:
        return 'Your transaction has been completed successfully. A receipt has been sent to your email address.';
      case QuickAlertType.failure:
        return 'Failed to upload the file to the server. Please check your internet connection and try again.';
      case QuickAlertType.warning:
        return 'You have unsaved changes. Are you sure you want to discard them? This action cannot be undone.';
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    super.dispose();
  }

  void _showAlert() {
    QuickAlert.show(
      context: context,
      type: _selectedType,
      title: _titleController.text.trim().isEmpty ? null : _titleController.text.trim(),
      text: _subtitleController.text.trim().isEmpty ? null : _subtitleController.text.trim(),
      confirmBtnText: 'Okay',
      autoClose: _autoClose,
      autoCloseDuration: Duration(seconds: _autoCloseSeconds),
      layout: _selectedLayout,
      incomingFromTop: _incomingFromTop,
      disappearToTop: _disappearToTop,
      fullWidth: _fullWidth,
      flushToTop: _flushToTop,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Theme adaptive color system
    final scaffoldBgColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final cardBgColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final primaryTextColor = isDark ? Colors.white : const Color(0xFF1E293B);
    final secondaryTextColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final inputBorderColor = isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1);

    return Scaffold(
      backgroundColor: scaffoldBgColor,
      appBar: AppBar(
        title: const Text(
          'QuickAlerts Playground',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              widget.themeMode == ThemeMode.light ? Icons.dark_mode : Icons.light_mode,
              color: Colors.white,
            ),
            onPressed: widget.onThemeToggle,
            tooltip: 'Toggle Theme Mode',
          ),
        ],
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header description card
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
                        : [const Color(0xFFEEF2F6), const Color(0xFFE2E8F0)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: inputBorderColor.withAlpha(128)),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      '⚡ Premium In-App Alert System',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: primaryTextColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Customize and preview alerts with rich styles, transitions, and matching default colors.',
                      style: TextStyle(
                        fontSize: 13,
                        color: secondaryTextColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Configuration Form Card
              Card(
                elevation: 4,
                shadowColor: Colors.black.withAlpha(20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                color: cardBgColor,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Configure Alert',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: primaryTextColor,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Alert Type Selection
                      Text(
                        'ALERT TYPE',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: secondaryTextColor,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SegmentedButton<QuickAlertType>(
                        segments: const <ButtonSegment<QuickAlertType>>[
                          ButtonSegment<QuickAlertType>(
                            value: QuickAlertType.success,
                            label: Text('Success'),
                            icon: Icon(Icons.check_circle_outline, size: 18),
                          ),
                          ButtonSegment<QuickAlertType>(
                            value: QuickAlertType.failure,
                            label: Text('Failure'),
                            icon: Icon(Icons.error_outline, size: 18),
                          ),
                          ButtonSegment<QuickAlertType>(
                            value: QuickAlertType.warning,
                            label: Text('Warning'),
                            icon: Icon(Icons.warning_amber_rounded, size: 18),
                          ),
                        ],
                        selected: <QuickAlertType>{_selectedType},
                        onSelectionChanged: (Set<QuickAlertType> newSelection) {
                          setState(() {
                            _selectedType = newSelection.first;
                            _resetToDefaults();
                          });
                        },
                      ),
                      const SizedBox(height: 20),

                      // Alert Layout Selection
                      Text(
                        'ALERT LAYOUT',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: secondaryTextColor,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SegmentedButton<QuickAlertLayout>(
                        segments: const <ButtonSegment<QuickAlertLayout>>[
                          ButtonSegment<QuickAlertLayout>(
                            value: QuickAlertLayout.dialog,
                            label: Text('Dialog'),
                            icon: Icon(Icons.picture_in_picture_alt, size: 18),
                          ),
                          ButtonSegment<QuickAlertLayout>(
                            value: QuickAlertLayout.notification,
                            label: Text('Notification (Top End)'),
                            icon: Icon(Icons.notification_important_outlined, size: 18),
                          ),
                        ],
                        selected: <QuickAlertLayout>{_selectedLayout},
                        onSelectionChanged: (Set<QuickAlertLayout> newSelection) {
                          setState(() {
                            _selectedLayout = newSelection.first;
                            if (_selectedLayout == QuickAlertLayout.notification) {
                              _autoClose = true;
                              _autoCloseSeconds = 3;
                            } else {
                              _autoClose = false;
                            }
                          });
                        },
                      ),
                      const SizedBox(height: 20),

                      // Title input
                      TextField(
                        controller: _titleController,
                        style: TextStyle(color: primaryTextColor),
                        decoration: InputDecoration(
                          labelText: 'Title (Optional)',
                          labelStyle: TextStyle(color: secondaryTextColor),
                          hintText: 'Enter alert title',
                          hintStyle: TextStyle(color: secondaryTextColor.withAlpha(150)),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: inputBorderColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Subtitle/Body text input
                      TextField(
                        controller: _subtitleController,
                        style: TextStyle(color: primaryTextColor),
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: 'Message (Optional)',
                          labelStyle: TextStyle(color: secondaryTextColor),
                          hintText: 'Enter message text',
                          hintStyle: TextStyle(color: secondaryTextColor.withAlpha(150)),
                          alignLabelWithHint: true,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: inputBorderColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                        ),
                      ),
                      const Divider(height: 32),
                      if (_selectedLayout == QuickAlertLayout.dialog) ...[
                        SwitchListTile(
                          title: Text(
                            'Auto Close Alert',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: primaryTextColor,
                            ),
                          ),
                          subtitle: Text(
                            'Automatically dismiss the alert after a delay',
                            style: TextStyle(fontSize: 12, color: secondaryTextColor),
                          ),
                          value: _autoClose,
                          contentPadding: EdgeInsets.zero,
                          onChanged: (bool value) {
                            setState(() {
                              _autoClose = value;
                            });
                          },
                        ),
                      ],
                      if (_selectedLayout == QuickAlertLayout.notification || _autoClose) ...[
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Text(
                              'Delay:',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: secondaryTextColor,
                              ),
                            ),
                            Expanded(
                              child: Slider(
                                value: _autoCloseSeconds.toDouble(),
                                min: 1,
                                max: 15,
                                divisions: 14,
                                label: '$_autoCloseSeconds sec',
                                onChanged: (double value) {
                                  setState(() {
                                    _autoCloseSeconds = value.round();
                                  });
                                },
                              ),
                            ),
                            Text(
                              '$_autoCloseSeconds sec',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: primaryTextColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                      if (_selectedLayout == QuickAlertLayout.notification) ...[
                        const Divider(height: 32),
                        SwitchListTile(
                          title: Text(
                            'Incoming From Top',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: primaryTextColor,
                            ),
                          ),
                          subtitle: Text(
                            'Slide down from top (True) or slide in from side (False)',
                            style: TextStyle(fontSize: 12, color: secondaryTextColor),
                          ),
                          value: _incomingFromTop,
                          contentPadding: EdgeInsets.zero,
                          onChanged: (bool value) {
                            setState(() {
                              _incomingFromTop = value;
                            });
                          },
                        ),
                        SwitchListTile(
                          title: Text(
                            'Disappear To Top',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: primaryTextColor,
                            ),
                          ),
                          subtitle: Text(
                            'Slide up to top (True) or slide out to side (False)',
                            style: TextStyle(fontSize: 12, color: secondaryTextColor),
                          ),
                          value: _disappearToTop,
                          contentPadding: EdgeInsets.zero,
                          onChanged: (bool value) {
                            setState(() {
                              _disappearToTop = value;
                            });
                          },
                        ),
                        SwitchListTile(
                          title: Text(
                            'Full Width End-to-End',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: primaryTextColor,
                            ),
                          ),
                          subtitle: Text(
                            'Stretch across the entire screen width',
                            style: TextStyle(fontSize: 12, color: secondaryTextColor),
                          ),
                          value: _fullWidth,
                          contentPadding: EdgeInsets.zero,
                          onChanged: (bool value) {
                            setState(() {
                              _fullWidth = value;
                            });
                          },
                        ),
                        SwitchListTile(
                          title: Text(
                            'Flush to Top Bar',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: primaryTextColor,
                            ),
                          ),
                          subtitle: Text(
                            'Position directly at the top of the screen',
                            style: TextStyle(fontSize: 12, color: secondaryTextColor),
                          ),
                          value: _flushToTop,
                          contentPadding: EdgeInsets.zero,
                          onChanged: (bool value) {
                            setState(() {
                              _flushToTop = value;
                            });
                          },
                        ),
                      ],
                      const SizedBox(height: 24),

                      // Trigger Alert Button
                      Container(
                        height: 54,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).primaryColor.withAlpha(77),
                              blurRadius: 12,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: _showAlert,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Show Custom Alert',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // Quick presets section
              Text(
                'Quick Presets',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: primaryTextColor,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _presetCard(
                      title: 'Success',
                      color: const Color(0xFF10B981),
                      icon: Icons.check_circle,
                      isDark: isDark,
                      cardBgColor: cardBgColor,
                      onTap: () {
                        QuickAlert.show(
                          context: context,
                          type: QuickAlertType.success,
                          title: 'Success',
                          text: 'Action completed successfully!',
                          layout: _selectedLayout,
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _presetCard(
                      title: 'Failure',
                      color: const Color(0xFFEF4444),
                      icon: Icons.cancel,
                      isDark: isDark,
                      cardBgColor: cardBgColor,
                      onTap: () {
                        QuickAlert.show(
                          context: context,
                          type: QuickAlertType.failure,
                          title: 'Failed',
                          text: 'Something went wrong. Try again.',
                          layout: _selectedLayout,
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _presetCard(
                      title: 'Warning',
                      color: const Color(0xFFF59E0B),
                      icon: Icons.warning,
                      isDark: isDark,
                      cardBgColor: cardBgColor,
                      onTap: () {
                        QuickAlert.show(
                          context: context,
                          type: QuickAlertType.warning,
                          title: 'Warning',
                          text: 'Please review before proceeding.',
                          layout: _selectedLayout,
                        );
                      },
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

  Widget _presetCard({
    required String title,
    required Color color,
    required IconData icon,
    required bool isDark,
    required Color cardBgColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: cardBgColor,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withAlpha(isDark ? 100 : 51), width: 1.5),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
