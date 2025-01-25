import 'package:get/get.dart';

import '../modules/bookings/bookings_binding.dart';
import '../modules/bookings/bookings_page.dart';

class BookingsRoutes {
  BookingsRoutes._();

  static const bookings = '/bookings';

  static final routes = [
    GetPage(
      name: bookings,
      page: BookingsPage.new,
      binding: BookingsBinding(),
    ),
  ];
}
