class PercentageChangeFormat {
  static String formatPercentChange(int bought, int current) {
    int diff = current - bought;
    return (100.0 * diff / bought).toStringAsFixed(1);
  }
}
