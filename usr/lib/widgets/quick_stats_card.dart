import 'package:flutter/material.dart';
import '../services/plan_service.dart';

class QuickStatsCard extends StatelessWidget {
  const QuickStatsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: PlanService().getPlansStream(),
      builder: (context, snapshot) {
        final plans = snapshot.data ?? [];
        
        final totalInvested = plans.fold<double>(
          0,
          (sum, plan) => sum + plan.currentAmount,
        );
        
        final totalGold = plans.fold<double>(
          0,
          (sum, plan) => sum + plan.totalGoldGrams,
        );
        
        final activePlans = plans.length;

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Portfolio',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _StatItem(
                        icon: Icons.account_balance_wallet,
                        label: 'Total Invested',
                        value: '₹${totalInvested.toStringAsFixed(0)}',
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatItem(
                        icon: Icons.scale,
                        label: 'Gold Owned',
                        value: '${totalGold.toStringAsFixed(2)}g',
                        color: const Color(0xFFFFD700),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _StatItem(
                  icon: Icons.list_alt,
                  label: 'Active Plans',
                  value: activePlans.toString(),
                  color: Colors.green,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}