import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  String version = '';
  String buildNumber = '';

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();

    setState(() {
      version = packageInfo.version;
      buildNumber = packageInfo.buildNumber;
    });
  }

  Future<void> _openUrl(String url) async {
    final Uri uri = Uri.parse(url);

    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor =
        isDark ? const Color(0xFF121212) : const Color(0xFFF6F7FB);
    final cardColor =
        isDark ? const Color(0xFF1E1E1E) : Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text("About"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: bgColor,
        foregroundColor: isDark ? Colors.white : Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              if (!isDark)
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// App Logo
              CircleAvatar(
                radius: 45,
                backgroundColor: Colors.blue.withOpacity(0.1),
                child: const Icon(
                  Icons.school,
                  size: 45,
                  color: Colors.blue,
                ),
              ),

              const SizedBox(height: 16),

              /// App Name
              const Text(
                "Gixa",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              /// Version
              Text(
                "Version $version ($buildNumber)",
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 24),

              /// Description
              const Text(
                "Gixa is a smart education platform designed to help students discover colleges, compare institutions, analyze cutoffs, and make informed academic decisions. "
                "With powerful insights and easy-to-use tools, Gixa simplifies the college selection journey.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, height: 1.6),
              ),

              const SizedBox(height: 30),

              const Divider(),

              const SizedBox(height: 10),

              /// Terms & Conditions
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text("Terms & Conditions"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => _openUrl("https://gixa.in/terms-conditions/"),
              ),

              /// Privacy Policy
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text("Privacy Policy"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => _openUrl("https://gixa.in/privacy-policy/"),
              ),

              const SizedBox(height: 10),

              const Divider(),

              const SizedBox(height: 10),

              /// Footer
              const Text(
                "© 2026 Gixa. All rights reserved.",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}