import 'package:flutter/material.dart';

import '../../services/water_intake_service.dart';

class WaterIntakeScreen extends StatefulWidget {
  const WaterIntakeScreen({
    super.key,
  });

  @override
  State<WaterIntakeScreen> createState() =>
      _WaterIntakeScreenState();
}

class _WaterIntakeScreenState
    extends State<WaterIntakeScreen> {
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await WaterIntakeService.initialize();

    if (!mounted) {
      return;
    }

    setState(() {
      _loading = false;
    });
  }

  Future<void> _addWater(int amountMl) async {
    final added =
        await WaterIntakeService.addWater(amountMl);

    if (!mounted || !added) {
      return;
    }

    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF111C31),
        content: Text(
          '${_formatMl(amountMl)} added',
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  Future<void> _showCustomAmount() async {
    final amount = await showDialog<int>(
      context: context,
      builder: (_) => const _CustomWaterDialog(),
    );

    if (amount == null) {
      return;
    }

    await _addWater(amount);
  }

  Future<void> _showGoalDialog() async {
    final controller = TextEditingController(
      text: WaterIntakeService.dailyGoalMl.toString(),
    );

    final goal = await showDialog<int>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF081226),
          title: const Text(
            'Daily Water Goal',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
          content: TextField(
            controller: controller,
            autofocus: true,
            keyboardType: TextInputType.number,
            style: const TextStyle(
              color: Colors.white,
            ),
            decoration: const InputDecoration(
              labelText: 'Goal in ml',
              labelStyle: TextStyle(
                color: Color(0xFF94A3B8),
              ),
              helperText: 'Example: 3000',
              helperStyle: TextStyle(
                color: Color(0xFF64748B),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final value = int.tryParse(
                  controller.text.trim(),
                );

                if (value == null || value <= 0) {
                  return;
                }

                Navigator.of(dialogContext).pop(value);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    controller.dispose();

    if (goal == null) {
      return;
    }

    await WaterIntakeService.setDailyGoal(goal);

    if (!mounted) {
      return;
    }

    setState(() {});
  }

  Future<void> _removeLast() async {
    final removed =
        await WaterIntakeService.removeLastWater();

    if (!mounted || !removed) {
      return;
    }

    setState(() {});
  }

  Future<void> _clearToday() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF081226),
          title: const Text(
            'Clear Today?',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
          content: const Text(
            'All water entries for today will be removed.',
            style: TextStyle(
              color: Color(0xFF94A3B8),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: const Text('Clear'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    await WaterIntakeService.clearToday();

    if (!mounted) {
      return;
    }

    setState(() {});
  }

  String _formatMl(int ml) {
    if (ml >= 1000) {
      final liters = ml / 1000;

      if (liters == liters.roundToDouble()) {
        return '${liters.toInt()} L';
      }

      return '${liters.toStringAsFixed(1)} L';
    }

    return '$ml ml';
  }

  String _formatTime(DateTime time) {
    final hour = time.hour;
    final minute = time.minute
        .toString()
        .padLeft(2, '0');

    final suffix = hour >= 12 ? 'PM' : 'AM';

    final displayHour =
        hour % 12 == 0 ? 12 : hour % 12;

    return '$displayHour:$minute $suffix';
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: Color(0xFF020817),
        body: Center(
          child: CircularProgressIndicator(
            color: Color(0xFF22D3EE),
          ),
        ),
      );
    }

    final consumed =
        WaterIntakeService.todayConsumedMl;

    final goal =
        WaterIntakeService.dailyGoalMl;

    final remaining =
        WaterIntakeService.remainingMl;

    final progress =
        WaterIntakeService.progress;

    final entries =
        WaterIntakeService.todayEntries;

    return Scaffold(
      backgroundColor: const Color(0xFF020817),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
          ),
        ),
        title: const Text(
          'Water Intake',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Daily Goal',
            onPressed: _showGoalDialog,
            icon: const Icon(
              Icons.flag_rounded,
              color: Color(0xFF22D3EE),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          physics:
              const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            20,
            10,
            20,
            30,
          ),
          children: [
            _mainCard(
              consumed: consumed,
              goal: goal,
              remaining: remaining,
              progress: progress,
            ),
            const SizedBox(height: 18),
            _quickAddCard(),
            const SizedBox(height: 22),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Today',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                if (entries.isNotEmpty)
                  TextButton(
                    onPressed: _removeLast,
                    child: const Text(
                      'Undo last',
                    ),
                  ),
                if (entries.isNotEmpty)
                  IconButton(
                    tooltip: 'Clear today',
                    onPressed: _clearToday,
                    icon: const Icon(
                      Icons.delete_outline_rounded,
                      color: Color(0xFFFF6B6B),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            if (entries.isEmpty)
              _emptyState()
            else
              ...entries.reversed.map(
                _entryCard,
              ),
          ],
        ),
      ),
    );
  }

  Widget _mainCard({
    required int consumed,
    required int goal,
    required int remaining,
    required double progress,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF111B40),
            Color(0xFF07182B),
          ],
        ),
        borderRadius:
            BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF22D3EE)
              .withValues(alpha: 0.25),
        ),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.water_drop_rounded,
            color: Color(0xFF22D3EE),
            size: 48,
          ),
          const SizedBox(height: 10),
          Text(
            _formatMl(consumed),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            'of ${_formatMl(goal)} goal',
            style: const TextStyle(
              color: Color(0xFF94A3B8),
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 18),
          ClipRRect(
            borderRadius:
                BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor:
                  const Color(0xFF1E293B),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(
                Color(0xFF22D3EE),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _stat(
                  'Consumed',
                  _formatMl(consumed),
                ),
              ),
              Expanded(
                child: _stat(
                  'Remaining',
                  _formatMl(remaining),
                ),
              ),
              Expanded(
                child: _stat(
                  'Progress',
                  '${(progress * 100).round()}%',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _stat(
    String title,
    String value,
  ) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF64748B),
            fontSize: 9,
          ),
        ),
      ],
    );
  }

  Widget _quickAddCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF081226),
        borderRadius:
            BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF334155)
              .withValues(alpha: 0.35),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Quick Add',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                'Tap a size',
                style: const TextStyle(
                  color: Color(0xFF64748B),
                  fontSize: 9,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _waterButton(250),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _waterButton(500),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _waterButton(750),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed:
                      _showCustomAmount,
                  icon: const Icon(
                    Icons.edit_rounded,
                    size: 17,
                  ),
                  label:
                      const Text('Custom'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _waterButton(int amount) {
    return ElevatedButton(
      onPressed: () => _addWater(amount),
      style: ElevatedButton.styleFrom(
        backgroundColor:
            const Color(0xFF0C3145),
        foregroundColor:
            const Color(0xFF67E8F9),
        minimumSize:
            const Size(0, 48),
        elevation: 0,
      ),
      child: Text(
        '+ $amount ml',
      ),
    );
  }

  Widget _entryCard(
    WaterEntry entry,
  ) {
    return Container(
      margin:
          const EdgeInsets.only(bottom: 9),
      padding:
          const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF081226),
        borderRadius:
            BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color:
                  const Color(0xFF22D3EE)
                      .withValues(alpha: 0.10),
              borderRadius:
                  BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.water_drop_rounded,
              color: Color(0xFF22D3EE),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  _formatMl(entry.amountMl),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  _formatTime(entry.timestamp),
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.check_circle_rounded,
            color: Color(0xFF22D3EE),
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _emptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: const Color(0xFF081226),
        borderRadius:
            BorderRadius.circular(20),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.water_drop_outlined,
            color: Color(0xFF22D3EE),
            size: 44,
          ),
          SizedBox(height: 10),
          Text(
            'No water logged yet',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 5),
          Text(
            'Start tracking your hydration today.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF64748B),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}


// =================================================================
// CUSTOM WATER DIALOG
// =================================================================

class _CustomWaterDialog extends StatefulWidget {
  const _CustomWaterDialog();

  @override
  State<_CustomWaterDialog> createState() =>
      _CustomWaterDialogState();
}

class _CustomWaterDialogState
    extends State<_CustomWaterDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    FocusManager.instance.primaryFocus?.unfocus();

    final value = int.tryParse(
      _controller.text.trim(),
    );

    if (value == null || value <= 0) {
      return;
    }

    Navigator.of(context).pop(value);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF081226),
      title: const Text(
        'Add Water',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
        ),
      ),
      content: TextField(
        controller: _controller,
        autofocus: true,
        keyboardType:
            const TextInputType.numberWithOptions(
          decimal: false,
        ),
        style: const TextStyle(
          color: Colors.white,
        ),
        decoration: const InputDecoration(
          labelText: 'Amount in ml',
          labelStyle: TextStyle(
            color: Color(0xFF94A3B8),
          ),
          hintText: 'Example: 350',
          hintStyle: TextStyle(
            color: Color(0xFF475569),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            FocusManager
                .instance
                .primaryFocus
                ?.unfocus();

            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text('Add'),
        ),
      ],
    );
  }
}
