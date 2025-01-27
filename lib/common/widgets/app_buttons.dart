import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:polkadex/common/configs/app_config.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/extensions.dart';
import 'package:polkadex/common/utils/styles.dart';

/// The back button for the App
///
/// The button is used in Terms screen, Account creation screen, etc
///

class AppBackButton extends StatelessWidget {
  const AppBackButton({
    this.onTap,
  });

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: 48,
          height: 48,
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 13),
            child: RotatedBox(
              quarterTurns: 2,
              child: SvgPicture.asset(
                'arrow'.asAssetSvg(),
                fit: BoxFit.contain,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The button widget layout for bottom Yes & No
///
class AppButton extends StatelessWidget {
  AppButton({
    required this.label,
    this.enabled = true,
    this.onTap,
    this.innerPadding =
        const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    this.outerPadding = const EdgeInsets.symmetric(vertical: 14),
    this.backgroundColor = const Color(0xFFE6007A),
    this.textColor = const Color(0xFFFFFFFF),
  });

  final _notifier = ValueNotifier<bool>(false);

  final String label;
  final bool enabled;
  final VoidCallback? onTap;
  final EdgeInsets innerPadding;
  final EdgeInsets outerPadding;
  final Color backgroundColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: outerPadding,
      child: InkWell(
        onTapDown: (_) {
          _notifier.value = true;
        },
        onTap: () {
          _notifier.value = false;
          if (enabled && onTap != null) {
            onTap!();
          }
        },
        onTapCancel: () {
          _notifier.value = false;
        },
        child: IgnorePointer(
          ignoring: true,
          child: ValueListenableBuilder<bool>(
            valueListenable: _notifier,
            builder: (context, isTranslate, child) {
              return AnimatedContainer(
                duration: AppConfigs.animDurationSmall ~/ 2,
                transform: Matrix4.translationValues(
                    0.0, isTranslate ? 10.0 : 0.00, 0.0),
                child: child,
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: enabled
                    ? backgroundColor
                    : AppColors.color8BA1BE.withOpacity(0.20),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: innerPadding,
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: tsS16W400CFF.copyWith(
                      color: enabled ? textColor : AppColors.colorFFFFFF),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
