import 'package:Gixa/common/Error/error_controller.dart';
import 'package:Gixa/common/widgets/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NetworkErrorScreen extends StatelessWidget {
  const NetworkErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final errorController = Get.find<GlobalErrorController>();
    final title = errorController.errorMessage == "Unable to reach the server"
        ? "Unable to Reach Server"
        : "No Internet Connection";
    final subtitle = errorController.errorMessage == "Unable to reach the server"
        ? "The app could not reach the API server. This can happen on some Wi-Fi networks when the server only supports HTTP."
        : "Please check your internet connection and try again.";

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/images/network_error.png", height: 220),

                const SizedBox(height: 30),

                Text(
                  title,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 12),
 
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      await errorController.refreshConnectionStatus();

                      if (errorController.hasError) {
                        AppSnackbar.show(
                          "Still Offline",
                          errorController.errorMessage.isNotEmpty
                              ? errorController.errorMessage
                              : "Still offline. Please check your internet connection.",
                        );
                        return;
                      }

                      errorController.hideError();
                    },
                    child: const Text("Retry"),
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
