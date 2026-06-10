# Changelog

## 1.0.0

- Initial stable release of **QuickAlerts**.
- Added standard in-app alert dialogs for:
  - `QuickAlertType.success`
  - `QuickAlertType.failure`
  - `QuickAlertType.warning`
- Implemented **Top-End Floating Notifications** (`QuickAlertLayout.notification`):
  - Entrance slide-down with custom bounce easing animation.
  - Swipe-up vertical dismissals (`DismissDirection.up`).
  - Native themes and layout alignments.
- Added premium customizable styling options:
  - `fullWidth`: Stretch notification banner end-to-end.
  - `flushToTop`: Align the notification card at the top boundary, auto-padded for safe notches.
- Added custom exit transition properties:
  - `incomingFromTop` (defaults to true; slide in from top or side).
  - `disappearToTop` (defaults to true; slide out to top or side).
- Enforced auto-dismiss defaults (3 seconds for notifications) with manual timing adjustment controls.
