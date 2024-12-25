import 'package:get/get.dart';
import 'package:pocketbase/pocketbase.dart';

class ListingSearchController extends GetxController {
  final isLoading = false.obs;
  final searchQuery = ''.obs;
  final searchResults = <RecordModel>[].obs;
  final activeFilters = <String>[].obs;
  
  // Filter states
  final selectedPriceRange = RxMap<String, double>();
  final selectedPropertyType = ''.obs;
  final selectedBedrooms = 0.obs;
  final selectedLocation = ''.obs;

  void updateSearchQuery(String query) {
    searchQuery.value = query;
    performSearch();
  }

  void addFilter(String filter) {
    if (!activeFilters.contains(filter)) {
      activeFilters.add(filter);
      performSearch();
    }
  }

  void removeFilter(String filter) {
    activeFilters.remove(filter);
    performSearch();
  }

  void setPriceRange(double min, double max) {
    selectedPriceRange['min'] = min;
    selectedPriceRange['max'] = max;
    addFilter('Price: \$${min.toInt()}-\$${max.toInt()}');
    performSearch();
  }

  void setPropertyType(String type) {
    selectedPropertyType.value = type;
    addFilter('Type: $type');
    performSearch();
  }

  void setBedrooms(int count) {
    selectedBedrooms.value = count;
    addFilter('Beds: $count');
    performSearch();
  }

  void setLocation(String location) {
    selectedLocation.value = location;
    addFilter('Location: $location');
    performSearch();
  }

  Future<void> performSearch() async {
    isLoading.value = true;
    try {
      // Implement your search logic here using the filter values
      // Example:
      // final results = await pb.collection('properties').getList(
      //   filter: 'title ~ "${searchQuery.value}"',
      //   sort: '-created',
      // );
      // searchResults.value = results.items;
    } catch (e) {
      print('Search error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void clearFilters() {
    activeFilters.clear();
    selectedPriceRange.clear();
    selectedPropertyType.value = '';
    selectedBedrooms.value = 0;
    selectedLocation.value = '';
    performSearch();
  }
}
