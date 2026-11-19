import 'package:flutter/material.dart';

import 'data.dart';
import 'tracking_screen.dart';
import 'widgets.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Orders')),
      body: ListenableBuilder(
        listenable: orderStore,
        builder: (context, _) {
          final list = orderStore.orders;
          if (list.isEmpty) {
            return const EmptyState(emoji: '🧾', title: 'No orders yet', message: 'Your orders and their status will show up here.');
          }
          final now = DateTime.now();
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: list.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, i) {
              final o = list[i];
              final done = o.isDone(now);
              final items = o.lines.fold(0, (a, l) => a + l.qty);
              return Card(
                margin: EdgeInsets.zero,
                child: ListTile(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => TrackingScreen(order: o))),
                  leading: Text(done ? '✅' : '👩‍🍳', style: const TextStyle(fontSize: 28)),
                  title: Text('${o.id} · ${money(o.total)}', style: const TextStyle(fontWeight: FontWeight.w700)),
                  subtitle: Text('$items items · ' + (o.mode == OrderMode.delivery ? 'Delivery' : 'Pickup') + ' · ' + o.steps[o.stepAt(now)]),
                  trailing: const Icon(Icons.chevron_right),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
