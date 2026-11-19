import 'package:flutter/material.dart';

import 'data.dart';
import 'widgets.dart';

class DishScreen extends StatefulWidget {
  const DishScreen({super.key, required this.dish});

  final Dish dish;

  @override
  State<DishScreen> createState() => _DishScreenState();
}

class _DishScreenState extends State<DishScreen> {
  int _qty = 1;

  @override
  Widget build(BuildContext context) {
    final dish = widget.dish;
    final scheme = Theme.of(context).colorScheme;
    final related = dishes.where((d) => d.category == dish.category && d.id != dish.id).take(3).toList();
    return Scaffold(
      appBar: AppBar(title: Text(dish.category)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(child: Hero(tag: 'dish-' + dish.id, child: EmojiTile(dish: dish, size: 180, radius: 40))),
          const SizedBox(height: 20),
          Text(dish.name, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          Row(
            children: [
              Text(money(dish.price), style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: scheme.primary)),
              const SizedBox(width: 14),
              const Icon(Icons.star_rounded, size: 18, color: Color(0xFFF4A261)),
              Text(' ${dish.rating}'),
              const SizedBox(width: 14),
              const Icon(Icons.schedule, size: 16),
              Text(' ${dish.minutes} min'),
            ],
          ),
          const SizedBox(height: 12),
          Text(dish.description, style: const TextStyle(fontSize: 15, height: 1.4)),
          if (dish.diets.isNotEmpty) ...[const SizedBox(height: 12), DietChips(diets: dish.diets)],
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Quantity', style: TextStyle(fontWeight: FontWeight.w700)),
              QuantityStepper(value: _qty, min: 1, onChanged: (v) => setState(() => _qty = v)),
            ],
          ),
          if (related.isNotEmpty) ...[
            const SizedBox(height: 28),
            Text('You may also like', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 10),
            SizedBox(
              height: 96,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  for (final r in related)
                    Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(18),
                        onTap: () => Navigator.of(context).pushReplacement(MaterialPageRoute<void>(builder: (_) => DishScreen(dish: r))),
                        child: Column(children: [EmojiTile(dish: r, size: 64), const SizedBox(height: 4), Text(r.name.split(' ').first, style: const TextStyle(fontSize: 12))]),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton(
            style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
            onPressed: () {
              cart.add(dish, _qty);
              Navigator.of(context).pop();
            },
            child: Text('Add to order · ${money(dish.price * _qty)}'),
          ),
        ),
      ),
    );
  }
}
