import 'package:doctor_app/core/assets/colors/app_colors.dart';
import 'package:doctor_app/core/constants/approutes/approutes.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _verticalBounceController;
  late AnimationController _holeFadeController;
  late AnimationController _horizontalMoveController;
  late AnimationController _textFadeController;

  late Animation<double> _verticalBounce;
  late Animation<double> _holeOpacity;
  late Animation<double> _horizontalMove;
  late Animation<double> _textOpacity;

  bool _showHole = true;
  bool _showText = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimationSequence();
  }

  void _initializeAnimations() {
    _verticalBounceController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _verticalBounce = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: 0.0,
          end: -300.0,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 70,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: -300.0,
          end: 0.0,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 30,
      ),
    ]).animate(_verticalBounceController);

    _holeFadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _holeOpacity = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(parent: _holeFadeController, curve: Curves.easeOut),
    );

    _horizontalMoveController = AnimationController(
      duration: const Duration(milliseconds: 2400),
      vsync: this,
    );

    // Will animate from +300 (right of center) to 20 px from left edge
    _horizontalMove = Tween<double>(
      begin: 300,
      end:
          -(MediaQueryData.fromWindow(
                WidgetsBinding.instance.window,
              ).size.width /
              2) +
          20 +
          30,
    ).animate(
      CurvedAnimation(
        parent: _horizontalMoveController,
        curve: Curves.easeInOut,
      ),
    );

    _textFadeController = AnimationController(
      duration: const Duration(milliseconds: 1600),
      vsync: this,
    );

    _textOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _textFadeController, curve: Curves.easeIn),
    );
  }

  Future<void> _startAnimationSequence() async {
    setState(() {
      _showHole = true;
      _showText = false;
    });

    await _verticalBounceController.forward();

    await _holeFadeController.forward();
    setState(() {
      _showHole = false;
    });

    setState(() {
      _showText = true;
    });

    await Future.wait([
      _horizontalMoveController.forward(),
      _textFadeController.forward(),
    ]);

    await Future.delayed(const Duration(milliseconds: 1000));
    if (mounted) {
      Navigator.of(context).pushReplacementNamed(Routes.openingScreen);
    }
  }

  @override
  void dispose() {
    _verticalBounceController.dispose();
    _holeFadeController.dispose();
    _horizontalMoveController.dispose();
    _textFadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final baseY = screenHeight / 2 - 30;
    final baseX = screenWidth / 2 - 30;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.gradientTop, AppColors.gradientBottom],
          ),
        ),
        child: Stack(
          children: [
            if (_showHole)
              AnimatedBuilder(
                animation: _holeOpacity,
                builder: (context, child) {
                  return Positioned(
                    left: baseX - 60,
                    top: baseY + 30,
                    child: Opacity(
                      opacity: _holeOpacity.value,
                      child: Container(
                        width: 120,
                        height: 60,
                        decoration: const BoxDecoration(
                          color: Color(0xFF316A7C),
                          borderRadius: BorderRadius.all(
                            Radius.elliptical(60, 30),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

            AnimatedBuilder(
              animation: Listenable.merge([
                _verticalBounceController,
                _horizontalMoveController,
              ]),
              builder: (context, child) {
                double y = baseY + _verticalBounce.value;

                double x;
                if (_horizontalMoveController.isAnimating ||
                    _horizontalMoveController.isCompleted) {
                  x = baseX + _horizontalMove.value;
                } else {
                  x = baseX;
                }

                return Positioned(
                  left: x,
                  top: y,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            if (_showText)
              AnimatedBuilder(
                animation: Listenable.merge([
                  _horizontalMoveController,
                  _textFadeController,
                ]),
                builder: (context, child) {
                  double ballX;
                  if (_horizontalMoveController.isAnimating ||
                      _horizontalMoveController.isCompleted) {
                    ballX = baseX + _horizontalMove.value;
                  } else {
                    ballX = baseX;
                  }

                  double textX = ballX + 80;
                  double textY = baseY + 10;

                  return Positioned(
                    left: textX,
                    top: textY,
                    child: Opacity(
                      opacity: _textOpacity.value,
                      child: const Text(
                        'Doctor App',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
