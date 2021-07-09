import 'package:flutter/material.dart';
import 'package:polkadex/configs/app_config.dart';
import 'package:polkadex/utils/colors.dart';

/// The horizontal progress bar just to display progress
///
/// The widget is used in landing stpes screens
class AppHorizontalProgressBar extends StatefulWidget {
  const AppHorizontalProgressBar({
    Key key,
    @required this.progress,
    this.animation,
    // this.previousProgress = 0.00,
  })  : assert(progress != null, '''
  The progress could not be empty or null
  '''),
        assert(progress >= 0.00 && progress <= 1.00, '''
  progress should be greater than or equal to 0.00
  progress should be less than or equal to 1.00
  '''),
        super(key: key);

  /// The will be percentage to be showed as progress
  ///
  /// [progress] should be greater than or equal to 0.00
  /// [progress] should be less than or equal to 1.00
  final double progress;

  /// The animation to be control the entry
  /// To diable set the animation to null
  final Animation<double> animation;

  /// The previous progress state.
  /// If null then 0.00 will be set
  // final double previousProgress;

  @override
  _AppHorizontalProgressBarState createState() =>
      _AppHorizontalProgressBarState();
}

class _AppHorizontalProgressBarState extends State<AppHorizontalProgressBar>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _progressAnimation;
  double progress;
  double previousProgress = 0.0;

  void _initialiseAnimation() {
    _progressAnimation = Tween<double>(begin: previousProgress, end: progress)
        .animate(CurvedAnimation(
            parent: _animationController, curve: Curves.easeIn));
  }

  @override
  void didUpdateWidget(covariant AppHorizontalProgressBar oldWidget) {
    if (widget.progress != oldWidget.progress) {
      this.previousProgress = oldWidget.progress;
      this.progress = widget.progress;
      Future.microtask(() {
        _initialiseAnimation();
        if (_animationController != null) {
          this._animationController.reset();
          this._animationController.forward().orCancel;
        }
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    this.previousProgress = 0.00;
    this.progress = widget.progress;
    _animationController = AnimationController(
        vsync: this,
        duration: AppConfigs.animDurationSmall,
        reverseDuration: AppConfigs.animDurationSmall);
    _initialiseAnimation();
    Future.microtask(() async {
      await Future.delayed(Duration(
          milliseconds: AppConfigs.animDuration.inMilliseconds ~/ 1.5));
      if (_animationController != null)
        this._animationController.forward().orCancel;
    });
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _animationController = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final child = Container(
          height: 8,
          decoration: BoxDecoration(
            color: color8BA1BE.withOpacity(0.20),
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.centerLeft,
          child: AnimatedBuilder(
            animation: _progressAnimation,
            builder: (context, child) => Container(
              width: constraints.maxWidth * _progressAnimation.value,
              decoration: BoxDecoration(
                color: colorE6007A,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        );
        if (widget.animation == null) {
          return child;
        } else {
          return AnimatedBuilder(
            animation: widget.animation,
            child: child,
            builder: (context, child) => Transform(
              transform: Matrix4.identity()..scale(widget.animation.value, 1.0),
              child: child,
              alignment: Alignment.centerLeft,
            ),
          );
        }
      },
    );
  }
}
