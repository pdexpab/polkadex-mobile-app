import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:polkadex/common/configs/app_config.dart';
import 'package:polkadex/common/navigation/coordinator.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/extensions.dart';
import 'package:polkadex/common/utils/styles.dart';
import 'package:polkadex/common/widgets/app_slider_dots.dart';
import 'package:polkadex/common/utils/responsive_utils.dart';
import 'package:polkadex/features/setup/presentation/widgets/login_button_widget.dart';
import 'package:polkadex/features/setup/presentation/widgets/select_language_widget.dart';

/// The dummy data for the screen
///
/// Delete the class on API integration
class _DummyData {
  static final sliderList = List.generate(
    3,
    (index) =>
        "A fully decentralized, peer-peer, orderbook based cryptocurrency exchange",
  );

  static final sliderImgList = <String>[
    'slider_img_1.png'.asAssetImg(),
    'slider_img_2.png'.asAssetImg(),
    'slider_img_3.png'.asAssetImg(),
  ];
}

/// This screen will be displayed on the first app opened.
///
/// In XD page 2 - Start Screen
/// XD_PAGE: 2
///

class IntroScreen extends StatefulWidget {
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen>
    with SingleTickerProviderStateMixin {
  final _keyPageView = GlobalKey<__ThisPageViewState>();

  late ValueNotifier<int> _pageviewIndexNotifier;

  @override
  void initState() {
    _pageviewIndexNotifier = ValueNotifier<int>(0);
    super.initState();
  }

  @override
  void dispose() {
    _pageviewIndexNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.color1C2023,
      body: Stack(
        children: [
          Positioned.fill(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _ThisPageView(
                      key: _keyPageView,
                      length: _DummyData.sliderList.length,
                      pageviewIndexNotifier: _pageviewIndexNotifier),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 24, right: 24, top: 30, bottom: 30),
                  child: ValueListenableBuilder<int>(
                    valueListenable: _pageviewIndexNotifier,
                    builder: (context, pageIndex, child) => AppSliderDots(
                      length: _DummyData.sliderList.length,
                      selectedIndex: pageIndex,
                      onDotSelected: (dotSelectedIndex) {
                        _keyPageView.currentState?.animateTo(dotSelectedIndex);
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                  child: SizedBox(
                    height: 54,
                    child: LoginButtonWidget(
                      text: 'Create a new account',
                      backgroundColor: AppColors.colorE6007A,
                      textStyle: tsS16W500CFF,
                      onTap: () => Coordinator.goToSignUpScreen(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: SizedBox(
                    height: 54,
                    child: LoginButtonWidget(
                      text: 'I alredy have an account',
                      backgroundColor: AppColors.colorFFFFFF,
                      textStyle: tsS16W500C24252C,
                      onTap: () => Coordinator.goToSignInScreen(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 24.0,
                    right: 24,
                    top: 22,
                    bottom: 24,
                  ),
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                            style: tsS13W400CABB2BC,
                            text:
                                'By continuing, I allow Polkadex App to collect data on how I use the app, which will be used to improve the Polkadex App. For more details. refer to our '),
                        TextSpan(
                          style: tsS13W400CABB2BC.copyWith(
                            decoration: TextDecoration.underline,
                            color: AppColors.colorE6007A,
                          ),
                          text: 'Privacy Policy',
                          recognizer: TapGestureRecognizer()
                            ..onTap =
                                () => Coordinator.goToPrivacyPolicyScreen(),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          ),
          // The polkadex logo
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(
                left: 26,
                top: 36 + MediaQuery.of(context).padding.top,
                right: 26,
              ),
              child: Container(
                height: 36,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      'logo_name.png'.asAssetImg(),
                      fit: BoxFit.contain,
                    ),
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.color8BA1BE.withOpacity(0.20),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: GestureDetector(
                            onTapDown: (_) => showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(30),
                                ),
                              ),
                              builder: (_) => SelectLanguageWidget(),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 10,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    LocaleNames.of(context)!.nameOf(
                                        Localizations.localeOf(context)
                                            .languageCode)!,
                                    style: tsS16W600CFF,
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  RotatedBox(
                                    quarterTurns: 1,
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      color: AppColors.colorFFFFFF,
                                      size: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ThisPageView extends StatefulWidget {
  const _ThisPageView({
    required Key key,
    required this.length,
    required ValueNotifier<int> pageviewIndexNotifier,
  })  : _pageviewIndexNotifier = pageviewIndexNotifier,
        super(key: key);

  final ValueNotifier<int> _pageviewIndexNotifier;
  final int length;

  @override
  __ThisPageViewState createState() => __ThisPageViewState();
}

class __ThisPageViewState extends State<_ThisPageView> {
  late ValueNotifier<double> _pageNotifier;
  late PageController _pageController;
  late Timer _timer;

  void _initialiseTimer() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_pageController.page! < widget.length - 1) {
        _pageController.nextPage(
          duration: AppConfigs.animDuration,
          curve: Curves.ease,
        );
      } else {
        _pageController.animateToPage(
          0,
          duration: AppConfigs.animDuration,
          curve: Curves.ease,
        );
      }
    });
  }

  void animateTo(int index) {
    _pageController.animateToPage(
      index,
      duration: AppConfigs.animDuration,
      curve: Curves.ease,
    );
  }

  @override
  void initState() {
    _pageNotifier = ValueNotifier<double>(0.0);
    _pageController = PageController()
      ..addListener(() {
        _pageNotifier.value = _pageController.page!;
      });

    _initialiseTimer();

    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    _pageNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme:
            ColorScheme.fromSwatch().copyWith(secondary: Colors.transparent),
      ),
      child: PageView.builder(
        pageSnapping: true,
        controller: _pageController,
        itemBuilder: (context, index) {
          return Stack(
            children: [
              ValueListenableBuilder<double>(
                valueListenable: _pageNotifier,
                builder: (context, page, child) {
                  final size = Size(392.7272, 759.2727);
                  final double scaleConst =
                      (1.7 / size.height) * MediaQuery.of(context).size.height;
                  final double offsetX =
                      (100 / size.width) * MediaQuery.of(context).size.width;
                  final double translateOffsetX =
                      (250 / size.width) * MediaQuery.of(context).size.width;
                  final double translateOffsetY =
                      (190 / size.height) * MediaQuery.of(context).size.height;

                  double value = (index - page);
                  double translateX = 0.0;
                  double scale = 1.0;

                  if (value > 0.0) {
                    value = page - index;

                    scale = (1 - value.abs()).abs() * scaleConst;
                  } else {
                    value = 1.0;
                    scale = scaleConst;
                    translateX = (page - index).abs();
                  }

                  return Align(
                    alignment: Alignment(0.0, 0.5),
                    child: Transform(
                        transform: Matrix4.translationValues(
                            -offsetX + (-translateOffsetX * translateX),
                            -translateOffsetY - (100 * (scaleConst - scale)),
                            0.0)
                          ..scale(scale, scale),
                        child: child),
                  );
                },
                child: Image.asset(
                  _DummyData.sliderImgList[index],
                  fit: BoxFit.contain,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      _DummyData.sliderList[index],
                      style: tsS32W600CFF.copyWith(fontSize: 32.sp),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(
                        _DummyData.sliderList[index],
                        style: tsS18W400CFF.copyWith(fontSize: 18.sp),
                      ),
                    )
                  ],
                ),
              ),
            ],
          );
        },
        itemCount: _DummyData.sliderList.length,
        onPageChanged: (index) {
          widget._pageviewIndexNotifier.value = index;
        },
      ),
    );
  }
}
