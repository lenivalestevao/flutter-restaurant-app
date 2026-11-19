import 'package:flutter/material.dart';

import 'data.dart';
import 'tracking_screen.dart';
import 'widgets.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your order')),
      body: ListenableBuilder(
        listenable: cart,
        builder: (context, _) {
          if (cart.isEmpty) {
            return EmptyState(
              emoji: '🛍️',
              title: 'Your order is empty',
              message: 'Add a few dishes from the menu.',
              action: FilledButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Browse the menu')),
            );
          }
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              for (final e in cart.items.entries) _LineTile(dish: dishById(e.key), qty: e.value),
              const SizedBox(height: 16),
              SegmentedButton<OrderMode>(
                segments: const [
                  ButtonSegment(value: OrderMode.delivery, label: Text('Delivery'), icon: Icon(Icons.delivery_dining)),
                  ButtonSegment(value: OrderMode.pickup, label: Text('Pickup'), icon: Icon(Icons.storefront)),
                ],
                selected: {cart.mode},
                onSelectionChanged: (s) => cart.setMode(s.first),
              ),
              const SizedBox(height: 16),
              const Text('Tip', style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                children: [
                  for (final r in const [0.0, 0.1, 0.15, 0.2])
                    ChoiceChip(
                      label: Text(r == 0 ? 'None' : '${(r * 100).round()}%'),
                      selected: cart.tipRate == r,
                      onSelected: (_) => cart.setTip(r),
                    ),
                ],
              ),
              const SizedBox(height: 18),
              Card(
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      SummaryRow('Subtotal', money(cart.subtotal)),
                      SummaryRow('Tax (8%)', money(cart.tax)),
                      SummaryRow('Tip', money(cart.tip)),
                      SummaryRow('Delivery', cart.delivery == 0 ? 'Free' : money(cart.delivery)),
                      const Divider(height: 22),
                      SummaryRow('Total', money(cart.total), bold: true),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),
              FilledButton(
                style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
                onPressed: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const CheckoutScreen())),
                child: const Text('Checkout'),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _LineTile extends StatelessWidget {
  const _LineTile({required this.dish, required this.qty});

  final Dish dish;
  final int qty;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(dish.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Theme.of(context).colorScheme.errorContainer,
        child: const Icon(Icons.delete_outline),
      ),
      onDismissed: (_) => cart.setQuantity(dish.id, 0),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 4),
        leading: EmojiTile(dish: dish, size: 52, radius: 14),
        title: Text(dish.name, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text(money(dish.price * qty)),
        trailing: QuantityStepper(value: qty, onChanged: (v) => cart.setQuantity(dish.id, v)),
      ),
    );
  }
}

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _address = TextEditingController();
  final _notes = TextEditingController();
  int _payment = 0;

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _address.dispose();
    _notes.dispose();
    super.dispose();
  }

  void _place() {
    if (!_formKey.currentState!.validate()) return;
    final order = orderStore.place(cart, _name.text.trim());
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => TrackingScreen(order: order)),
      (route) => route.isFirst,
    );
  }

  @override
  Widget build(BuildContext context) {
    final delivery = cart.mode == OrderMode.delivery;
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _name,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(labelText: 'Name', border: OutlineInputBorder()),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter your name' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _phone,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Phone', border: OutlineInputBorder()),
              validator: (v) => (v == null || v.replaceAll(RegExp(r'\D'), '').length < 7) ? 'Enter a valid phone number' : null,
            ),
            if (delivery) ...[
              const SizedBox(height: 12),
              TextFormField(
                controller: _address,
                decoration: const InputDecoration(labelText: 'Delivery address', border: OutlineInputBorder()),
                validator: (v) => (v == null || v.trim().length < 6) ? 'Please enter your address' : null,
              ),
            ],
            const SizedBox(height: 12),
            TextFormField(controller: _notes, maxLines: 2, decoration: const InputDecoration(labelText: 'Notes for the kitchen (optional)', border: OutlineInputBorder())),
            const SizedBox(height: 20),
            const Text('Payment', style: TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              children: [
                ChoiceChip(label: const Text('Pay at the door / counter'), selected: _payment == 0, onSelected: (_) => setState(() => _payment = 0)),
                ChoiceChip(label: const Text('Card (demo, nothing is charged)'), selected: _payment == 1, onSelected: (_) => setState(() => _payment = 1)),
              ],
            ),
            const SizedBox(height: 12),
            SummaryRow('Total', money(cart.total), bold: true),
            const SizedBox(height: 16),
            FilledButton(
              style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
              onPressed: _place,
              child: Text('Place order · ' + money(cart.total)),
            ),
          ],
        ),
      ),
    );
  }
}
