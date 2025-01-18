class UserInteractionHistory {
  final Map<String, int> viewCounts;
  final Set<String> favorites;
  final Map<String, List<DateTime>> clicks;

  UserInteractionHistory({
    required this.viewCounts,
    required this.favorites,
    required this.clicks,
  });

  int getViewCount(String propertyId) => viewCounts[propertyId] ?? 0;
  bool isFavorite(String propertyId) => favorites.contains(propertyId);
  int getRecentClicks(String propertyId) {
    final propertyClicks = clicks[propertyId] ?? [];
    final recent = DateTime.now().subtract(const Duration(days: 7));
    return propertyClicks.where((date) => date.isAfter(recent)).length;
  }
}