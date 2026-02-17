import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DataStoragePage extends StatelessWidget {
  const DataStoragePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF121212) : const Color(0xFFF6F7FB);
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text("Data & Storage"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: bgColor,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [

          /// STORAGE USAGE CARD
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Storage Usage",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 16),

                _storageRow("App Size", "45 MB"),
                _storageRow("Cache", "12 MB"),
                _storageRow("Downloads", "30 MB"),

                const SizedBox(height: 16),

                LinearProgressIndicator(
                  value: 0.4,
                  minHeight: 6,
                  borderRadius: BorderRadius.circular(10),
                ),

                const SizedBox(height: 8),
                const Text("87 MB Used"),
              ],
            ),
          ),

          const SizedBox(height: 30),

          /// DATA SETTINGS
          const Text(
            "Data Usage",
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey),
          ),

          const SizedBox(height: 12),

          _settingTile(
            icon: Icons.data_usage_outlined,
            title: "Use Less Data",
            subtitle: "Reduce image & video quality",
            trailing: Switch(value: true, onChanged: (v) {}),
          ),

          _settingTile(
            icon: Icons.download_outlined,
            title: "Auto Download on Wi-Fi",
            subtitle: "Download updates automatically",
            trailing: Switch(value: false, onChanged: (v) {}),
          ),

          const SizedBox(height: 30),

          /// ACTIONS
          const Text(
            "Manage Storage",
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey),
          ),

          const SizedBox(height: 12),

          _actionTile(
            icon: Icons.cleaning_services_outlined,
            title: "Clear Cache",
            color: Colors.orange,
            onTap: () {
              Get.snackbar("Success", "Cache cleared");
            },
          ),

          _actionTile(
            icon: Icons.delete_outline,
            title: "Clear All Data",
            color: Colors.red,
            onTap: () {
              Get.snackbar("Warning", "All data cleared");
            },
          ),
        ],
      ),
    );
  }

  Widget _storageRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _settingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget trailing,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle),
      trailing: trailing,
    );
  }

  Widget _actionTile({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: TextStyle(
            fontWeight: FontWeight.w600, color: color),
      ),
      onTap: onTap,
    );
  }
}
