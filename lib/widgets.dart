import 'package:flutter/material.dart';

import 'data.dart';

/// Emoji on a soft gradient, used instead of photos so the kit has no assets.
class EmojiTile extends StatelessWidget {
  const EmojiTile({super.key, required this.dish, this.size = 76, this.radius = 18});

  final Dish dish;
  final double size;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final light = Color.lerp(dish.color, Colors.white, 0.55)!;
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [light, dish.color]),
      ),
      child: Text(dish.emoji, style: TextStyle(fontSize: size * 0.48)),
    );
  }
}

class DietChips extends StatelessWidget {
  const DietChips({super.key, required this.diets});

  final List<Diet> diets;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        for (final d in diets)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(color: scheme.secondaryContainer, borderRadius: BorderRadius.circular(20)),
            child: Text(d.label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: scheme.onSecondaryContainer)),
          ),
      ],
    );
  }
}

/// Minus / count / plus control.
class QuantityStepper extends StatelessWidget {
  const QuantityStepper({super.key, required this.value, required this.onChanged, this.min = 0});

  final int value;
  final int min;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton.outlined(
          visualDensity: VisualDensity.compact,
          onPressed: value > min ? () => onChanged(value - 1) : null,
          icon: const Icon(Icons.remove),
          tooltip: 'Remove one',
        ),
        SizedBox(width: 34, child: Center(child: Text('$value', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)))),
        IconButton.filled(
          visualDensity: VisualDensity.compact,
          onPressed: () => onChanged(value + 1),
          icon: const Icon(Icons.add),
          tooltip: 'Add one',
        ),
      ],
    );
  }
}

class SummaryRow extends StatelessWidget {
  const SummaryRow(this.label, this.value, {super.key, this.bold = false});

  final String label;
  final String value;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(fontSize: bold ? 17 : 14, fontWeight: bold ? FontWeight.w800 : FontWeight.w500);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(label, style: style), Text(value, style: style)]),
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({super.key, required this.emoji, required this.title, required this.message, this.action});

  final String emoji;
  final String title;
  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 54)),
            const SizedBox(height: 12),
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 6),
            Text(message, textAlign: TextAlign.center),
            if (action != null) ...[const SizedBox(height: 16), action!],
          ],
        ),
      ),
    );
  }
}
