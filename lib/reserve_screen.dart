import 'package:flutter/material.dart';

import 'data.dart';
import 'widgets.dart';

const _months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

String formatDate(DateTime d) => _months[d.month - 1] + ' ' + d.day.toString() + ', ' + d.year.toString();

class ReserveScreen extends StatefulWidget {
  const ReserveScreen({super.key});

  @override
  State<ReserveScreen> createState() => _ReserveScreenState();
}

class _ReserveScreenState extends State<ReserveScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  DateTime _date = DateTime.now().add(const Duration(days: 1));
  int _guests = 2;
  String? _time;
  String _occasion = 'None';

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: now,
      lastDate: now.add(const Duration(days: 60)),
    );
    if (picked != null) {
      setState(() {
        _date = picked;
        _time = null;
      });
    }
  }

  void _confirm() {
    if (!_formKey.currentState!.validate()) return;
    if (_time == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please choose a time.')));
      return;
    }
    final r = reservationStore.add(name: _name.text.trim(), date: _date, time: _time!, guests: _guests, occasion: _occasion);
    setState(() => _time = null);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Table booked. Your code is ' + r.id)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reservations')),
      body: ListenableBuilder(
        listenable: reservationStore,
        builder: (context, _) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _name,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(labelText: 'Name', border: OutlineInputBorder()),
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter a name' : null,
                    ),
                    const SizedBox(height: 14),
                    ListTile(
                      shape: RoundedRectangleBorder(side: BorderSide(color: Theme.of(context).colorScheme.outline), borderRadius: BorderRadius.circular(8)),
                      leading: const Icon(Icons.calendar_today),
                      title: Text(formatDate(_date)),
                      trailing: const Icon(Icons.edit_calendar),
                      onTap: _pickDate,
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Guests', style: TextStyle(fontWeight: FontWeight.w700)),
                        QuantityStepper(value: _guests, min: 1, onChanged: (v) => setState(() => _guests = v.clamp(1, 12))),
                      ],
                    ),
                    const SizedBox(height: 14),
                    const Text('Time', style: TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        for (final t in timeSlots)
                          ChoiceChip(
                            label: Text(t),
                            selected: _time == t,
                            onSelected: reservationStore.isTaken(_date, t) ? null : (_) => setState(() => _time = t),
                          ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    DropdownButtonFormField<String>(
                      value: _occasion,
                      decoration: const InputDecoration(labelText: 'Occasion', border: OutlineInputBorder()),
                      items: const ['None', 'Birthday', 'Anniversary', 'Business dinner', 'Date night']
                          .map((o) => DropdownMenuItem(value: o, child: Text(o)))
                          .toList(),
                      onChanged: (v) => setState(() => _occasion = v ?? 'None'),
                    ),
                    const SizedBox(height: 18),
                    FilledButton(
                      style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
                      onPressed: _confirm,
                      child: const Text('Book a table'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              Text('Your reservations', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              if (reservationStore.items.isEmpty)
                const Text('Nothing booked yet.')
              else
                for (final r in reservationStore.items)
                  Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: const Text('🍷', style: TextStyle(fontSize: 26)),
                      title: Text(formatDate(r.date) + ' · ' + r.time, style: const TextStyle(fontWeight: FontWeight.w700)),
                      subtitle: Text('${r.guests} guests · ${r.name} · ${r.id}' + (r.occasion == 'None' ? '' : ' · ' + r.occasion)),
                      trailing: IconButton(tooltip: 'Cancel', icon: const Icon(Icons.close), onPressed: () => reservationStore.cancel(r.id)),
                    ),
                  ),
            ],
          );
        },
      ),
    );
  }
}
