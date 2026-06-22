import 'package:Gixa/Modules/faq/model/faq_model.dart';
import 'package:Gixa/services/faq_api_service.dart';
import 'package:get/get.dart';

class FaqController extends GetxController {
  var isLoading = false.obs;
  var faqList = <FaqItem>[].obs;
  var showAllFaqs = false.obs;

  Future<void> fetchFaqs({
    String search = "",
    bool forceRefresh = false,
  }) async {
    try {
      isLoading.value = true;

      final response = await FaqApiService.getFaqs(
        search: search,
        forceRefresh: forceRefresh,
      );

      response.sort((a, b) => a.order.compareTo(b.order));
      faqList.value = response;
    } catch (e) {
      print("FAQ ERROR: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void toggleFaqs() {
    showAllFaqs.value = !showAllFaqs.value;
  }

  List<FaqItem> get displayedFaqs {
    return showAllFaqs.value ? faqList : faqList.take(3).toList();
  }
}
