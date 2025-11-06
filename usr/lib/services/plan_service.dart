import 'dart:async';
import '../models/gold_plan.dart';

class PlanService {
  static final PlanService _instance = PlanService._internal();
  factory PlanService() => _instance;
  PlanService._internal();

  final List<GoldPlan> _plans = [];
  final StreamController<List<GoldPlan>> _plansController =
      StreamController<List<GoldPlan>>.broadcast();

  Stream<List<GoldPlan>> getPlansStream() {
    return _plansController.stream;
  }

  List<GoldPlan> getPlans() {
    return List.unmodifiable(_plans);
  }

  void addPlan(GoldPlan plan) {
    _plans.add(plan);
    _notifyListeners();
  }

  void updatePlan(GoldPlan updatedPlan) {
    final index = _plans.indexWhere((p) => p.id == updatedPlan.id);
    if (index != -1) {
      _plans[index] = updatedPlan;
      _notifyListeners();
    }
  }

  void deletePlan(String id) {
    _plans.removeWhere((p) => p.id == id);
    _notifyListeners();
  }

  GoldPlan? getPlanById(String id) {
    try {
      return _plans.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  void _notifyListeners() {
    _plansController.add(List.unmodifiable(_plans));
  }

  void dispose() {
    _plansController.close();
  }
}