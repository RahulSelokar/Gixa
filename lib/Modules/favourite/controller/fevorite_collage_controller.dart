import 'package:Gixa/Modules/favourite/model/fevorite_model.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:Gixa/Modules/Collage/model/collage_model.dart';
import 'package:Gixa/services/favourite_college_service.dart';

class FavouriteCollegeController extends GetxController {
  final RxList<FavouriteCollege> favouriteColleges = <FavouriteCollege>[].obs;
  final RxSet<int> _favouriteIds = <int>{}.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadFavouriteColleges();
  }

  Future<void> loadFavouriteColleges() async {
    try {
      isLoading(true);

      final list =
          await FavouriteCollegeService.getFavouriteColleges();

      favouriteColleges.assignAll(list);
      _favouriteIds.assignAll(list.map((e) => e.id));
    } catch (e, s) {
      debugPrint('❌ Favourite load error: $e');
      debugPrintStack(stackTrace: s);
    } finally {
      isLoading(false);
    }
  }

  bool isFavourite(int collegeId) => _favouriteIds.contains(collegeId);

  Future<void> toggleFavourite(int collegeId) async {
    final wasFav = isFavourite(collegeId);

    // optimistic UI
    wasFav
        ? _favouriteIds.remove(collegeId)
        : _favouriteIds.add(collegeId);

    try {
      if (wasFav) {
        await FavouriteCollegeService.removeFromFavourite(collegeId);
        favouriteColleges.removeWhere((e) => e.id == collegeId);
      } else {
        await FavouriteCollegeService.addToFavourite(collegeId);
        await loadFavouriteColleges(); // backend = source of truth
      }
    } catch (e) {
      // rollback
      wasFav
          ? _favouriteIds.add(collegeId)
          : _favouriteIds.remove(collegeId);
    }
  }
}
