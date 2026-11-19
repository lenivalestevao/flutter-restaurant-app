import 'package:flutter/material.dart';

String money(double v) => '\$' + v.toStringAsFixed(2);

enum Diet { vegetarian, vegan, glutenFree, spicy }

extension DietLabel on Diet {
  String get label {
    switch (this) {
      case Diet.vegetarian:
        return 'Vegetarian';
      case Diet.vegan:
        return 'Vegan';
      case Diet.glutenFree:
        return 'Gluten-free';
      case Diet.spicy:
        return 'Spicy';
    }
  }
}

class Dish {
  const Dish({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.emoji,
    required this.color,
    this.diets = const [],
    this.rating = 4.8,
    this.minutes = 15,
  });

  final String id;
  final String name;
  final String description;
  final double price;
  final String category;
  final String emoji;
  final Color color;
  final List<Diet> diets;
  final double rating;
  final int minutes;
}

const categories = ['All', 'Starters', 'Pasta', 'Pizza', 'Mains', 'Desserts', 'Drinks'];

const dishes = <Dish>[
  Dish(id: 'bruschetta', name: 'Tomato Bruschetta', description: 'Grilled sourdough, heirloom tomatoes, basil and aged balsamic.', price: 9, category: 'Starters', emoji: '🍅', color: Color(0xFFE76F51), diets: [Diet.vegan], minutes: 8),
  Dish(id: 'burrata', name: 'Burrata & Peach', description: 'Creamy burrata, grilled peach, pistachio and honey.', price: 14, category: 'Starters', emoji: '🍑', color: Color(0xFFF4A261), diets: [Diet.vegetarian, Diet.glutenFree], rating: 4.9, minutes: 8),
  Dish(id: 'arancini', name: 'Saffron Arancini', description: 'Crispy risotto balls with mozzarella and lemon aioli.', price: 11, category: 'Starters', emoji: '🧆', color: Color(0xFFE9C46A), diets: [Diet.vegetarian], minutes: 12),
  Dish(id: 'tagliatelle', name: 'Saffron Tagliatelle', description: 'Fresh egg pasta, saffron cream, parmesan and black pepper.', price: 19, category: 'Pasta', emoji: '🍝', color: Color(0xFFF4A261), diets: [Diet.vegetarian], rating: 4.9, minutes: 18),
  Dish(id: 'arrabbiata', name: 'Penne Arrabbiata', description: 'Spicy tomato sauce, garlic, chili and fresh parsley.', price: 16, category: 'Pasta', emoji: '🌶️', color: Color(0xFFD62828), diets: [Diet.vegan, Diet.spicy], minutes: 15),
  Dish(id: 'pesto', name: 'Basil Pesto Fusilli', description: 'House pesto, pine nuts, green beans and potato.', price: 17, category: 'Pasta', emoji: '🌿', color: Color(0xFF6A994E), diets: [Diet.vegetarian], minutes: 15),
  Dish(id: 'lasagna', name: 'Slow Lasagna', description: 'Eight layers of ragu, béchamel and parmesan, baked to order.', price: 21, category: 'Pasta', emoji: '🥘', color: Color(0xFFBC4749), rating: 4.7, minutes: 22),
  Dish(id: 'margherita', name: 'Margherita', description: 'San Marzano tomato, fior di latte and basil on a wood-fired crust.', price: 15, category: 'Pizza', emoji: '🍕', color: Color(0xFFE63946), diets: [Diet.vegetarian], rating: 4.8, minutes: 14),
  Dish(id: 'diavola', name: 'Diavola', description: 'Spicy salame, tomato, mozzarella and chili honey.', price: 18, category: 'Pizza', emoji: '🔥', color: Color(0xFFC1121F), diets: [Diet.spicy], minutes: 14),
  Dish(id: 'funghi', name: 'Wild Mushroom Pizza', description: 'Mixed mushrooms, garlic cream, thyme and mozzarella.', price: 18, category: 'Pizza', emoji: '🍄', color: Color(0xFF9C6644), diets: [Diet.vegetarian], minutes: 14),
  Dish(id: 'salmon', name: 'Cedar Salmon', description: 'Wood-roasted salmon, lemon butter, fennel and new potatoes.', price: 27, category: 'Mains', emoji: '🐟', color: Color(0xFFFF8FA3), diets: [Diet.glutenFree], rating: 4.9, minutes: 22),
  Dish(id: 'chicken', name: 'Herb Roast Chicken', description: 'Half free-range chicken, rosemary jus and crispy potatoes.', price: 24, category: 'Mains', emoji: '🍗', color: Color(0xFFDDA15E), diets: [Diet.glutenFree], minutes: 25),
  Dish(id: 'risotto', name: 'Pumpkin Risotto', description: 'Carnaroli rice, roasted pumpkin, sage and brown butter.', price: 20, category: 'Mains', emoji: '🎃', color: Color(0xFFFB8500), diets: [Diet.vegetarian, Diet.glutenFree], minutes: 20),
  Dish(id: 'tiramisu', name: 'Tiramisu', description: 'Espresso-soaked savoiardi, mascarpone cream and cocoa.', price: 9, category: 'Desserts', emoji: '🍰', color: Color(0xFF8D6E63), diets: [Diet.vegetarian], rating: 4.9, minutes: 5),
  Dish(id: 'panna', name: 'Panna Cotta', description: 'Vanilla cream with warm berry compote.', price: 8, category: 'Desserts', emoji: '🍮', color: Color(0xFFB5838D), diets: [Diet.vegetarian, Diet.glutenFree], minutes: 5),
  Dish(id: 'lemonade', name: 'Sage Lemonade', description: 'Fresh lemon, sage syrup and sparkling water.', price: 5, category: 'Drinks', emoji: '🍋', color: Color(0xFFCAD2C5), diets: [Diet.vegan, Diet.glutenFree], minutes: 3),
  Dish(id: 'spritz', name: 'Garden Spritz', description: 'Bitter orange, prosecco and soda. Ask for it alcohol-free.', price: 10, category: 'Drinks', emoji: '🥂', color: Color(0xFFF77F00), diets: [Diet.vegan], minutes: 4),
  Dish(id: 'espresso', name: 'Double Espresso', description: 'House blend, roasted locally every week.', price: 4, category: 'Drinks', emoji: '☕', color: Color(0xFF6F4E37), diets: [Diet.vegan, Diet.glutenFree], minutes: 3),
];

