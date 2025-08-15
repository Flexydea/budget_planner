import 'package:flutter/material.dart';
import 'package:budget_planner/data/services/prefs_service.dart';

import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreen();
}

class _SplashScreen extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController
  _controller; // what drives the lottie animation

  @override
  void initState() {
    super.initState();

    //attaching a controller so we know when an animation finishes

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _controller.addStatusListener((status) async {
      if (status == AnimationStatus.completed && mounted) {
        // defer to next frame so router context is ready
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          if (!mounted) return;
          final onboarded = await PrefsService.hasOnboarded; // NEW
          // route based on flag (auth check later)
          if (!mounted) return;
          // context.go(onboarded ? '/auth/login' : '/onboarding');
          context.go('/');
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // frees resources
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //fintech background style tweek
    final bg = Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF0F1115)
        : const Color(0xFFF5F7FA);

    return Scaffold(
      backgroundColor: bg,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //lottie animation
            Lottie.asset(
              'assets/animations/splash.json',
              controller: _controller,
              onLoaded: (comp) {
                //play once at intended speed
                _controller
                  ..duration
                  ..forward();
              },
              width: 220,
              height: 220,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
