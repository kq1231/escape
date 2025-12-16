import 'package:escape/features/streak/widgets/streak_modal.dart';
import 'package:escape/providers/streak_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../../../theme/app_constants.dart';
import '../widgets/goal_modal.dart';
import '../../../providers/goal_provider.dart';
import '../../../providers/user_profile_provider.dart';
import '../../profile/screens/profile_screen.dart';
import '../../history/screens/streak_history_screen.dart';
import '../../../widgets/xp_badge.dart';
import 'dart:io';

// -----------------------------------------------------------------------------
// MAIN WIDGET
// -----------------------------------------------------------------------------
class StreakOrganism extends ConsumerWidget {
  final String labelText;
  final VoidCallback? onTap;
  final bool isActive;

  const StreakOrganism({super.key, this.labelText = 'Days Clean', this.onTap, this.isActive = true});

  // ------------------------------
  // Goal formatting
  // ------------------------------
  String _getGoalDisplay(int goal) {
    if (goal % 365 == 0) return '${goal ~/ 365}y';
    if (goal % 30 == 0) return '${goal ~/ 30}m';
    if (goal % 7 == 0) return '${goal ~/ 7}w';
    return '$goal';
  }

  // ------------------------------
  // Goal Circle UI
  // ------------------------------
  Widget _buildGoalCircle(BuildContext context, WidgetRef ref) {
    final goal = ref.watch(goalProvider);
    final streakAsync = ref.watch(latestStreakProvider);

    return streakAsync.when(
      data: (streak) {
        final current = streak?.count ?? 0;
        final progress = goal > 0 ? (current / goal).clamp(0.0, 1.0) : 0.0;

        return CircularPercentIndicator(
          radius: 26,
          lineWidth: 4,
          percent: progress,
          progressColor: Colors.white,
          backgroundColor: Colors.white24,
          circularStrokeCap: CircularStrokeCap.round,
          center: Text(
            _getGoalDisplay(goal),
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
          ),
        );
      },
      loading: () =>
          const SizedBox(width: 26, height: 26, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)),
      error: (_, __) => const Icon(Icons.flag, color: Colors.white),
    );
  }

  // ------------------------------
  // Profile section
  // ------------------------------
  Widget _buildProfileSection(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);

    return profileAsync.when(
      data: (user) {
        final hasXP = user?.xp != null ? user!.xp > 0 : false;
        final hasPicture = user?.profilePicture.isNotEmpty ?? false;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Salam, Mohamed 👋",
              style: TextStyle(fontFamily: 'Exo', color: Colors.black, fontWeight: FontWeight.w600, fontSize: 24),
            ),
            GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen())),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  hasPicture
                      ? CircleAvatar(radius: 32, backgroundImage: FileImage(File(user!.profilePicture)))
                      : const CircleAvatar(
                          radius: 32,
                          backgroundColor: Colors.black12,
                          child: Icon(Icons.person, size: 30),
                        ),
                  if (hasXP)
                    Positioned(
                      bottom: -6,
                      right: -3,
                      child: XPBadge(
                        xpAmount: user.xp,
                        backgroundColor: Colors.amber,
                        textColor: Colors.black,
                        fontSize: 11,
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        isTotal: true,
                      ),
                    ),
                ],
              ),
            ),
          ],
        );
      },
      loading: () => const CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
      error: (_, __) => const SizedBox(),
    );
  }

  // ------------------------------
  // Page 1 — Streak
  // ------------------------------
  Widget _pageStreak(BuildContext context, int streak) {
    return GestureDetector(
      onTap: () => showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (_) => const StreakModal(),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Image.asset('assets/flame_icon.png', width: 80, height: 80),
              Text(
                "$streak",
                style: const TextStyle(
                  fontSize: 40,
                  fontFamily: 'Exo',
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  height: 1.0,
                ),
              ),
              const SizedBox(width: 6),
            ],
          ),
          Text(
            "Days Clean",
            style: TextStyle(fontSize: 18, fontFamily: 'Exo', color: Colors.white70, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  // ------------------------------
  // Page 2 — History
  // ------------------------------
  Widget _pageHistory(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const StreakHistoryScreen())),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history_rounded, size: 36, color: Colors.white),
            SizedBox(height: 8),
            Text("History", style: TextStyle(color: Colors.white, fontSize: 17)),
          ],
        ),
      ),
    );
  }

  // ------------------------------
  // Page 3 — Goal
  // ------------------------------
  Widget _pageGoal(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (_) => const GoalModal(),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildGoalCircle(context, ref),
          const SizedBox(height: 8),
          const Text("Your Goal", style: TextStyle(color: Colors.white, fontSize: 17)),
        ],
      ),
    );
  }

  // ------------------------------
  // Left Card Widget
  // ------------------------------
  // Widget _buildLeftCard(BuildContext context) {
  //   return Container(
  //     width: 180,
  //     height: 140,
  //     padding: const EdgeInsets.all(16),
  //     decoration: BoxDecoration(
  //       gradient: LinearGradient(
  //         colors: [AppConstants.primaryGreen, AppConstants.primaryGreen.withOpacity(0.8)],
  //         begin: Alignment.topLeft,
  //         end: Alignment.bottomRight,
  //       ),
  //       borderRadius: BorderRadius.circular(22),
  //       boxShadow: [
  //         BoxShadow(color: AppConstants.primaryGreen.withOpacity(0.25), blurRadius: 16, offset: const Offset(0, 6)),
  //       ],
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Row(
  //           children: [
  //             Container(
  //               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  //               decoration: BoxDecoration(
  //                 color: Colors.white.withOpacity(0.2),
  //                 borderRadius: BorderRadius.circular(12),
  //               ),
  //               child: const Text(
  //                 "Next",
  //                 style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
  //               ),
                
  //             ),
  //                                SizedBox(width: 15),

  //             Text(
  //               "Dohr ☀️ ",
  //               style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700, fontFamily: 'Exo'),
  //             ),
  //           ],
  //         ),

  //         const Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Row(
  //               children: [
  //                 Text(
  //                   "See",
  //                   style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w700, fontFamily: 'Exo'),
  //                 ),
  //                 const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20),
  //               ],
  //             ),
  // Text(
  //                   "🇩🇿 Annaba",
  //                   style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700, fontFamily: 'Exo'),
  //                 ),
  //             Row(
  //               children: [
  //                 Icon(Icons.access_time, color: Colors.white70, size: 10),
  //                 SizedBox(width: 4),
  //                 Text(
  //                   "in 3h 45m",
  //                   style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.w500),
  //                 ),
  //               ],
  //             ),
  //           ],
  //         ),

      
  //       ],
  //     ),
  //   );
  // }

  // ------------------------------
  // BUILD
  // ------------------------------
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streakAsync = ref.watch(latestStreakProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding: const EdgeInsets.only(left: 8.0, bottom: 16), child: _buildProfileSection(context, ref)),

        streakAsync.when(
          loading: () => const Center(child: CircularProgressIndicator(color: Colors.green)),
          error: (_, _) => const Text("Error"),
          data: (streak) {
            final count = streak?.count ?? 0;

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // _buildLeftCard(context),
                Container(
                  width: 300,
                  height: 140,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppConstants.primaryGreen, AppConstants.lightGreen],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: AppConstants.primaryGreen.withOpacity(0.25),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: _InternalVerticalPager(
                    pages: [_pageStreak(context, count), _pageHistory(context), _pageGoal(context, ref)],
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// INTERNAL PAGER with SMALL ANIMATED DOTS
// -----------------------------------------------------------------------------
class _InternalVerticalPager extends StatefulWidget {
  final List<Widget> pages;
  const _InternalVerticalPager({required this.pages});

  @override
  State<_InternalVerticalPager> createState() => _InternalVerticalPagerState();
}

class _InternalVerticalPagerState extends State<_InternalVerticalPager> {
  final PageController controller = PageController();
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView.builder(
          controller: controller,
          scrollDirection: Axis.vertical,
          itemCount: widget.pages.length,
          onPageChanged: (i) => setState(() => index = i),
          itemBuilder: (_, i) => widget.pages[i],
        ),

        // ------------------------------
        // RIGHT SIDE SMALL ANIMATED DOTS
        // ------------------------------
        Positioned(
          right: 4,
          top: 0,
          bottom: 0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.pages.length, (i) {
              final isActive = i == index;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOut,
                width: isActive ? 9 : 7,
                height: isActive ? 9 : 7,
                margin: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  color: isActive ? Colors.white : Colors.white.withOpacity(0.28),
                  shape: BoxShape.circle,
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
