import 'package:flutter/material.dart';

/// Define the three different alert types supported by QuickAlerts.
enum QuickAlertType {
  success,
  failure,
  warning,
}

/// Define the layouts supported by QuickAlerts.
enum QuickAlertLayout {
  dialog,
  notification,
}

extension QuickAlertTypeExtension on QuickAlertType {
  Color get defaultColor {
    switch (this) {
      case QuickAlertType.success:
        return const Color(0xFF10B981); // Emerald Green
      case QuickAlertType.failure:
        return const Color(0xFFEF4444); // Coral Red
      case QuickAlertType.warning:
        return const Color(0xFFF59E0B); // Amber Yellow
    }
  }

  IconData get icon {
    switch (this) {
      case QuickAlertType.success:
        return Icons.check;
      case QuickAlertType.failure:
        return Icons.close;
      case QuickAlertType.warning:
        return Icons.warning_amber_rounded;
    }
  }

  String get defaultTitle {
    switch (this) {
      case QuickAlertType.success:
        return 'Success';
      case QuickAlertType.failure:
        return 'Error';
      case QuickAlertType.warning:
        return 'Warning';
    }
  }
}

class QuickAlert {
  static OverlayEntry? _currentNotification;

  /// Displays a highly polished, custom in-app alert dialog or floating top notification.
  ///
  /// - [context]: BuildContext to display the alert.
  /// - [type]: The type of alert (success, failure, warning).
  /// - [title]: Main title text. If null, a default title based on [type] will be used.
  /// - [text]: Optional secondary descriptive subtitle.
  /// - [confirmBtnColor]: Color of the confirm button/icon and overlay/notification theme color.
  /// - [confirmBtnText]: Text for the primary action button. Defaults to 'OK'. (Ignored for notifications)
  /// - [onConfirmBtnTap]: Callback executed when the confirm button is tapped (or notification is tapped/closed).
  /// - [barrierDismissible]: Whether tapping outside closes the dialog. Defaults to true. (Ignored for notifications)
  /// - [barrierColor]: Custom background overlay color. (Ignored for notifications)
  /// - [autoClose]: Automatically dismisses the alert dialog after a set delay.
  /// - [autoCloseDuration]: Timeline duration for auto closing. Defaults to 5 seconds.
  /// - [layout]: The layout style of the alert (dialog or top floating notification). Defaults to `QuickAlertLayout.dialog`.
  static Future<void> show({
    required BuildContext context,
    required QuickAlertType type,
    String? title,
    String? text,
    Color? confirmBtnColor,
    String confirmBtnText = 'OK',
    VoidCallback? onConfirmBtnTap,
    bool barrierDismissible = true,
    Color? barrierColor,
    bool? autoClose,
    Duration? autoCloseDuration,
    QuickAlertLayout layout = QuickAlertLayout.dialog,
    bool incomingFromTop = true,
    bool disappearToTop = true,
    bool fullWidth = false,
    bool flushToTop = false,
  }) {
    final effectiveAutoClose = layout == QuickAlertLayout.notification ? true : (autoClose ?? false);
    final effectiveDuration = autoCloseDuration ??
        (layout == QuickAlertLayout.notification
            ? const Duration(seconds: 3)
            : const Duration(seconds: 5));

    if (layout == QuickAlertLayout.notification) {
      _showNotification(
        context: context,
        type: type,
        title: title,
        text: text,
        confirmBtnColor: confirmBtnColor,
        autoClose: effectiveAutoClose,
        autoCloseDuration: effectiveDuration,
        onConfirmBtnTap: onConfirmBtnTap,
        incomingFromTop: incomingFromTop,
        disappearToTop: disappearToTop,
        fullWidth: fullWidth,
        flushToTop: flushToTop,
      );
      return Future.value();
    }

    return showGeneralDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierLabel: 'QuickAlert',
      barrierColor: barrierColor ?? Colors.black.withAlpha(128),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return const SizedBox.shrink();
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: Tween<double>(begin: 0.8, end: 1.0).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutBack,
            ),
          ),
          child: FadeTransition(
            opacity: animation,
            child: _QuickAlertWidget(
              type: type,
              title: title,
              text: text,
              confirmBtnColor: confirmBtnColor,
              confirmBtnText: confirmBtnText,
              onConfirmBtnTap: onConfirmBtnTap,
              autoClose: effectiveAutoClose,
              autoCloseDuration: effectiveDuration,
            ),
          ),
        );
      },
    );
  }

  static void _showNotification({
    required BuildContext context,
    required QuickAlertType type,
    String? title,
    String? text,
    Color? confirmBtnColor,
    bool autoClose = false,
    Duration autoCloseDuration = const Duration(seconds: 3),
    VoidCallback? onConfirmBtnTap,
    bool incomingFromTop = true,
    bool disappearToTop = true,
    bool fullWidth = false,
    bool flushToTop = false,
  }) {
    dismissNotification();

    if (!context.mounted) return;

    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) {
        return _QuickAlertNotificationWidget(
          type: type,
          title: title,
          text: text,
          confirmBtnColor: confirmBtnColor,
          autoClose: autoClose,
          autoCloseDuration: autoCloseDuration,
          onDismissed: () {
            if (_currentNotification == overlayEntry) {
              overlayEntry.remove();
              _currentNotification = null;
            }
            if (onConfirmBtnTap != null) {
              onConfirmBtnTap();
            }
          },
          incomingFromTop: incomingFromTop,
          disappearToTop: disappearToTop,
          fullWidth: fullWidth,
          flushToTop: flushToTop,
        );
      },
    );

    _currentNotification = overlayEntry;
    overlay.insert(overlayEntry);
  }

  /// Manually dismisses the currently active notification, if any.
  static void dismissNotification() {
    if (_currentNotification != null) {
      try {
        _currentNotification!.remove();
      } catch (_) {
        // Entry may have already been removed
      }
      _currentNotification = null;
    }
  }
}

