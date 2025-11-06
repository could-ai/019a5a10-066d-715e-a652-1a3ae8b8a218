class GoldPlan {
  final String id;
  final String name;
  final double investmentAmount;
  final double targetAmount;
  final String frequency;
  final String duration;
  final bool autoInvest;
  final DateTime createdAt;
  final double currentAmount;
  final double totalGoldGrams;

  GoldPlan({
    required this.id,
    required this.name,
    required this.investmentAmount,
    required this.targetAmount,
    required this.frequency,
    required this.duration,
    required this.autoInvest,
    required this.createdAt,
    required this.currentAmount,
    required this.totalGoldGrams,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'investmentAmount': investmentAmount,
      'targetAmount': targetAmount,
      'frequency': frequency,
      'duration': duration,
      'autoInvest': autoInvest,
      'createdAt': createdAt.toIso8601String(),
      'currentAmount': currentAmount,
      'totalGoldGrams': totalGoldGrams,
    };
  }

  factory GoldPlan.fromJson(Map<String, dynamic> json) {
    return GoldPlan(
      id: json['id'],
      name: json['name'],
      investmentAmount: json['investmentAmount'].toDouble(),
      targetAmount: json['targetAmount'].toDouble(),
      frequency: json['frequency'],
      duration: json['duration'],
      autoInvest: json['autoInvest'],
      createdAt: DateTime.parse(json['createdAt']),
      currentAmount: json['currentAmount'].toDouble(),
      totalGoldGrams: json['totalGoldGrams'].toDouble(),
    );
  }

  GoldPlan copyWith({
    String? id,
    String? name,
    double? investmentAmount,
    double? targetAmount,
    String? frequency,
    String? duration,
    bool? autoInvest,
    DateTime? createdAt,
    double? currentAmount,
    double? totalGoldGrams,
  }) {
    return GoldPlan(
      id: id ?? this.id,
      name: name ?? this.name,
      investmentAmount: investmentAmount ?? this.investmentAmount,
      targetAmount: targetAmount ?? this.targetAmount,
      frequency: frequency ?? this.frequency,
      duration: duration ?? this.duration,
      autoInvest: autoInvest ?? this.autoInvest,
      createdAt: createdAt ?? this.createdAt,
      currentAmount: currentAmount ?? this.currentAmount,
      totalGoldGrams: totalGoldGrams ?? this.totalGoldGrams,
    );
  }
}