class AbbreviatedNumberstringFormat {
  static String formatWithCommas(int number) {
    String str = number.toString();
    int length = str.length;
    List<String> result = [];
    
    for (int i = 0; i < length; i++) {
      result.add(str[length - i - 1]);
      if ((i + 1) % 3 == 0 && i != length - 1) {
        result.add(',');
      }
    }
    return result.reversed.join('');
  }

  static String formatMarketCap(int marketCap) {
    if (marketCap < 1000) {
      return marketCap.toString();
    } else if (marketCap < 1_000_000) {
      return '${(marketCap / 1000).toStringAsFixed(1)}K';
    } else if (marketCap < 1_000_000_000) {
      return '${(marketCap / 1_000_000).toStringAsFixed(1)}M';
    } else {
      return '${(marketCap / 1_000_000_000).toStringAsFixed(1)}B';
    }
  }

  static String formatShares(int shares) {
    if (shares < 1000) {
      return shares.toString();
    } else if (shares < 1_000_000) {
      return '${(shares / 1000).toStringAsFixed(1)}K';
    } else if (shares < 1_000_000_000) {
      return '${(shares / 1_000_000).toStringAsFixed(1)}M';
    } else {
      return '${(shares / 1_000_000_000).toStringAsFixed(1)}B';
    }
  }
}