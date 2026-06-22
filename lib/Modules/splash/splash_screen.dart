import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import 'package:Gixa/routes/app_start_controller.dart';
import 'package:Gixa/routes/startup_diagnostics.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _videoController;
  late final StartupDiagnostics _startupDiagnostics;
  Timer? _navigationTimer;
  bool _videoInitializationFailed = false;

  @override
  void initState() {
    super.initState();
    _startupDiagnostics = StartupDiagnostics();
    _videoController = VideoPlayerController.asset('assets/videos/client_fev.mp4');
    _initializeVideo();
    _scheduleNavigation();
  }

  Future<void> _initializeVideo() async {
    try {
      await _videoController.initialize();
      await _videoController.setVolume(1.0);
      await _videoController.setLooping(false);

      _startupDiagnostics.mark(StartupPhase.splashVideoInitialized);

      if (!mounted) {
        return;
      }

      setState(() {});
      unawaited(_videoController.play());
    } catch (error, stackTrace) {
      _videoInitializationFailed = true;
      _startupDiagnostics.mark(
        StartupPhase.splashVideoInitializationFailed,
        error: error,
        stackTrace: stackTrace,
      );

      if (mounted) {
        setState(() {});
      }
    }
  }

  void _scheduleNavigation() {
    _navigationTimer = Timer(const Duration(seconds: 7), () {
      _startupDiagnostics.mark(StartupPhase.splashDelayDone);
      unawaited(
        Get.find<AppStartController>().decideNextRoute(
          diagnostics: _startupDiagnostics,
        ),
      );
    });
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          if (_videoController.value.isInitialized) _buildVideoBackground(),
          if (!_videoController.value.isInitialized) _buildStaticBackground(),
          Container(color: Colors.black.withValues(alpha: 0.3)),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'GIXA',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 4,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'AI College Predictor',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                if (_videoInitializationFailed) ...[
                  const SizedBox(height: 16),
                  const Text(
                    'Loading startup experience...',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ],
            ),
          ),
          const Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoBackground() {
    return SizedBox.expand(
      child: FittedBox(
        fit: BoxFit.fill,
        child: SizedBox(
          width: _videoController.value.size.width,
          height: _videoController.value.size.height,
          child: VideoPlayer(_videoController),
        ),
      ),
    );
  }

  Widget _buildStaticBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF161A2B), Color(0xFF0B0F1A)],
        ),
      ),
    );
  }
}
