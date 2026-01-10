// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:petcare_planner_frontend/repository/reward_repository.dart';
import 'package:petcare_planner_frontend/services/reward_service.dart';
import 'package:petcare_planner_frontend/view_models/reward_view_model.dart';
import 'package:provider/provider.dart';
import 'package:petcare_planner_frontend/utils/app_colors.dart';
import 'package:share_plus/share_plus.dart';

class Rewards extends StatelessWidget {
  const Rewards({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RewardViewModel>(
      create: (_) {
        final rewardService = RewardService();
        final rewardRepository = RewardRepository(rewardService);
        final viewModel = RewardViewModel(rewardRepository);
        viewModel.fetchAllRewards();
        return viewModel;
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Consumer<RewardViewModel>(
            builder: (context, vm, _) {
              if (vm.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (vm.errorMessage != null) {
                return Center(child: Text('Error: ${vm.errorMessage}'));
              }

              final summary = vm.rewardSummary;
              final badges = vm.userBadges;
              final milestones = vm.milestones;

              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Rewards",
                          style: TextStyle(
                            fontFamily: "Poppins-Bold",
                            fontSize: 24,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x20000000),
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.share,
                              color: AppColors.primary,
                            ),
                            onPressed: () {
                              final badgeCount = summary?.totalBadges ?? 0;
                              final unlockedCount = summary?.unlocked ?? 0;
                              final milestonesCount = milestones.length;

                              final shareText =
                                  '''
                              My PetCare Achievements:

                              Total Badges: $badgeCount
                              Unlocked Badges: $unlockedCount
                              Milestones Achieved: $milestonesCount

                              Join me on this pet care journey!
                              ''';

                              Share.share(shareText);
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),

                    // Progress Card
                    Center(
                      child: SizedBox(
                        width: 330,
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(25),
                                blurRadius: 24,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Your Progress",
                                style: TextStyle(
                                  fontFamily: "Poppins-Medium",
                                  color: AppColors.textSecondary,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildStatItem(
                                    '${summary?.totalBadges ?? 0}',
                                    "Total Badges",
                                  ),
                                  _buildStatItem(
                                    '${summary?.unlocked ?? 0}',
                                    "Unlocked",
                                  ),
                                  _buildStatItem(
                                    '${summary?.toUnlock ?? 0}',
                                    "To Unlock",
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Your Badges Section
                    SizedBox(
                      width: 330,
                      child: Text(
                        "Your Badges",
                        style: TextStyle(
                          fontFamily: "Poppins-SemiBold",
                          fontSize: 18,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    badges.isEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Text(
                                "No badges earned yet.",
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  color: AppColors.textPrimary,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          )
                        : Column(
                            children: badges.map((badge) {
                              return Center(
                                child: SizedBox(
                                  width: 330,
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 18,
                                    ),
                                    margin: const EdgeInsets.only(bottom: 16),
                                    decoration: BoxDecoration(
                                      color: AppColors.white,
                                      borderRadius: BorderRadius.circular(24),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withAlpha(25),
                                          blurRadius: 24,
                                          offset: const Offset(0, 8),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          height: 72,
                                          width: 72,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: AppColors.primary,
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(
                                                  0.098,
                                                ),
                                                blurRadius: 16,
                                                offset: const Offset(0, 6),
                                              ),
                                            ],
                                          ),
                                          child: Text(
                                            badge.icon,
                                            style: const TextStyle(
                                              fontSize: 40,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          badge.title,
                                          style: TextStyle(
                                            fontFamily: "Poppins-Medium",
                                            fontSize: 13,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          badge.unlockedAt
                                              .toLocal()
                                              .toIso8601String()
                                              .split('T')[0],
                                          style: TextStyle(
                                            fontFamily: "Poppins",
                                            color: AppColors.textPrimary,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),

                    const SizedBox(height: 8),

                    // Milestones Section
                    Text(
                      "Milestones",
                      style: TextStyle(
                        fontFamily: "Poppins-SemiBold",
                        fontSize: 18,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),

                    milestones.isEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Text(
                                "No milestones achieved yet.",
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  color: AppColors.textPrimary,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          )
                        : Column(
                            children: milestones.map((m) {
                              return Center(
                                child: SizedBox(
                                  width: 330,
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    margin: const EdgeInsets.only(bottom: 16),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(24),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withAlpha(25),
                                          blurRadius: 12,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 56,
                                          width: 56,
                                          decoration: BoxDecoration(
                                            color: AppColors.primary,
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(
                                                  0.098,
                                                ),
                                                blurRadius: 16,
                                                offset: const Offset(0, 6),
                                              ),
                                            ],
                                          ),
                                          child: const Icon(
                                            Icons.pets,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                m.title,
                                                style: TextStyle(
                                                  fontFamily: "Poppins-Bold",
                                                  fontSize: 16,
                                                  color: AppColors.textPrimary,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                m.description,
                                                style: TextStyle(
                                                  fontFamily: "Poppins",
                                                  color: AppColors.textPrimary,
                                                  fontSize: 13,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                m.achievedAt
                                                    .toLocal()
                                                    .toIso8601String()
                                                    .split('T')[0],
                                                style: TextStyle(
                                                  fontFamily: "Poppins",
                                                  color: AppColors.textPrimary,
                                                  fontSize: 12,
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
                            }).toList(),
                          ),

                    const SizedBox(height: 20),

                    // Share Button
                    Center(
                      child: SizedBox(
                        width: 330,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: () {
                            final badgeCount = summary?.totalBadges ?? 0;
                            final unlockedCount = summary?.unlocked ?? 0;
                            final milestonesCount = milestones.length;

                            final shareText =
                                '''
                            My PetCare Achievements:

                            Total Badges: $badgeCount
                            Unlocked Badges: $unlockedCount
                            Milestones Achieved: $milestonesCount

                            Join me on this pet care journey!
                            ''';

                            Share.share(shareText);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.share, color: AppColors.textSecondary),
                              SizedBox(width: 10),
                              Text(
                                "Share My Achievements",
                                style: TextStyle(
                                  fontFamily: "Poppins-Medium",
                                  color: AppColors.textSecondary,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // Helper for Stats inside the Green Card
  Widget _buildStatItem(String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(
            fontFamily: "Poppins-Bold",
            color: AppColors.textSecondary,
            fontSize: 28,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontFamily: "Poppins",
            color: AppColors.textSecondary,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
