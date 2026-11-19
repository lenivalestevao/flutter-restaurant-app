import 'package:flutter/material.dart';

import 'cart_screen.dart';
import 'data.dart';
import 'dish_screen.dart';
import 'widgets.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  String _category = 'All';
  String _query = '';
  final Set<Diet> _diets = {};

  List<Dish> get _filtered => dishes.where((d) {
        if (_category != 'All' && d.category != _category) return false;
        if (_diets.isNotEmpty && !_diets.every(d.diets.contains)) return false;
        final q = _query.trim().toLowerCase();
        return q.isEmpty || d.name.toLowerCase().contains(q) || d.description.toLowerCase().contains(q);
      }).toList();

  @override
  Widget build(BuildContext context) {
    final list = _filtered;
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('🌿 Saffron & Sage', style: TextStyle(fontWeight: FontWeight.w800)),
        actions: [
          ListenableBuilder(
            listenable: cart,
            builder: (context, _) => IconButton(
              tooltip: 'Open your order',
              onPressed: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const CartScreen())),
              icon: Badge(isLabelVisible: cart.count > 0, label: Text('${cart.count}'), child: const Icon(Icons.shopping_bag_outlined)),
            ),
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: TextField(
              onChanged: (v) => setState(() => _query = v),
              decoration: InputDecoration(
                hintText: 'Search dishes',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(28), borderSide: BorderSide.none),
              ),
            ),
          ),
          SizedBox(
            height: 42,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                for (final c in categories)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(label: Text(c), selected: _category == c, onSelected: (_) => setState(() => _category = c)),
                  ),
              ],
            ),
          ),
          SizedBox(
            height: 42,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                for (final d in Diet.values)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: FilterChip(
                      label: Text(d.label),
                      selected: _diets.contains(d),
                      onSelected: (on) => setState(() => on ? _diets.add(d) : _diets.remove(d)),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: list.isEmpty
                ? const EmptyState(emoji: '🍽️', title: 'Nothing found', message: 'Try another search or clear a filter.')
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
                    itemCount: list.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, i) => _DishCard(dish: list[i]),
                  ),
          ),
        ],
      ),
      bottomSheet: ListenableBuilder(
        listenable: cart,
        builder: (context, _) {
          if (cart.isEmpty) return const SizedBox.shrink();
          return Material(
            elevation: 8,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: FilledButton(
                  style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const CartScreen())),
                  child: Text('View order · ${cart.count} items · ${money(cart.subtotal)}'),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _DishCard extends StatelessWidget {
  const _DishCard({required this.dish});

  final Dish dish;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => DishScreen(dish: dish))),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Hero(tag: 'dish-' + dish.id, child: EmojiTile(dish: dish)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(dish.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 2),
                    Text(dish.description, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12.5, color: scheme.onSurfaceVariant)),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text(money(dish.price), style: TextStyle(fontWeight: FontWeight.w800, color: scheme.primary)),
                        const SizedBox(width: 10),
                        const Icon(Icons.star_rounded, size: 16, color: Color(0xFFF4A261)),
                        Text(' ${dish.rating}', style: const TextStyle(fontSize: 12.5)),
                        const SizedBox(width: 10),
                        Icon(Icons.schedule, size: 14, color: scheme.onSurfaceVariant),
                        Text(' ${dish.minutes} min', style: const TextStyle(fontSize: 12.5)),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton.filledTonal(
                tooltip: 'Add ' + dish.name,
                onPressed: () {
                  cart.add(dish);
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(SnackBar(content: Text('Added ' + dish.name), duration: const Duration(seconds: 1)));
                },
                icon: const Icon(Icons.add),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
