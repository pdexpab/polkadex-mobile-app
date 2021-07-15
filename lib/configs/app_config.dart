import 'dart:ui';

/// The config class for the application
class AppConfigs {
  /// The default animation duration
  static const Duration animDuration = Duration(milliseconds: 600);

  /// The small animation duration, which can be used to expand/hide etc
  static const Duration animDurationSmall = Duration(milliseconds: 300);

  /// The default animation duraiton for reverse
  static const Duration animReverseDuration = Duration(milliseconds: 400);

  /// The app screen size
  static Size? size;
}
