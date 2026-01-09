import 'package:flutter/material.dart';
import 'package:petcare_planner_frontend/models/reward.dart';
import 'package:petcare_planner_frontend/repository/reward_repository.dart';

class RewardViewModel extends ChangeNotifier {
  final RewardRepository _repository;

  RewardViewModel(this._repository);

  bool isLoading = false;
  String? errorMessage;

  RewardSummary? rewardSummary;
  List<UserBadge> userBadges = [];
  List<Milestone> milestones = [];

  Future<void> fetchAllRewards() async {
    _setLoading(true);
    errorMessage = null;

    try {
      rewardSummary = await _repository.getRewardSummary();
      userBadges = await _repository.getUserBadges();
      milestones = await _repository.getMilestones();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }
}