Dish dishById(String id) => dishes.firstWhere((d) => d.id == id);

/// Delivery or pickup.
enum OrderMode { delivery, pickup }

class CartModel extends ChangeNotifier {
  final Map<String, int> _items = {};
  OrderMode mode = OrderMode.delivery;
  double tipRate = 0.1;

  static const double taxRate = 0.08;
  static const double deliveryFee = 3.99;

  Map<String, int> get items => Map.unmodifiable(_items);
  int get count => _items.values.fold(0, (a, b) => a + b);
  bool get isEmpty => _items.isEmpty;

  int quantity(String id) => _items[id] ?? 0;

  void add(Dish dish, [int qty = 1]) {
    _items[dish.id] = quantity(dish.id) + qty;
    notifyListeners();
  }

  void setQuantity(String id, int qty) {
    if (qty <= 0) {
      _items.remove(id);
    } else {
      _items[id] = qty;
    }
    notifyListeners();
  }

  void setMode(OrderMode value) {
    mode = value;
    notifyListeners();
  }

  void setTip(double rate) {
    tipRate = rate;
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  double get subtotal => _items.entries.fold(0.0, (sum, e) => sum + dishById(e.key).price * e.value);
  double get tax => subtotal * taxRate;
  double get tip => subtotal * tipRate;
  double get delivery => mode == OrderMode.delivery && !isEmpty ? deliveryFee : 0;
  double get total => subtotal + tax + tip + delivery;
}

class OrderLine {
  const OrderLine(this.dish, this.qty);
  final Dish dish;
  final int qty;
}

class Order {
  Order({required this.id, required this.lines, required this.total, required this.mode, required this.name, required this.placedAt});

  final String id;
  final List<OrderLine> lines;
  final double total;
  final OrderMode mode;
  final String name;
  final DateTime placedAt;

  /// Demo progress: one step every [stepSeconds] seconds.
  static const int stepSeconds = 6;

  List<String> get steps => mode == OrderMode.delivery
      ? const ['Received', 'Preparing', 'On the way', 'Delivered']
      : const ['Received', 'Preparing', 'Ready for pickup', 'Picked up'];

  int stepAt(DateTime now) {
    final s = now.difference(placedAt).inSeconds ~/ stepSeconds;
    return s.clamp(0, steps.length - 1);
  }

  bool isDone(DateTime now) => stepAt(now) == steps.length - 1;
}

class OrderStore extends ChangeNotifier {
  final List<Order> _orders = [];
  int _next = 1042;

  List<Order> get orders => List.unmodifiable(_orders.reversed);

  /// Turns the cart into an order and empties the cart.
  Order place(CartModel cart, String name) {
    final order = Order(
      id: 'SS-' + (_next++).toString(),
      lines: cart.items.entries.map((e) => OrderLine(dishById(e.key), e.value)).toList(),
      total: cart.total,
      mode: cart.mode,
      name: name,
      placedAt: DateTime.now(),
    );
    _orders.add(order);
    cart.clear();
    notifyListeners();
    return order;
  }
}

class Reservation {
  const Reservation({required this.id, required this.name, required this.date, required this.time, required this.guests, required this.occasion});

  final String id;
  final String name;
  final DateTime date;
  final String time;
  final int guests;
  final String occasion;
}

const timeSlots = ['17:00', '17:30', '18:00', '18:30', '19:00', '19:30', '20:00', '20:30', '21:00'];

class ReservationStore extends ChangeNotifier {
  final List<Reservation> _items = [];
  int _next = 100;

  List<Reservation> get items => List.unmodifiable(_items);

  /// Some slots are "full" so the picker has something to show.
  /// The pattern depends only on the date and time, so it is stable.
  static bool isFull(DateTime date, String time) {
    final seed = date.day * 7 + date.month * 3 + timeSlots.indexOf(time) * 5;
    return seed % 4 == 0;
  }

  bool isTaken(DateTime date, String time) =>
      isFull(date, time) || _items.any((r) => r.date.year == date.year && r.date.month == date.month && r.date.day == date.day && r.time == time);

  Reservation add({required String name, required DateTime date, required String time, required int guests, required String occasion}) {
    final r = Reservation(id: 'RES-' + (_next++).toString(), name: name, date: date, time: time, guests: guests, occasion: occasion);
    _items.add(r);
    notifyListeners();
    return r;
  }

  void cancel(String id) {
    _items.removeWhere((r) => r.id == id);
    notifyListeners();
  }
}

/// App-wide state. Replace with Provider, Riverpod or your own DI if you like.
final CartModel cart = CartModel();
final OrderStore orderStore = OrderStore();
final ReservationStore reservationStore = ReservationStore();
