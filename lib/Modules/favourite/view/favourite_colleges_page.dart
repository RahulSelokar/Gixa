import 'package:Gixa/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Gixa/Modules/favourite/controller/fevorite_collage_controller.dart';
import 'package:Gixa/Modules/favourite/model/fevorite_model.dart';

class FavouriteCollegesPage extends StatelessWidget {
  const FavouriteCollegesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final FavouriteCollegeController controller =
        Get.put(FavouriteCollegeController());

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        backgroundColor: theme.colorScheme.surface,
        title: Text(
          "Favourite Colleges",
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const _LoadingView();
        }

        if (controller.favouriteColleges.isEmpty) {
          return const _EmptyStateView();
        }

        return RefreshIndicator(
          onRefresh: controller.loadFavouriteColleges,
          color: theme.colorScheme.primary,
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: controller.favouriteColleges.length,
            separatorBuilder: (_, __) => const SizedBox(height: 14),
            itemBuilder: (context, index) {
              final FavouriteCollege college =
                  controller.favouriteColleges[index];

              return _CollegeCard(
                college: college,
                onToggleFavorite: () =>
                    controller.toggleFavourite(college.id),
              );
            },
          ),
        );
      }),
    );
  }
}

/* ───────────────────────── COLLEGE CARD ───────────────────────── */

class _CollegeCard extends StatelessWidget {
  final FavouriteCollege college;
  final VoidCallback onToggleFavorite;

  const _CollegeCard({
    required this.college,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(18),
        border: isDark
            ? Border.all(color: cs.outlineVariant.withOpacity(0.3))
            : null,
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          // Optional: navigate to college details
          NotificationService.showTestNotification();
        },
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 🏫 ICON / IMAGE PLACEHOLDER
              Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  color: cs.primaryContainer.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.school_rounded,
                  size: 34,
                  color: cs.primary,
                ),
              ),
              const SizedBox(width: 16),

              /// 📄 DETAILS
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// NAME + HEART
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            college.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          visualDensity: VisualDensity.compact,
                          splashRadius: 20,
                          onPressed: onToggleFavorite,
                          icon: const Icon(
                            Icons.favorite_rounded,
                            color: Colors.redAccent,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    /// 🌐 WEBSITE
                    if (college.website.isNotEmpty)
                      Text(
                        college.website,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: cs.primary,
                        ),
                      ),

                    const SizedBox(height: 12),

                    /// 📅 YEAR CHIP
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: cs.secondaryContainer.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "Est. ${college.yearEstablished}",
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: cs.onSecondaryContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* ───────────────────────── EMPTY STATE ───────────────────────── */

class _EmptyStateView extends StatelessWidget {
  const _EmptyStateView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(26),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: cs.primaryContainer.withOpacity(0.4),
              ),
              child: Icon(
                Icons.favorite_border_rounded,
                size: 64,
                color: cs.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              "No Favourites Yet",
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Colleges you mark as favourite\nwill appear here.",
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: cs.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ───────────────────────── LOADING ───────────────────────── */

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(strokeWidth: 3),
    );
  }
}
