import 'dart:async';
import 'package:Gixa/Modules/Collage/veiw/collage_list_page.dart';
import 'package:Gixa/Modules/Home/Veiw/home_page.dart';
import 'package:Gixa/Modules/Home/controller/home_controller.dart';
import 'package:Gixa/Modules/Home/widgets/home_subscription_highlight_card.dart';
import 'package:Gixa/Modules/counselling_roadmap/view/counselling_roadmap_screen.dart';
import 'package:Gixa/Modules/predication/view/predication_view.dart';
import 'package:Gixa/Modules/settings/view/settings_page.dart';
import 'package:Gixa/Modules/subscription/controller/subscription_controller.dart';
import 'package:Gixa/Modules/subscription/view/subscription_plan_page.dart';
import 'package:Gixa/naivgation/controller/nav_bar_controller.dart';
import 'package:Gixa/naivgation/veiw/modern_bottom_nav.dart';
import 'package:Gixa/services/auth_guard.dart';
import 'package:Gixa/services/token_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:toast/toast.dart';

class MainNavPage extends StatefulWidget {
  MainNavPage({super.key});

  @override
  State<MainNavPage> createState() => _MainNavPageState();
}

class _MainNavPageState extends State<MainNavPage> {
  static const String _homeShowcaseActiveStorageKey =
      'home_page_showcase_active_v1';
  final controller = Get.isRegistered<MainNavController>()
      ? Get.find<MainNavController>()
      : Get.put(MainNavController(), permanent: true);
  final subscriptionController = Get.isRegistered<SubscriptionController>()
      ? Get.find<SubscriptionController>()
      : Get.put(SubscriptionController());
  final GetStorage _box = GetStorage();

  late final Map<int, Widget> _pages = {
    0: _buildHomePage(),
    1: CounsellingRoadmapScreen(),
    2: CollegeListPage(),
    3: AccountManageScreen(),
  };
  DateTime? _lastBackPressed;
  Worker? _popupTriggerWorker;
  Future<void>? _popupPreparationFuture;
  bool _isPopupShowing = false;
  bool _hasShownPopupThisSession = false;

