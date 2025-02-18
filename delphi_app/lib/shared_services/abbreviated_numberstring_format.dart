class AbbreviatedNumberstringFormat {
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