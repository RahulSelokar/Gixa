import 'package:Gixa/Modules/faq/model/faq_model.dart';
import 'package:get/get.dart';
import 'package:Gixa/services/faq_api_service.dart';

class FaqController extends GetxController {
  /// Loading State
  var isLoading = false.obs;

  /// FAQ List
  var faqList = <FaqItem>[].obs;

  /// Show More / Less Toggle
  var showAllFaqs = false.obs;

  /// Fetch FAQs
  Future<void> fetchFaqs({String search = ""}) async {
    try {
      isLoading.value = true;

      final response = await FaqApiService.getFaqs(search: search);

      /// Sort by order
      response.sort((a, b) => a.order.compareTo(b.order));

      faqList.value = response;
    } catch (e) {
      print("FAQ ERROR: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Show More / Less
  void toggleFaqs() {
    showAllFaqs.value = !showAllFaqs.value;
  }

  /// Return FAQs for UI
  List<FaqItem> get displayedFaqs {
    return showAllFaqs.value ? faqList : faqList.take(3).toList();
  }

  @override
  void onInit() {
    fetchFaqs();
    super.onInit();
  }
}
