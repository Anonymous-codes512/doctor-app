import 'package:doctor_app/core/assets/colors/app_colors.dart';
import 'package:doctor_app/core/constants/approutes/approutes.dart';
import 'package:flutter/material.dart';
import 'package:doctor_app/core/assets/images/images_paths.dart';

// Reusable text styles
class AppTextStyles {
  static const title = TextStyle(
    color: Colors.white,
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  static const subtitle = TextStyle(color: Colors.white70, fontSize: 16);

  static const smallTitle = TextStyle(
    color: Colors.white,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  static const smallSubtitle = TextStyle(color: Colors.white70, fontSize: 14);
}

// Reusable icon box widget
class IconBox extends StatelessWidget {
  final IconData icon;
  final String label;
  final double width;
  final double height;

  const IconBox({
    super.key,
    required this.icon,
    required this.label,
    this.width = 140,
    this.height = 100,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.gradientBottom.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

// Reusable onboarding content widget
class OnboardingContent extends StatelessWidget {
  final String imagePath;
  final List<Widget>? iconBoxes;
  final String title;
  final String subtitle;
  final double imageHeight;

  const OnboardingContent({
    super.key,
    required this.imagePath,
    this.iconBoxes,
    required this.title,
    required this.subtitle,
    this.imageHeight = 250,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(
              imagePath,
              height: imageHeight,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 25),
          if (iconBoxes != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: iconBoxes!,
            ),
          if (iconBoxes != null) const SizedBox(height: 36),
          Text(
            title,
            textAlign: TextAlign.center,
            style:
                iconBoxes == null
                    ? AppTextStyles.title
                    : AppTextStyles.smallTitle,
          ),
          const SizedBox(height: 12),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style:
                iconBoxes == null
                    ? AppTextStyles.subtitle
                    : AppTextStyles.smallSubtitle,
          ),
        ],
      ),
    );
  }
}

// Main onboarding screen with page controller
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.animateToPage(
        _currentPage + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.of(context).pushReplacementNamed(Routes.splash);
    }
  }

  void _skip() {
    _pageController.animateToPage(
      2,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Widget _buildDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 6),
          width: _currentPage == index ? 12 : 8,
          height: _currentPage == index ? 12 : 8,
          decoration: BoxDecoration(
            color: _currentPage == index ? Colors.white : Colors.white54,
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }

  final LinearGradient _backgroundGradient = const LinearGradient(
    colors: [AppColors.gradientTop, AppColors.gradientBottom],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(gradient: _backgroundGradient),
        child: SafeArea(
          child: Stack(
            children: [
              PageView(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                children: const [
                  FirstOnboardingScreen(),
                  SecondOnboardingScreen(),
                  ThirdOnboardingScreen(),
                ],
              ),
              Positioned(
                top: 16,
                right: 16,
                child: TextButton(
                  onPressed: _skip,
                  child: const Text(
                    'Skip',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
              Positioned(bottom: 110, left: 0, right: 0, child: _buildDots()),
              Positioned(
                bottom: 40,
                left: 32,
                right: 32,
                child: ElevatedButton(
                  onPressed: _nextPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    _currentPage == 2 ? 'Get Started' : 'Next',
                    style: const TextStyle(
                      color: Color(0xFF6B56D2),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// First onboarding screen
class FirstOnboardingScreen extends StatelessWidget {
  const FirstOnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return OnboardingContent(
      imagePath: ImagePath.onboardingImage1,
      title: 'Professional Care at Your Fingertips',
      subtitle:
          'Connect with licensed psychiatrists and mental health experts from the comfort of your home',
      iconBoxes: null,
    );
  }
}

// Second onboarding screen
class SecondOnboardingScreen extends StatelessWidget {
  const SecondOnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return OnboardingContent(
      imagePath: ImagePath.onboardingImage2,
      iconBoxes: const [
        IconBox(icon: Icons.calendar_today_outlined, label: '24/7 Booking'),
        IconBox(icon: Icons.videocam_outlined, label: 'HD Video Calls'),
      ],
      title: 'Flexible Scheduling & Consultations',
      subtitle:
          'Book appointments and have secure video consultations whenever you need support',
    );
  }
}

// Third onboarding screen
class ThirdOnboardingScreen extends StatelessWidget {
  const ThirdOnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return OnboardingContent(
      imagePath: ImagePath.onboardingImage3,
      iconBoxes: const [
        IconBox(
          icon: Icons.psychology_outlined,
          label: 'Mindfulness',
          width: 100,
          height: 100,
        ),
        IconBox(
          icon: Icons.favorite_outline,
          label: 'Wellness',
          width: 100,
          height: 100,
        ),
        IconBox(
          icon: Icons.sentiment_satisfied_alt_outlined,
          label: 'Growth',
          width: 100,
          height: 100,
        ),
      ],
      title: 'Begin Your Journey',
      subtitle:
          'Start your path to better mental health and emotional well-being today',
      imageHeight: 220,
    );
  }
}
