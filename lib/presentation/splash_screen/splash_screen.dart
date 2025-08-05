import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/app_theme.dart';
import '../../widgets/custom_icon_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _mAnimationController;
  late AnimationController _firstTAnimationController;
  late AnimationController _secondTAnimationController;
  late AnimationController _textAnimationController;

  late Animation<Offset> _mSlideAnimation;
  late Animation<Offset> _firstTSlideAnimation;
  late Animation<Offset> _secondTSlideAnimation;
  late Animation<Offset> _textSlideAnimation;

  @override
  void initState() {
    super.initState();
    debugPrint('SplashScreen: initState called.');
    _initializeAnimations();
    _startAnimationSequence();
    _initializeApp();
  }

  void _initializeAnimations() {
    debugPrint('SplashScreen: _initializeAnimations called.');
    // M character animation (from left)
    _mAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _mSlideAnimation =
        Tween<Offset>(begin: const Offset(-2.0, 0.0), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _mAnimationController,
            curve: Curves.easeOutBack,
          ),
        );

    // First T character animation (from top)
    _firstTAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _firstTSlideAnimation =
        Tween<Offset>(begin: const Offset(0.0, -2.0), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _firstTAnimationController,
            curve: Curves.easeOutBack,
          ),
        );

    // Second T character animation (from right)
    _secondTAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _secondTSlideAnimation =
        Tween<Offset>(begin: const Offset(2.0, 0.0), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _secondTAnimationController,
            curve: Curves.easeOutBack,
          ),
        );

    // Text animation (from bottom)
    _textAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _textSlideAnimation =
        Tween<Offset>(begin: const Offset(0.0, 2.0), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _textAnimationController,
            curve: Curves.easeOutBack,
          ),
        );
  }

  void _startAnimationSequence() async {
    debugPrint('SplashScreen: _startAnimationSequence called.');
    // Start M animation
    await Future.delayed(const Duration(milliseconds: 300));
    _mAnimationController.forward();

    // Start first T animation
    await Future.delayed(const Duration(milliseconds: 200));
    _firstTAnimationController.forward();

    // Start second T animation
    await Future.delayed(const Duration(milliseconds: 200));
    _secondTAnimationController.forward();

    // Start text animation
    await Future.delayed(const Duration(milliseconds: 200));
    _textAnimationController.forward();

    // Navigate after all animations complete
    await _initializeApp();
    if (mounted) {
      debugPrint('SplashScreen: Navigating to next screen...');
      _navigateToNextScreen();
    }
  }

  Future<void> _initializeApp() async {
    debugPrint('SplashScreen: _initializeApp called.');
    try {
      // Simulate app initialization tasks
      await Future.wait([
        _checkAuthenticationStatus(),
        _loadUserPreferences(),
        _initializeLocalNotifications(),
        _prepareMedicationDataCache(),
      ]);
      debugPrint('SplashScreen: App initialization tasks completed.');
    } catch (e) {
      // Handle initialization errors gracefully
      debugPrint('SplashScreen: App initialization error: $e');
    }
  }

  Future<void> _checkAuthenticationStatus() async {
    debugPrint('SplashScreen: _checkAuthenticationStatus called.');
    // Mock authentication check
    debugPrint('SplashScreen: Authentication check completed.');
  }

  Future<void> _loadUserPreferences() async {
    debugPrint('SplashScreen: _loadUserPreferences called.');
    // Mock user preferences loading
    debugPrint('SplashScreen: User preferences loaded.');
  }

  Future<void> _initializeLocalNotifications() async {
    debugPrint('SplashScreen: _initializeLocalNotifications called.');
    // Mock notification initialization
    debugPrint('SplashScreen: Local notifications initialized.');
  }

  Future<void> _prepareMedicationDataCache() async {
    debugPrint('SplashScreen: _prepareMedicationDataCache called.');
    // Mock medication data preparation
    debugPrint('SplashScreen: Medication data cache prepared.');
  }

  void _navigateToNextScreen() {
    debugPrint('SplashScreen: _navigateToNextScreen called.');
    // Mock authentication check - in real app, check actual auth status
    final bool isAuthenticated = false; // Mock value

    if (isAuthenticated) {
      Navigator.pushReplacementNamed(context, '/home-screen');
    } else {
      Navigator.pushReplacementNamed(context, '/welcome-screen');
    }
    debugPrint('SplashScreen: Navigation completed.');
  }

  @override
  void dispose() {
    _mAnimationController.dispose();
    _firstTAnimationController.dispose();
    _secondTAnimationController.dispose();
    _textAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: AppTheme.primaryLight,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: AppTheme.primaryLight,
        body: SafeArea(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(color: AppTheme.primaryLight),
            child: Stack(
              children: [
                // Main content
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // First-aid kit icon
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppTheme.onPrimaryLight,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: CustomIconWidget(
                          iconName: 'medical_services',
                          color: AppTheme.primaryLight,
                          size: 48,
                        ),
                      ),

                      const SizedBox(height: 32),

                      // MTT animated text
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // M character
                          SlideTransition(
                            position: _mSlideAnimation,
                            child: Text(
                              'M',
                              style: Theme.of(context).textTheme.displayLarge
                                  ?.copyWith(
                                    color: AppTheme.onPrimaryLight,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 64,
                                  ),
                            ),
                          ),

                          // First T character
                          SlideTransition(
                            position: _firstTSlideAnimation,
                            child: Text(
                              'T',
                              style: Theme.of(context).textTheme.displayLarge
                                  ?.copyWith(
                                    color: AppTheme.onPrimaryLight,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 64,
                                  ),
                            ),
                          ),

                          // Second T character
                          SlideTransition(
                            position: _secondTSlideAnimation,
                            child: Text(
                              'T',
                              style: Theme.of(context).textTheme.displayLarge
                                  ?.copyWith(
                                    color: AppTheme.onPrimaryLight,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 64,
                                  ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Care Giver Assistant text
                      SlideTransition(
                        position: _textSlideAnimation,
                        child: Text(
                          'Care Giver Assistant',
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                                color: AppTheme.onPrimaryLight,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 1.2,
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      const SizedBox(height: 48),

                      // Loading indicator
                      SizedBox(
                        width: 32,
                        height: 32,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppTheme.onPrimaryLight.withValues(alpha: 0.8),
                          ),
                          strokeWidth: 3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
