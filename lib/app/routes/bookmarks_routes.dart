import 'package:get/get.dart';

import '../modules/bookmarks/bookmarks_binding.dart';
import '../modules/bookmarks/bookmarks_page.dart';

class BookmarksRoutes {
  BookmarksRoutes._();

  static const bookmarks = '/bookmarks';

  static final routes = [
    GetPage(
      name: bookmarks,
      page: BookmarksPage.new,
      binding: BookmarksBinding(),
    ),
  ];
}
