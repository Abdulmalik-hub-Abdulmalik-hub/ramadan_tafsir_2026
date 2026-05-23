import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'main.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _glowController;
  late AnimationController _patternController;

  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _glowAnimation;
  late Animation<double> _patternAnimation;

  bool _showContent = false;
  bool _showEnterButton = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startAnimationSequence();
  }

  void _setupAnimations() {
    // Main fade animation
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );

    // Slide animation
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );

    // Glow animation for decorative elements
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _glowAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _glowController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _glowController.forward();
        }
      });

    // Pattern rotation animation
    _patternController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    );
    _patternAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _patternController, curve: Curves.linear),
    );
  }

  void _startAnimationSequence() async {
    // Start animations
    _fadeController.forward();
    _slideController.forward();
    _glowController.forward();
    _patternController.repeat();

    // Show content after initial fade
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      setState(() => _showContent = true);
    }

    // Show enter button last
    await Future.delayed(const Duration(milliseconds: 1500));
    if (mounted) {
      setState(() => _showEnterButton = true);
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _glowController.dispose();
    _patternController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: Stack(
          children: [
            // Deep dark green background
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF0A1A0A),
                    Color(0xFF061006),
                    Color(0xFF020802),
                  ],
                  stops: [0.0, 0.5, 1.0],
                ),
              ),
            ),

            // Animated Islamic geometric pattern (background)
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _patternAnimation,
                builder: (context, child) {
                  return CustomPaint(
                    painter: IslamicPatternPainter(
                      progress: _patternAnimation.value,
                      opacity: 0.05,
                    ),
                  );
                },
              ),
            ),

            // Central glow effect
            Center(
              child: AnimatedBuilder(
                animation: _glowAnimation,
                builder: (context, child) {
                  return Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          const Color(0xFF1B5E20).withOpacity(0.3 * _glowAnimation.value),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Content
            SafeArea(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  children: [
                    const Spacer(flex: 2),

                    // Crescent moon and star
                    AnimatedOpacity(
                      opacity: _showContent ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 800),
                      child: Transform.translate(
                        offset: Offset(0, _slideAnimation.value),
                        child: _buildCrescentMoon(),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Bismillah text
                    AnimatedOpacity(
                      opacity: _showContent ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 800),
                      child: Transform.translate(
                        offset: Offset(0, _slideAnimation.value),
                        child: _buildBismillah(),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Decorative divider
                    AnimatedOpacity(
                      opacity: _showContent ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 800),
                      child: _buildDecorativeDivider(),
                    ),

                    const SizedBox(height: 30),

                    // Main title
                    AnimatedOpacity(
                      opacity: _showContent ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 800),
                      child: Transform.translate(
                        offset: Offset(0, _slideAnimation.value),
                        child: _buildMainTitle(),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Subtitle - Sheikh name
                    AnimatedOpacity(
                      opacity: _showContent ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 800),
                      child: Transform.translate(
                        offset: Offset(0, _slideAnimation.value),
                        child: _buildSubtitle(),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Year badge
                    AnimatedOpacity(
                      opacity: _showContent ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 800),
                      child: _buildYearBadge(),
                    ),

                    const Spacer(flex: 3),

                    // Enter button
                    AnimatedOpacity(
                      opacity: _showEnterButton ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 600),
                      child: AnimatedSlide(
                        offset: _showEnterButton
                            ? Offset.zero
                            : const Offset(0, 0.5),
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.easeOutCubic,
                        child: _buildEnterButton(),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Footer text
                    AnimatedOpacity(
                      opacity: _showEnterButton ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 600),
                      child: _buildFooterText(),
                    ),

                    const Spacer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCrescentMoon() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFD700).withOpacity(0.3),
            blurRadius: 40,
            spreadRadius: 10,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Glow effect
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFFFFD700).withOpacity(0.2),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          // Crescent moon using ClipPath
          ClipPath(
            clipper: CrescentClipper(),
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFFFFD700),
                    const Color(0xFFFFA500),
                  ],
                ),
              ),
            ),
          ),
          // Star
          const Positioned(
            right: 30,
            top: 35,
            child: Icon(
              Icons.star_rounded,
              color: Color(0xFFFFD700),
              size: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBismillah() {
    return Column(
      children: [
        Text(
          'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w500,
            color: const Color(0xFFFFD700).withOpacity(0.9),
            letterSpacing: 2,
            shadows: [
              Shadow(
                color: const Color(0xFFFFD700).withOpacity(0.3),
                blurRadius: 10,
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'In the name of Allah, the Most Gracious, the Most Merciful',
          style: TextStyle(
            fontSize: 11,
            color: Colors.white.withOpacity(0.5),
            fontStyle: FontStyle.italic,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildDecorativeDivider() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildDiamond(12),
        Container(
          width: 60,
          height: 1,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                const Color(0xFFFFD700).withOpacity(0.6),
              ],
            ),
          ),
        ),
        _buildDiamond(16),
        Container(
          width: 60,
          height: 1,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFFFFD700).withOpacity(0.6),
                Colors.transparent,
              ],
            ),
          ),
        ),
        _buildDiamond(12),
      ],
    );
  }

  Widget _buildDiamond(double size) {
    return Transform.rotate(
      angle: 0.7854, // 45 degrees
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: const Color(0xFFFFD700).withOpacity(0.7),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _buildMainTitle() {
    return Column(
      children: [
        const Text(
          'TAFSEER',
          style: TextStyle(
            fontSize: 42,
            fontWeight: FontWeight.w300,
            color: Colors.white,
            letterSpacing: 12,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 4),
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
          ).createShader(bounds),
          child: const Text(
            'RAMADAN 2026',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 8,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubtitle() {
    return Column(
      children: [
        Text(
          'Sheikh Sani Aja',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.white.withOpacity(0.85),
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Sheikh Abdulmalik Isyaku Rabiu',
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.5),
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildYearBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFFFFD700).withOpacity(0.3),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.calendar_today_rounded,
            size: 14,
            color: const Color(0xFFFFD700).withOpacity(0.7),
          ),
          const SizedBox(width: 6),
          Text(
            'Ramadan 1447 Hijri',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.6),
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnterButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: GestureDetector(
        onTap: _navigateToHome,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1B5E20).withOpacity(0.4),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'ENTER',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: 4,
                ),
              ),
              SizedBox(width: 12),
              Icon(
                Icons.arrow_forward_rounded,
                color: Colors.white,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooterText() {
    return Text(
      'Tafseer 2026 • Streaming & Offline Ready',
      style: TextStyle(
        fontSize: 11,
        color: Colors.white.withOpacity(0.3),
        letterSpacing: 1,
      ),
    );
  }

  void _navigateToHome() {
    HapticFeedback.lightImpact();
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const HomeScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }
}

// Custom clipper for crescent moon
class CrescentClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.addOval(Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: size.width / 2,
    ));
    path.addOval(Rect.fromCircle(
      center: Offset(size.width / 2 - 8, size.height / 2 - 4),
      radius: size.width / 2 - 4,
    ));
    path.fillType = PathFillType.evenOdd;
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

// Custom painter for Islamic geometric pattern
class IslamicPatternPainter extends CustomPainter {
  final double progress;
  final double opacity;

  IslamicPatternPainter({
    required this.progress,
    required this.opacity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1B5E20).withOpacity(opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.4;

    // Draw concentric circles
    for (var i = 1; i <= 6; i++) {
      canvas.drawCircle(center, radius * i / 6, paint);
    }

    // Draw rotating pattern elements
    final rotationAngle = progress * 2 * 3.14159;

    for (var i = 0; i < 8; i++) {
      final angle = (i * 3.14159 / 4) + rotationAngle;
      final x = center.dx + radius * 0.8 * cos(angle);
      final y = center.dy + radius * 0.8 * sin(angle);

      // Draw small decorative elements
      final starPath = Path();
      for (var j = 0; j < 6; j++) {
        final starAngle = (j * 3.14159 / 3) + rotationAngle * 0.5;
        final sx = x + 15 * cos(starAngle);
        final sy = y + 15 * sin(starAngle);
        if (j == 0) {
          starPath.moveTo(sx, sy);
        } else {
          starPath.lineTo(sx, sy);
        }
      }
      starPath.close();
      canvas.drawPath(starPath, paint);
    }
  }

  double cos(double angle) => _cos(angle);
  double sin(double angle) => _sin(angle);

  double _cos(double x) {
    return 1 -
        (x * x) / 2 +
        (x * x * x * x) / 24 -
        (x * x * x * x * x * x) / 720;
  }

  double _sin(double x) {
    return x -
        (x * x * x) / 6 +
        (x * x * x * x * x) / 120 -
        (x * x * x * x * x * x * x) / 5040;
  }

  @override
  bool shouldRepaint(IslamicPatternPainter oldDelegate) =>
      oldDelegate.progress != progress;
}