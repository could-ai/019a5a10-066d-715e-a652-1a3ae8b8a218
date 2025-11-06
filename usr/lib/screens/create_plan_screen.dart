import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/gold_plan.dart';
import '../services/plan_service.dart';

class CreatePlanScreen extends StatefulWidget {
  const CreatePlanScreen({super.key});

  @override
  State<CreatePlanScreen> createState() => _CreatePlanScreenState();
}

class _CreatePlanScreenState extends State<CreatePlanScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _targetController = TextEditingController();
  
  String _frequency = 'Monthly';
  String _duration = '12 months';
  bool _autoInvest = true;

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _targetController.dispose();
    super.dispose();
  }

  void _createPlan() {
    if (_formKey.currentState!.validate()) {
      final plan = GoldPlan(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        investmentAmount: double.parse(_amountController.text),
        targetAmount: _targetController.text.isEmpty ? 0 : double.parse(_targetController.text),
        frequency: _frequency,
        duration: _duration,
        autoInvest: _autoInvest,
        createdAt: DateTime.now(),
        currentAmount: 0,
        totalGoldGrams: 0,
      );

      PlanService().addPlan(plan);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gold buying plan created successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Gold Plan',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Plan Details',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Plan Name',
                hintText: 'e.g., Retirement Gold Fund',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.label),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a plan name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _amountController,
              decoration: const InputDecoration(
                labelText: 'Investment Amount',
                hintText: 'e.g., 5000',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.currency_rupee),
                suffixText: '₹',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter investment amount';
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _targetController,
              decoration: const InputDecoration(
                labelText: 'Target Amount (Optional)',
                hintText: 'e.g., 100000',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.track_changes),
                suffixText: '₹',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const SizedBox(height: 24),
            Text(
              'Investment Frequency',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _frequency,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.schedule),
              ),
              items: ['Daily', 'Weekly', 'Monthly', 'Quarterly']
                  .map((freq) => DropdownMenuItem(
                        value: freq,
                        child: Text(freq),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _frequency = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            Text(
              'Investment Duration',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _duration,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.calendar_today),
              ),
              items: [
                '6 months',
                '12 months',
                '24 months',
                '36 months',
                '60 months'
              ]
                  .map((dur) => DropdownMenuItem(
                        value: dur,
                        child: Text(dur),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _duration = value!;
                });
              },
            ),
            const SizedBox(height: 24),
            Card(
              child: SwitchListTile(
                title: const Text('Auto-Invest',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                subtitle: const Text(
                    'Automatically invest on schedule'),
                value: _autoInvest,
                activeColor: const Color(0xFFFFD700),
                onChanged: (value) {
                  setState(() {
                    _autoInvest = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 24),
            Card(
              color: Colors.blue[50],
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.lightbulb, color: Colors.blue),
                        const SizedBox(width: 8),
                        Text(
                          'Plan Summary',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.blue[900],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'You will invest ₹${_amountController.text.isEmpty ? '0' : _amountController.text} ${_frequency.toLowerCase()}',
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Duration: $_duration',
                      style: const TextStyle(fontSize: 14),
                    ),
                    if (_targetController.text.isNotEmpty) ..[
                      const SizedBox(height: 4),
                      Text(
                        'Target: ₹${_targetController.text}',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _createPlan,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFD700),
                foregroundColor: Colors.black87,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Create Plan',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}