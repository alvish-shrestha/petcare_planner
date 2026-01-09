import 'package:petcare_planner_frontend/models/reward.dart';
import 'package:petcare_planner_frontend/services/reward_service.dart';

class RewardRepository {
  final RewardService _rewardService;

  RewardRepository(this._rewardService);

  Future<RewardSummary> getRewardSummary() async {
    final response = await _rewardService.fetchRewardSummary();
    if (response['success'] == true) {
      return RewardSummary.fromJson(response['data']);
    } else {
      throw Exception(response['message'] ?? 'Failed to get reward summary');
    }
  }

  Future<List<UserBadge>> getUserBadges() async {
    final response = await _rewardService.fetchUserBadges();
    if (response['success'] == true) {
      final badgesJson = response['data'] as List;
      return badgesJson.map((e) => UserBadge.fromJson(e)).toList();
    } else {
      throw Exception(response['message'] ?? 'Failed to get user badges');
    }
  }

  Future<List<Milestone>> getMilestones() async {
    final response = await _rewardService.fetchMilestones();
    if (response['success'] == true) {
      final milestonesJson = response['data'] as List;
      return milestonesJson.map((e) => Milestone.fromJson(e)).toList();
    } else {
      throw Exception(response['message'] ?? 'Failed to get milestones');
    }
  }
}
