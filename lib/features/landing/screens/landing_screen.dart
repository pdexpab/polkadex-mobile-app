import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:polkadex/common/configs/app_config.dart';
import 'package:polkadex/features/landing/providers/home_scroll_notif_provider.dart';
import 'package:polkadex/features/landing/providers/notification_drawer_provider.dart';
import 'package:polkadex/features/landing/screens/market_token_selection_screen.dart';
import 'package:polkadex/features/landing/sub_views/balance_tab_view.dart';
import 'package:polkadex/features/landing/sub_views/exchange_tab_view.dart';
import 'package:polkadex/features/landing/sub_views/home_tab_view.dart';
import 'package:polkadex/features/landing/sub_views/trade_tab_view.dart';
import 'package:polkadex/features/landing/widgets/app_bottom_navigation_bar.dart';
import 'package:polkadex/features/landing/widgets/app_drawer_widget.dart';
import 'package:polkadex/common/providers/bottom_navigation_provider.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/common/utils/extensions.dart';
import 'package:polkadex/common/utils/styles.dart';
import 'package:provider/provider.dart';

/// XD_PAGE: 34
class LandingScreen extends StatefulWidget {
  static const String routeName = '/landing_screen';
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen>
    with TickerProviderStateMixin {
  // AnimationController _entryAnimationController;
  // Animation<Offset> _offsetBottomTopAnimation;
  // Animation<double> _appbarAnimation;
  AnimationController _drawerAnimationController;
  AnimationController _drawerNotifAnimController;
  AnimationController _contentAnimController;

  Animation<double> _leftDrawerWidthAnimation;
  Animation<double> _rightDrawerWidthAnimation;
  Animation<Color> _drawerContentColorAnimation;
  Animation<BorderRadius> _drawerContentRadiusAnimation;

  bool _isDrawerVisible = false;
  bool _isNotifDrawerVisible = false;
  double _dragStartDX = 0.0;

  ValueNotifier<String> _titleNotifier;

  @override
  void initState() {
    _titleNotifier = ValueNotifier<String>("Hello Kas");
    _drawerAnimationController = AnimationController(
      vsync: this,
      duration: AppConfigs.animDurationSmall,
      reverseDuration: AppConfigs.animDurationSmall,
    );

    _drawerNotifAnimController = AnimationController(
      vsync: this,
      duration: AppConfigs.animDurationSmall,
      reverseDuration: AppConfigs.animDurationSmall,
    );

    _contentAnimController = AnimationController(
      vsync: this,
      duration: AppConfigs.animDurationSmall,
      reverseDuration: AppConfigs.animDurationSmall,
    );

    // Future.microtask(() => _initAnimations());
    _initAnimations();

    // _entryAnimationController = AnimationController(
    //     vsync: this,
    //     duration: AppConfigs.animDuration,
    //     reverseDuration: AppConfigs.animReverseDuration);
    // _initAnimations();

    super.initState();
    // Future.microtask(() => _entryAnimationController.forward().orCancel);
  }

  @override
  void dispose() {
    // _entryAnimationController.dispose();
    // _entryAnimationController = null;

    _titleNotifier.dispose();

    _drawerAnimationController.dispose();
    _drawerNotifAnimController.dispose();
    _contentAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<NotificationDrawerProvider>(
            create: (context) => NotificationDrawerProvider()),
        ChangeNotifierProvider<HomeScrollNotifProvider>(
            create: (_) => HomeScrollNotifProvider()),
      ],
      builder: (context, child) => _ThisInheritedWidget(
        onOpenDrawer: _onOpenDrawer,
        onOpenRightDrawer: _onOpenRightDrawer,
        appbarTitleNotifier: _titleNotifier,
        onNotificationTap: _onOpenRightDrawer,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: color1C2023,
          body: SafeArea(
            child: GestureDetector(
              onHorizontalDragCancel: _onHorizontalDragCancel,
              onHorizontalDragEnd: _onHorizontalDragEnd,
              onHorizontalDragStart: _onHorizontalDragStart,
              onHorizontalDragUpdate: (details) =>
                  _onHorizontalDragUpdate(details),
              child: Stack(
                alignment: Alignment.topLeft,
                children: [
                  Positioned(
                    top: 0,
                    right: 0,
                    bottom: 0,
                    child: AnimatedBuilder(
                      animation: _leftDrawerWidthAnimation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(_leftDrawerWidthAnimation.value, 0.0),
                          child: child,
                        );
                      },
                      child: NotificationDrawerWidget(
                        onClearTap: () {
                          context.read<NotificationDrawerProvider>().seenAll();
                        },
                      ),
                    ),
                  ),
                  AnimatedBuilder(
                      animation: _rightDrawerWidthAnimation,
                      builder: (context, child) => Transform.translate(
                            offset:
                                Offset(_rightDrawerWidthAnimation.value, 0.0),
                            child: child,
                          ),
                      child: AppDrawerWidget()),
                  AnimatedBuilder(
                    animation: _rightDrawerWidthAnimation,
                    builder: (context, child) => Transform.translate(
                        offset: Offset(_rightDrawerWidthAnimation.value, 0.0),
                        child: child),
                    child: AnimatedBuilder(
                      animation: this._contentAnimController,
                      builder: (context, child) {
                        return Container(
                          transform: Matrix4.translationValues(
                              _leftDrawerWidthAnimation.value, 0.0, 0.0),
                          decoration: BoxDecoration(
                            color: color1C2023,
                            borderRadius: _drawerContentRadiusAnimation.value,
                          ),
                          foregroundDecoration: BoxDecoration(
                            color: _drawerContentColorAnimation.value,
                            borderRadius: _drawerContentRadiusAnimation.value,
                          ),
                          width: MediaQuery.of(context).size.width,
                          child: InkWell(
                            onTap: (this._isDrawerVisible ||
                                    this._isNotifDrawerVisible)
                                ? () {
                                    if (_isDrawerVisible) _onHideDrawer();
                                    if (_isNotifDrawerVisible)
                                      _onHideRightDrawer();
                                  }
                                : null,
                            child: IgnorePointer(
                              ignoring: this._isDrawerVisible ||
                                  this._isNotifDrawerVisible,
                              child: child,
                            ),
                          ),
                        );
                      },
                      child: _ThisContentWidget(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Initialise the animations
  void _initAnimations() {
    final curvedAnimation = CurvedAnimation(
      parent: _drawerAnimationController,
      curve: Curves.decelerate,
    );
    _leftDrawerWidthAnimation = Tween<double>(
      begin: 0.0,
      end: APP_DRAWER_WIDTH,
    ).animate(curvedAnimation);

    _rightDrawerWidthAnimation = Tween<double>(
      begin: 0.0,
      end: -getAppDrawerNotifWidth(),
    ).animate(CurvedAnimation(
      parent: _drawerNotifAnimController,
      curve: Curves.decelerate,
    ));

    _drawerContentColorAnimation = ColorTween(
            begin: Colors.transparent, end: color1C2023.withOpacity(0.50))
        .animate(CurvedAnimation(
      parent: _contentAnimController,
      curve: Curves.decelerate,
    ));

    _drawerContentRadiusAnimation = BorderRadiusTween(
            begin: BorderRadius.circular(0), end: BorderRadius.circular(30))
        .animate(CurvedAnimation(
      parent: _contentAnimController,
      curve: Curves.decelerate,
    ));
  }

  /// Open the drawer menu
  ///
  void _onOpenDrawer() {
    _drawerAnimationController.reset();
    _contentAnimController.reset();
    _drawerAnimationController.forward().orCancel;
    _contentAnimController.forward().orCancel;
    this._isDrawerVisible = true;
  }

  void _onOpenRightDrawer() {
    _drawerNotifAnimController.reset();
    _contentAnimController.reset();
    _drawerNotifAnimController.forward().orCancel;
    _contentAnimController.forward().orCancel;
    this._isNotifDrawerVisible = true;
  }

  /// Hide the drawer menu
  ///
  void _onHideDrawer() {
    _drawerAnimationController.reverse().orCancel;
    _contentAnimController.reverse().orCancel;
    this._isDrawerVisible = false;
  }

  /// Method to hide the right drawer or notification drawer
  void _onHideRightDrawer() {
    _drawerNotifAnimController.reverse().orCancel;
    _contentAnimController.reverse().orCancel;
    this._isNotifDrawerVisible = false;
  }

  /// handles the horizontal drag to show or hide drawer menus
  void _onHorizontalDragStart(DragStartDetails details) {
    this._dragStartDX = details.localPosition.dx;
  }

  /// Handle the drawer menu on drag
  void _onHorizontalDragUpdate(
    DragUpdateDetails details,
  ) {
    final dx = details.localPosition.dx;
    final diff = this._dragStartDX - dx;
    double perc = (diff / APP_DRAWER_WIDTH);

    if (_isNotifDrawerVisible) {
      perc = (1.0 - perc.abs()).abs().clamp(0.0, 1.0);
      _drawerNotifAnimController.value = perc;
      _contentAnimController.value = perc;
      return;
    }

    if (this._isDrawerVisible) {
      perc = (1.0 - perc.clamp(0.0, 1.0).abs());
    } else {
      perc = perc.clamp(-1.0, 0.0).abs();
    }

    if (perc > 0.0) {
      _drawerAnimationController.value = perc;
      _contentAnimController.value = perc;
    } else {
      perc = (diff / getAppDrawerNotifWidth()).clamp(0.0, 1.0);
      _drawerNotifAnimController.value = perc;
      _contentAnimController.value = perc;
    }
  }

  /// Handle the drawer drag menu
  void _onHorizontalDragComplete(Velocity velocity) {
    bool isOpen = false;
    if (_drawerNotifAnimController.value > 0.0) {
      final animVal = _drawerNotifAnimController.value;
      isOpen = animVal > 0.5;
      if (velocity.pixelsPerSecond.dx.abs() > 1000.0) {
        isOpen = !this._isNotifDrawerVisible;
      }
      if (isOpen) {
        this._isNotifDrawerVisible = true;
        _drawerNotifAnimController.forward(from: animVal).orCancel;
        _contentAnimController.forward(from: animVal).orCancel;
      } else {
        this._isNotifDrawerVisible = false;
        _drawerNotifAnimController.reverse(from: animVal).orCancel;
        _contentAnimController.reverse(from: animVal).orCancel;
      }
      return;
    }
    final animVal = _drawerAnimationController.value;
    isOpen = animVal > 0.5;
    if (velocity.pixelsPerSecond.dx.abs() > 1000.0) {
      isOpen = !this._isDrawerVisible;
    }
    if (isOpen) {
      this._isDrawerVisible = true;
      _drawerAnimationController.forward(from: animVal).orCancel;
      _contentAnimController.forward(from: animVal).orCancel;
    } else {
      this._isDrawerVisible = false;
      _drawerAnimationController.reverse(from: animVal).orCancel;
      _contentAnimController.reverse(from: animVal).orCancel;
    }
  }

  /// Handle the drawer menu animation
  void _onHorizontalDragEnd(DragEndDetails details) =>
      _onHorizontalDragComplete(details.velocity);

  /// Handle the drawer menu animation
  void _onHorizontalDragCancel() => _onHorizontalDragComplete(Velocity.zero);
}

class _ThisContentWidget extends StatefulWidget {
  @override
  __ThisContentWidgetState createState() => __ThisContentWidgetState();
}

class __ThisContentWidgetState extends State<_ThisContentWidget>
    with TickerProviderStateMixin {
  TabController _tabController;
  StreamSubscription<EnumBottonBarItem> _bottomBarStreamSubScription;

  ValueNotifier<EnumBottonBarItem> _bottomNavbarNotifier;

  @override
  void initState() {
    _bottomNavbarNotifier =
        ValueNotifier<EnumBottonBarItem>(EnumBottonBarItem.Home);

    _tabController =
        TabController(length: EnumBottonBarItem.values.length, vsync: this)
          ..addListener(() {
            context.read<HomeScrollNotifProvider>().scrollOffset = 0.0;
          });
    super.initState();
    _subscribeBottomBarStream();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _bottomNavbarNotifier.dispose();
    _unsubscribeBottomBar();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<EnumBottonBarItem>(
      valueListenable: _bottomNavbarNotifier,
      builder: (context, selectedMenu, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _ThisAppBar(),
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: TabBarView(
                      controller: _tabController,
                      physics: NeverScrollableScrollPhysics(),
                      children: EnumBottonBarItem.values
                          .map((e) => _buildBottomBarTab(e))
                          .toList(),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Consumer2<BottomNavigationProvider,
                        HomeScrollNotifProvider>(
                      builder: (context, bottomNavigationProvider,
                          homeScrollProvider, child) {
                        return Container(
                          height: homeScrollProvider.bottombarSize -
                              homeScrollProvider.bottombarValue,
                          child: SingleChildScrollView(
                            physics: NeverScrollableScrollPhysics(),
                            child: Container(
                              transform: Matrix4.identity(),
                              height: homeScrollProvider.bottombarSize,
                              child: AppBottomNavigationBar(
                                onSelected: _onBottomNavigationSelected,
                                initialItem: EnumBottonBarItem
                                    .values[_tabController.index],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  /// Widget to build the content view based on bottom navigation bar selection
  Widget _buildBottomBarTab(EnumBottonBarItem e) {
    switch (e) {
      case EnumBottonBarItem.Home:
        return HomeTabView();
      case EnumBottonBarItem.Exchange:
        return ExchangeTabView(
          onBottombarItemSel: _onBottomNavigationSelected,
          tabController: _tabController,
        );
      case EnumBottonBarItem.Trade:
        return TradeTabView();
      case EnumBottonBarItem.Balance:
        return BalanceTabView();
    }
    return Container(
      alignment: Alignment.center,
      child: Text(
        "Coming soon",
        style: tsS14W400CFFOP50,
      ),
    );
  }

  /// This method will be called when user click on search icon on app bar
  // void _onSearchTap(BuildContext context) {}
  void _onBottomNavigationSelected(EnumBottonBarItem item) {
    _bottomNavbarNotifier.value = item;
    String title = "Hello Kas";
    switch (item) {
      case EnumBottonBarItem.Home:
        title = "Hello Kas";
        break;
      case EnumBottonBarItem.Exchange:
        title = "Exchange";
        break;
      case EnumBottonBarItem.Trade:
        title = "Trade";
        break;
      case EnumBottonBarItem.Balance:
        title = "Balance";
        break;
    }
    Future.microtask(() =>
        _ThisInheritedWidget.of(context).appbarTitleNotifier.value = title);
    _tabController.animateTo(EnumBottonBarItem.values.indexOf(item),
        curve: Curves.easeIn);
  }

  /// Unsubscribe from bottom navigation bar selection
  void _unsubscribeBottomBar() {
    if (_bottomBarStreamSubScription != null) {
      _bottomBarStreamSubScription.cancel();
      _bottomBarStreamSubScription = null;
    }
  }

  /// Subscribe to bottom navigation bar selection
  void _subscribeBottomBarStream() {
    _unsubscribeBottomBar();
    _bottomBarStreamSubScription =
        BottomNavigationProvider().streamBottomBarItem.listen((type) {
      _tabController.animateTo(EnumBottonBarItem.values.indexOf(type));
    });
  }
}

/// The notification icon on the app bar
/// [count] will be displayed on colored circle. Pass it null/empty
/// string to hide
///
class _ThisNotificationIcon extends StatelessWidget {
  final String count;
  const _ThisNotificationIcon({
    Key key,
    @required this.count,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: SvgPicture.asset(
            'notification'.asAssetSvg(),
          ),
        ),
        if (this.count?.isNotEmpty ?? false)
          Positioned(
            top: this.count.length > 1 ? 0 : -1,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorE6007A,
              ),
              padding: const EdgeInsets.all(4),
              child: Text(
                this.count ?? "",
                style: TextStyle(
                  fontSize: 10,
                  color: colorFFFFFF,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// The app bar for the landing screen. This wideget is shown as appbar for
/// all the tabviews
class _ThisBaseAppbar extends StatelessWidget with PreferredSizeWidget {
  final String assetImg;
  final String title;
  final List<Widget> actions;
  // final Animation<double> animation;

  /// The call back listner for avatar onTap
  final VoidCallback onAvatarTapped;

  const _ThisBaseAppbar({
    Key key,
    this.assetImg,
    this.title,
    this.actions,
    this.onAvatarTapped,
    // this.animation,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            if (assetImg?.isNotEmpty ?? false) _buildImage(),
            if (title?.isNotEmpty ?? false) _buildName() else Spacer(),
            if (actions?.isNotEmpty ?? false) _buildActions(),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size(double.infinity, kToolbarHeight);

  Widget _buildActions() {
    return
        //  SlideTransition(
        //   position: this.animation.drive<Offset>(Tween<Offset>(
        //         begin: Offset(1.0, 0.0),
        //         end: Offset(0.0, 0.0),
        //       )),
        //   child:
        Row(
      children: this.actions ?? <Widget>[],
      // ),
    );
  }

  Widget _buildName() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child:
            // FadeTransition(
            //   opacity: this.animation,
            //   child:
            Text(
          title ?? "",
          style: tsS19W600CFF,
        ),
      ),
      // ),
    );
  }

  Widget _buildImage() {
    return InkWell(
      onTap: this.onAvatarTapped,
      // child:
      //  SlideTransition(
      //   position: this.animation.drive<Offset>(Tween<Offset>(
      //         begin: Offset(-1.0, 0.0),
      //         end: Offset(0.0, 0.0),
      //       )),
      child: Image.asset(
        this.assetImg,
        width: 38,
        height: 38,
        fit: BoxFit.contain,
      ),
      // ),
    );
  }
}

/// The inherited widget for the entire screen to access the parent methods
/// from the child widgets
class _ThisInheritedWidget extends InheritedWidget {
  /// Method to open the left drawer menu
  final VoidCallback onOpenDrawer;

  /// Method to open the right drawer menu
  final VoidCallback onOpenRightDrawer;

  /// Set the title on the appbar
  final ValueNotifier<String> appbarTitleNotifier;

  /// Handle the notification icon click on app bar
  final VoidCallback onNotificationTap;

  _ThisInheritedWidget({
    @required this.onOpenDrawer,
    @required this.onOpenRightDrawer,
    @required this.appbarTitleNotifier,
    @required this.onNotificationTap,
    @required Widget child,
    Key key,
  }) : super(child: child, key: key);

  @override
  bool updateShouldNotify(covariant _ThisInheritedWidget oldWidget) {
    return oldWidget.onOpenDrawer != this.onOpenDrawer ||
        oldWidget.onOpenRightDrawer != this.onOpenRightDrawer ||
        oldWidget.onNotificationTap != this.onNotificationTap ||
        oldWidget.appbarTitleNotifier != this.appbarTitleNotifier;
  }

  static _ThisInheritedWidget of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_ThisInheritedWidget>();
}

/// The app bar widget for the screen.
class _ThisAppBar extends StatelessWidget {
  const _ThisAppBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HomeScrollNotifProvider>();
    return Container(
      height: kToolbarHeight - provider.appbarValue,
      child: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Container(
          transform: Matrix4.identity()..translate(0.0, -provider.appbarValue),
          height: kToolbarHeight,
          child: ValueListenableBuilder<String>(
            valueListenable:
                _ThisInheritedWidget.of(context).appbarTitleNotifier,
            builder: (context, title, child) => _ThisBaseAppbar(
              // animation: this._appbarAnimation,
              assetImg: 'user_icon.png'.asAssetImg(),
              title: title ?? 'Hello Kas',
              actions: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => MarketTokenSelectionScreen(),
                    ));
                  },
                  child: SizedBox(
                    width: 25,
                    height: 25,
                    child: SvgPicture.asset(
                      'search'.asAssetSvg(),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                InkWell(
                  onTap: () =>
                      _ThisInheritedWidget.of(context).onNotificationTap(),
                  child: SizedBox(
                    width: 25,
                    height: 25,
                    child: _ThisNotificationIcon(
                      count: "2",
                    ),
                  ),
                ),
              ],
              onAvatarTapped: () =>
                  _ThisInheritedWidget.of(context).onOpenDrawer(),
            ),
          ),
        ),
      ),
    );
  }
}
