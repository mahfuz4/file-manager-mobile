// lib/screens/auth_wrapper.dart
// Listens to Firebase auth state and routes to Login or FileManager.

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/file_manager_provider.dart';
import '../providers/pin_provider.dart';
import 'package:provider/provider.dart';
import 'login_screen.dart';
import 'file_manager_screen.dart';
import 'pin_verification_screen.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> with WidgetsBindingObserver {
  DateTime? _backgroundTime;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PinProvider>().init();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final pinProvider = context.read<PinProvider>();
    if (state == AppLifecycleState.paused) {
      _backgroundTime = DateTime.now();
    } else if (state == AppLifecycleState.resumed) {
      if (_backgroundTime != null) {
        final elapsed = DateTime.now().difference(_backgroundTime!);
        if (elapsed.inSeconds > 30 && pinProvider.isPinSet) {
          pinProvider.lockApp();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const _SplashScreen();
        }

        if (snapshot.hasData && snapshot.data != null) {
          return Consumer<PinProvider>(
            builder: (context, pinProvider, _) {
              if (pinProvider.isAppLocked) {
                return FutureBuilder(
                  future: _showPinVerification(context),
                  builder: (context, _) => const _SplashScreen(),
                );
              }

              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.read<FileManagerProvider>().refresh();
              });
              return const FileManagerScreen();
            },
          );
        }

        return const LoginScreen();
      },
    );
  }

  Future<void> _showPinVerification(BuildContext context) async {
    await Future.delayed(Duration.zero);
    if (!context.mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider.value(
          value: context.read<PinProvider>(),
          child: const PinVerificationScreen(),
        ),
        fullscreenDialog: true,
      ),
    );
  }
}

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF0A0A0A),
      body: Center(
        child: CircularProgressIndicator(
          color: Color(0xFFF97316),
          strokeWidth: 2,
        ),
      ),
    );
  }
}