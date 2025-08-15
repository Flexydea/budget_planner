// Tiny model for reuse across the app.
class Currency {
  final String code; // e.g., USD
  final String name; // e.g., US Dollar
  final String symbol; // e.g., $

  const Currency({
    required this.code,
    required this.name,
    required this.symbol,
  });
}
