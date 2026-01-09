class RewardSummary {
  final int totalBadges;
  final int unlocked;
  final int toUnlock;

  RewardSummary({
    required this.totalBadges,
    required this.unlocked,
    required this.toUnlock,
  });

  factory RewardSummary.fromJson(Map<String, dynamic> json) {
    return RewardSummary(
      totalBadges: json['totalBadges'],
      unlocked: json['unlocked'],
      toUnlock: json['toUnlock'],
    );
  }
}

class UserBadge {
  final String id;
  final String title;
  final String icon;
  final String description;
  final DateTime unlockedAt;

  UserBadge({
    required this.id,
    required this.title,
    required this.icon,
    required this.description,
    required this.unlockedAt,
  });

  factory UserBadge.fromJson(Map<String, dynamic> json) {
    return UserBadge(
      id: json['_id'],
      title: json['badgeId']['title'],
      icon: json['badgeId']['icon'],
      description: json['badgeId']['description'] ?? '',
      unlockedAt: DateTime.parse(json['unlockedAt']),
    );
  }
}

class Milestone {
  final String id;
  final String title;
  final String description;
  final DateTime achievedAt;

  Milestone({
    required this.id,
    required this.title,
    required this.description,
    required this.achievedAt,
  });

  factory Milestone.fromJson(Map<String, dynamic> json) {
    return Milestone(
      id: json['_id'],
      title: json['title'],
      description: json['description'] ?? '',
      achievedAt: DateTime.parse(json['achievedAt']),
    );
  }
}
