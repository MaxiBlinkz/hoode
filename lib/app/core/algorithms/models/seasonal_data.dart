class SeasonalData {
  Season getCurrentSeason() {
    final month = DateTime.now().month;
    if (month >= 6 && month <= 8) return Season.summer;
    if (month >= 12 || month <= 2) return Season.winter;
    return Season.spring;
  }
}

enum Season { spring, summer, fall, winter }