class _QuickAlertWidget extends StatefulWidget {
  final QuickAlertType type;
  final String? title;
  final String? text;
  final Color? confirmBtnColor;
  final String confirmBtnText;
  final VoidCallback? onConfirmBtnTap;
  final bool autoClose;
  final Duration autoCloseDuration;

  const _QuickAlertWidget({
    required this.type,
    this.title,
    this.text,
    this.confirmBtnColor,
    required this.confirmBtnText,
    this.onConfirmBtnTap,
    this.autoClose = false,
    this.autoCloseDuration = const Duration(seconds: 5),
  });

  @override
  State<_QuickAlertWidget> createState() => _QuickAlertWidgetState();
}

class _QuickAlertWidgetState extends State<_QuickAlertWidget> {
  @override
  void initState() {
    super.initState();
    if (widget.autoClose) {
      Future.delayed(widget.autoCloseDuration, () {
        if (mounted) {
          Navigator.of(context).pop();
          if (widget.onConfirmBtnTap != null) {
            widget.onConfirmBtnTap!();
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultColor = widget.type.defaultColor;
    final themeColor = widget.confirmBtnColor ?? defaultColor;
    final icon = widget.type.icon;

    // Responsive theme-aware design colors
    final cardBgColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final titleTextColor = isDark ? Colors.white : const Color(0xFF1E293B);
    final subtitleTextColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.0),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          // Alert Container Card
          Container(
            width: 320,
            margin: const EdgeInsets.only(top: 40),
            decoration: BoxDecoration(
              color: cardBgColor,
              borderRadius: BorderRadius.circular(24.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(isDark ? 80 : 38),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            padding: const EdgeInsets.only(
              top: 64, // Leaves space for the floating top icon banner
              bottom: 24,
              left: 24,
              right: 24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title
                Text(
                  widget.title ?? widget.type.defaultTitle,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: titleTextColor,
                    letterSpacing: -0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                // Subtitle / Body text
                if (widget.text != null && widget.text!.isNotEmpty) ...[
                  Text(
                    widget.text!,
                    style: TextStyle(
                      fontSize: 15,
                      color: subtitleTextColor,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                ] else
                  const SizedBox(height: 16),
                // Action Button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: themeColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      if (widget.onConfirmBtnTap != null) {
                        widget.onConfirmBtnTap!();
                      }
                    },
                    child: Text(
                      widget.confirmBtnText,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Floating Circular Icon Banner
          Positioned(
            top: 0,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: cardBgColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: themeColor.withAlpha(isDark ? 40 : 64),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Center(
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        themeColor,
                        themeColor.withAlpha(217),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}

class _QuickAlertNotificationWidget extends StatefulWidget {
  final QuickAlertType type;
  final String? title;
  final String? text;
  final Color? confirmBtnColor;
  final bool autoClose;
  final Duration autoCloseDuration;
  final VoidCallback onDismissed;
  final bool incomingFromTop;
  final bool disappearToTop;
  final bool fullWidth;
  final bool flushToTop;

  const _QuickAlertNotificationWidget({
    required this.type,
    this.title,
    this.text,
    this.confirmBtnColor,
    required this.autoClose,
    required this.autoCloseDuration,
    required this.onDismissed,
    required this.incomingFromTop,
    required this.disappearToTop,
    required this.fullWidth,
    required this.flushToTop,
  });

  @override
  State<_QuickAlertNotificationWidget> createState() => _QuickAlertNotificationWidgetState();
}

class _QuickAlertNotificationWidgetState extends State<_QuickAlertNotificationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Tween<Offset> _offsetTween;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _fadeAnimation;
  bool _isDismissing = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _offsetTween = Tween<Offset>(
      begin: widget.incomingFromTop ? const Offset(0, -1.2) : const Offset(1.2, 0),
      end: Offset.zero,
    );

    _offsetAnimation = _offsetTween.animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _controller.forward();

    if (widget.autoClose) {
      Future.delayed(widget.autoCloseDuration, () {
        if (mounted && !_isDismissing) {
          _dismiss();
        }
      });
    }
  }

  void _dismiss() {
    if (_isDismissing) return;
    setState(() {
      _isDismissing = true;
    });
    _offsetTween.begin = widget.disappearToTop ? const Offset(0, -1.2) : const Offset(1.2, 0);
    _controller.reverse().then((_) {
      if (mounted) {
        widget.onDismissed();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultColor = widget.type.defaultColor;
    final themeColor = widget.confirmBtnColor ?? defaultColor;
    final icon = widget.type.icon;

    // Use themeColor as background for a highly premium, colored notification card
    final cardBgColor = themeColor;
    final titleTextColor = Colors.white;
    final subtitleTextColor = Colors.white.withAlpha(204);
    final borderCol = Colors.white.withAlpha(38);

    final safeAreaTop = MediaQuery.of(context).padding.top;
    
    // Top position
    final double positionTop = widget.flushToTop ? 0 : safeAreaTop + 16;
    
    // Horizontal positions
    final double? positionLeft = widget.fullWidth ? 0 : 16;
    final double? positionRight = widget.fullWidth ? 0 : 16;

    // Internal top padding needs to account for safe area if flush to top
    final double paddingTop = widget.flushToTop 
        ? safeAreaTop + 14 
        : 14;

    return Positioned(
      top: positionTop,
      left: positionLeft,
      right: positionRight,
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: widget.fullWidth ? double.infinity : 400,
          ),
          child: Material(
            color: Colors.transparent,
            child: Dismissible(
              key: const Key('quick_alert_notification'),
              direction: DismissDirection.up,
              onDismissed: (_) {
                widget.onDismissed();
              },
              child: SlideTransition(
                position: _offsetAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Container(
                    decoration: BoxDecoration(
                      color: cardBgColor,
                      borderRadius: widget.fullWidth 
                          ? (widget.flushToTop ? BorderRadius.zero : const BorderRadius.vertical(bottom: Radius.circular(16)))
                          : BorderRadius.circular(16),
                      border: widget.fullWidth && widget.flushToTop
                          ? null
                          : Border.all(color: borderCol, width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(80),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.only(
                      top: paddingTop,
                      bottom: 14,
                      left: 16,
                      right: 16,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(51),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Icon(
                              icon,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                widget.title ?? widget.type.defaultTitle,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: titleTextColor,
                                ),
                              ),
                              if (widget.text != null && widget.text!.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(
                                  widget.text!,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: subtitleTextColor,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
