import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/gold_plan.dart';
import '../services/plan_service.dart';

class PlanDetailsScreen extends StatefulWidget {
  final GoldPlan plan;

  const PlanDetailsScreen({super.key, required this.plan});

  @override
  State<PlanDetailsScreen> createState() => _PlanDetailsScreenState();
}

class _PlanDetailsScreenState extends State<PlanDetailsScreen> {
  final PlanService _planService = PlanService();
  final _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _showAddInvestmentDialog() {
    _amountController.clear();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Investment'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(
                labelText: 'Amount',
                prefixIcon: Icon(Icons.currency_rupee),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const SizedBox(height: 12),
            Text(
              'Current gold price: ₹6,200/gram',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final amount = double.tryParse(_amountController.text);
              if (amount != null && amount > 0) {
                // Simulate gold purchase at current price
                const goldPrice = 6200.0;
                final grams = amount / goldPrice;
                
                final updatedPlan = GoldPlan(
                  id: widget.plan.id,
                  name: widget.plan.name,
                  investmentAmount: widget.plan.investmentAmount,
                  targetAmount: widget.plan.targetAmount,
                  frequency: widget.plan.frequency,
                  duration: widget.plan.duration,
                  autoInvest: widget.plan.autoInvest,
                  createdAt: widget.plan.createdAt,
                  currentAmount: widget.plan.currentAmount + amount,
                  totalGoldGrams: widget.plan.totalGoldGrams + grams,
                );

                _planService.updatePlan(updatedPlan);

                Navigator.pop(context);
                setState(() {});

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Added ₹${amount.toStringAsFixed(0)} - ${grams.toStringAsFixed(3)}g gold'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFD700),
              foregroundColor: Colors.black87,
            ),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final progress = widget.plan.targetAmount > 0
        ? (widget.plan.currentAmount / widget.plan.targetAmount * 100)
            .clamp(0, 100)
        : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.plan.name,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // TODO: Edit plan
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: const Color(0xFFFFD700).withOpacity(0.1),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Icon(
                    Icons.account_balance_wallet,
                    size: 60,
                    color: Color(0xFFFFD700),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Total Investment',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '₹${widget.plan.currentAmount.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.scale, size: 20, color: Color(0xFFFFD700)),
                      const SizedBox(width: 8),
                      Text(
                        '${widget.plan.totalGoldGrams.toStringAsFixed(3)} grams',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          if (widget.plan.targetAmount > 0) ..[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Target Progress',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${progress.toStringAsFixed(1)}%',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFFD700),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: progress / 100,
                        minHeight: 12,
                        backgroundColor: Colors.grey[200],
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFFFFD700),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Current: ₹${widget.plan.currentAmount.toStringAsFixed(0)}',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        Text(
                          'Target: ₹${widget.plan.targetAmount.toStringAsFixed(0)}',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
          Text(
            'Plan Details',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          _DetailCard(
            icon: Icons.currency_rupee,
            title: 'Investment Amount',
            value: '₹${widget.plan.investmentAmount.toStringAsFixed(0)}',
          ),
          _DetailCard(
            icon: Icons.schedule,
            title: 'Frequency',
            value: widget.plan.frequency,
          ),
          _DetailCard(
            icon: Icons.calendar_today,
            title: 'Duration',
            value: widget.plan.duration,
          ),
          _DetailCard(
            icon: Icons.date_range,
            title: 'Started On',
            value:
                '${widget.plan.createdAt.day}/${widget.plan.createdAt.month}/${widget.plan.createdAt.year}',
          ),
          _DetailCard(
            icon: widget.plan.autoInvest
                ? Icons.check_circle
                : Icons.cancel,
            title: 'Auto-Invest',
            value: widget.plan.autoInvest ? 'Enabled' : 'Disabled',
            valueColor:
                widget.plan.autoInvest ? Colors.green : Colors.red,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _showAddInvestmentDialog,
            icon: const Icon(Icons.add_circle),
            label: const Text('Add Investment'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFD700),
              foregroundColor: Colors.black87,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color? valueColor;

  const _DetailCard({
    required this.icon,
    required this.title,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFFFD700).withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: const Color(0xFFFFD700)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: valueColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}