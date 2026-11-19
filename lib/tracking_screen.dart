import 'dart:async';

import 'package:flutter/material.dart';

import 'data.dart';
import 'widgets.dart';

/// Live order status. In a real app this would come from your backend;
/// here the status advances on a timer so you can see the flow.
class TrackingScreen extends StatefulWidget {
  const TrackingScreen({super.key, required this.order});

  final Order order;

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  Timer? _timer;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final order = widget.order;
    final step = order.stepAt(_now);
    final done = order.isDone(_now);
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: Text('Order ' + order.id)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(child: Text(done ? '✅' : '👩‍🍳', style: const TextStyle(fontSize: 64))),
          const SizedBox(height: 8),
          Center(
            child: Text(
              done ? 'Enjoy your meal, ' + order.name + '!' : 'Thanks, ' + order.name + '. We are on it.',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 22),
          for (var i = 0; i < order.steps.length; i++)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                backgroundColor: i <= step ? scheme.primary : scheme.surfaceContainerHighest,
                foregroundColor: i <= step ? scheme.onPrimary : scheme.onSurfaceVariant,
                child: i < step || (i == step && done) ? const Icon(Icons.check) : Text('${i + 1}'),
              ),
              title: Text(order.steps[i], style: TextStyle(fontWeight: i == step ? FontWeight.w800 : FontWeight.w500)),
              subtitle: i == step && !done ? const LinearProgressIndicator() : null,
            ),
          const SizedBox(height: 12),
          Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  for (final l in order.lines) SummaryRow('${l.qty} x ${l.dish.name}', money(l.dish.price * l.qty)),
                  const Divider(height: 22),
                  SummaryRow('Total', money(order.total), bold: true),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton(onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst), child: const Text('Back to the menu')),
        ],
      ),
    );
  }
}
