import 'package:flutter/material.dart';

import '../main.dart';
import 'login.dart';

/// Halaman pembuka: blob navy + logo daun, lalu tombol menuju login.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final blob = size.height * 0.42;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SizedBox(
          height: size.height,
          child: Column(
            children: [
              SizedBox(
                height: blob + 54,
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.topCenter,
                  children: [
                    Container(
                      height: blob,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.navy,
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.elliptical(size.width / 2, 92),
                        ),
                      ),
                    ),
                    Positioned(
                      top: blob - 52,
                      child: Container(
                        width: 104,
                        height: 104,
                        padding: const EdgeInsets.all(24),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset('assets/images/logo_mark.png'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 26),
              Text(
                'Leafboard',
                style: serifStyle(size: 40, letterSpacing: -0.5),
              ),
              const SizedBox(height: 14),
              const Text(
                'A platform built for a new way of working',
                style: TextStyle(fontSize: 12.5, color: AppColors.muted),
              ),
              const Spacer(),
              PillButton(
                label: 'Get Started for Free',
                height: 40,
                width: 172,
                fontSize: 11.5,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                ),
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}