  @override
  void initState() {
    super.initState();

    _popupTriggerWorker = ever<bool>(controller.pendingSubscriptionPopup, (
      shouldShow,
    ) {
      if (!mounted) return;

      if (!shouldShow) {
        return;
      }

      controller.consumeSubscriptionPopupRequest();
      unawaited(_prepareStartupSubscriptionPopup());
    });

    if (controller.pendingSubscriptionPopup.value == true) {
      controller.consumeSubscriptionPopupRequest();
      unawaited(_prepareStartupSubscriptionPopup());
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_prepareStartupSubscriptionPopup());
    });
  }

  Future<void> _prepareStartupSubscriptionPopup() async {
    if (!await _canShowSubscriptionPopup()) {
      return;
    }

    final inFlight = _popupPreparationFuture;
    if (inFlight != null) {
      await inFlight;
      return;
    }

    final future = _runStartupSubscriptionPopupPreparation();
    _popupPreparationFuture = future;

    try {
      await future;
    } finally {
      if (identical(_popupPreparationFuture, future)) {
        _popupPreparationFuture = null;
      }
    }
  }

  Future<void> _runStartupSubscriptionPopupPreparation() async {
    if (!await _canShowSubscriptionPopup()) {
      return;
    }

    await Future.delayed(const Duration(milliseconds: 800));

    if (!mounted || _isPopupShowing || _hasShownPopupThisSession) return;

    await subscriptionController.ensurePlanCatalogLoaded(forceRefresh: true);

    if (!mounted || _isPopupShowing || _hasShownPopupThisSession) return;
    if (subscriptionController.plans.isEmpty) return;

    final canShowPopup = await _waitForHomeShowcaseToFinish();
    if (!canShowPopup ||
        !mounted ||
        _isPopupShowing ||
        _hasShownPopupThisSession) {
      return;
    }

    _hasShownPopupThisSession = true;

    await Future.delayed(const Duration(seconds: 2));

    final canStillShowPopup = await _waitForHomeShowcaseToFinish();
    if (!canStillShowPopup || !mounted || _isPopupShowing) {
      _hasShownPopupThisSession = false;
      return;
    }

    _showSubscriptionPopup();
  }

  Future<bool> _canShowSubscriptionPopup() async {
    final isRegistered = _box.read('registration_completed') == true;
    if (!isRegistered) {
      return false;
    }

    final accessToken = await TokenService.getAccessToken();
    final refreshToken = await TokenService.getRefreshToken();

    return (accessToken != null && accessToken.trim().isNotEmpty) ||
        (refreshToken != null && refreshToken.trim().isNotEmpty);
  }

  @override
  void dispose() {
    _popupTriggerWorker?.dispose();
    super.dispose();
  }

  Future<bool> _waitForHomeShowcaseToFinish() async {
    for (var attempt = 0; attempt < 40; attempt++) {
      if (!mounted) return false;

      final isHomeShowcaseActive =
          _box.read(_homeShowcaseActiveStorageKey) == true;
      if (!isHomeShowcaseActive) {
        return true;
      }

      await Future.delayed(const Duration(milliseconds: 350));
    }

    return mounted && (_box.read(_homeShowcaseActiveStorageKey) != true);
  }

  Widget _buildHomePage() {
    if (Get.isRegistered<HomeController>()) {
      return GetBuilder<HomeController>(builder: (_) => const HomePage());
    }

    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (_) => const HomePage(),
    );
  }

  // Widget _buildPage(int index) {
  //   switch (index) {
  //     /// COUNSELLING
  //     case 1:
  //       return PredictionSheetScreen();

  //     /// COLLEGES
  //     case 2:
  //       return CollegeListPage();

  //     /// ACCOUNT
  //     case 3:
  //       return AccountManageScreen();

  //     /// HOME
  //     case 0:
  //     default:
  //       return _buildHomePage();
  //   }
  // }

  Widget _pageFor(int index) {
    return _pages[index]!;
  }

  Future<bool> _onWillPop() async {
    if (controller.currentIndex.value != 0) {
      controller.currentIndex.value = 0;
      return false;
    }

    final now = DateTime.now();

    if (_lastBackPressed == null ||
        now.difference(_lastBackPressed!) > const Duration(seconds: 2)) {
      _lastBackPressed = now;

      Toast.show(
        "Press back again to exit",

        duration: Toast.lengthShort,
        gravity: Toast.bottom,

        backgroundColor: Colors.black87,

        textStyle: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      );

      return false;
    }

    await SystemNavigator.pop();

    return false;
  }

  void _showSubscriptionPopup() {
    FocusScope.of(context).unfocus();
    if (_isPopupShowing) return;

    _isPopupShowing = true;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Premium",
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 350),
      pageBuilder: (_, animation, secondaryAnimation) {
        return SafeArea(
          child: Align(
            alignment: Alignment.topCenter,

            child: Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.08,
                left: 16,
                right: 16,
                bottom: 20,
              ),

              child: Material(
                color: Colors.transparent,

                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),

                  child: SubscriptionPopupCard(
                    onSubscribe: () {
                      Get.back();

                      Get.to(() => SubscriptionPage());
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      },

      transitionBuilder: (_, animation, __, child) {
        return Transform.scale(
          scale: Curves.easeOutBack.transform(animation.value),

          child: Opacity(opacity: animation.value, child: child),
        );
      },
    ).then((_) {
      _isPopupShowing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);

    return Obx(() {
      final currentIndex = controller.currentIndex.value;

      return WillPopScope(
        onWillPop: _onWillPop,

        child: Scaffold(
          resizeToAvoidBottomInset: false,

          body: IndexedStack(
            index: currentIndex,
            children: [
              _pageFor(0), // Home
              _pageFor(1), // Prediction Sheet
              _pageFor(2), // Colleges
              _pageFor(3), // Account
            ],
          ),

          bottomNavigationBar: Obx(
            () => ModernBottomNav(
              currentIndex: controller.currentIndex.value,

              onTap: (index) {
                /// HOME ALWAYS OPEN
                if (index == 0) {
                  controller.changeTab(index);
                  return;
                }

                /// PROTECTED TABS
                AuthGuard.checkAccess(
                  onAllowed: () {
                    controller.changeTab(index);
                  },
                );
              },
            ),
          ),
        ),
      );
    });
  }
}
