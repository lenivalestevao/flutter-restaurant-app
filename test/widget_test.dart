import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_restaurant_app/data.dart';
import 'package:flutter_restaurant_app/main.dart';

void main() {
  testWidgets('shows the menu', (tester) async {
    await tester.pumpWidget(const RestaurantApp());
    expect(find.text('Tomato Bruschetta'), findsOneWidget);
    expect(find.text('Reserve'), findsOneWidget);
  });

  test('cart totals, delivery fee and order placement', () {
    final c = CartModel();
    c.add(dishById('margherita'), 2);
    expect(c.count, 2);
    expect(c.subtotal, 30);
    expect(c.delivery, CartModel.deliveryFee);
    c.setMode(OrderMode.pickup);
    expect(c.delivery, 0);
    c.setTip(0);
    expect(c.total, closeTo(30 * 1.08, 0.001));

    final store = OrderStore();
    final order = store.place(c, 'Ana');
    expect(c.isEmpty, isTrue);
    expect(order.lines.single.qty, 2);
    expect(order.stepAt(order.placedAt), 0);
    expect(order.stepAt(order.placedAt.add(const Duration(seconds: 100))), 3);
  });

  test('reservations block taken slots', () {
    final s = ReservationStore();
    final d = DateTime(2030, 1, 2);
    final free = timeSlots.firstWhere((t) => !ReservationStore.isFull(d, t));
    s.add(name: 'Ana', date: d, time: free, guests: 2, occasion: 'None');
    expect(s.isTaken(d, free), isTrue);
  });
}
