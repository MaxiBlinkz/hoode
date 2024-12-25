import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hoode/app/core/config/constants.dart';
import 'package:hoode/app/data/enums/enums.dart';
// import 'package:hoode/app/modules/profile_setup/profile_setup_page.dart';
import 'package:logger/logger.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:flutter/widgets.dart';
import 'package:toastification/toastification.dart';
// import 'package:bugsnag_flutter/bugsnag_flutter.dart' as bugnag;
//import 'package:uni_links3/uni_links.dart';

class RegisterController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final logger = Logger(printer: PrettyPrinter());
  final notify = Toastification();
  //final bugsnag = Bugsnag();

  var name = "".obs;
  var email = "".obs;
  var password = "".obs;
  var confirmPassword = "".obs;
  var isRegistered = false.obs;
  var isPasswordVisible = false.obs;

  var id = "".obs;
  var status = Status.initial.obs;
  var err = "".obs;

  final storage = GetStorage();

  final pb = PocketBase(POCKETBASE_URL);
  //final pb = POCKETBASE;

  Future<void> register() async {
    status(Status.loading);
    isRegistered(false);
    final body = <String, dynamic>{
      "username": name.value,
      "email": email.value,
      "emailVisibility": true,
      "password": password.value,
      "passwordConfirm": confirmPassword.value,
    };
    try {
      final record = await pb.collection('users').create(body: body);
      id(record.id);
      status(Status.success);
    } catch (e) {
      status(Status.error);
      err.value = e.toString();
      notify.show(
          type: ToastificationType.error,
          description: Text(e.toString()),
          title: const Text('error'),
          autoCloseDuration: const Duration(microseconds: 500));
      logger.i('${status.value}');
      logger.e('$e');
      // await bugnag.bugsnag.notify(e, stack);
    } finally{
      if(status == Status.success){
        final authData = await pb.collection('users').authWithPassword(
            email.value,
            password.value,
          );
      storage.write('token', authData.token);
      }
    }
    update();
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
    update();
  }

  void initControllers() {
    nameController.addListener(() => name.value = nameController.text);
    emailController.addListener(() => email.value = emailController.text);
    passwordController
        .addListener(() => password.value = passwordController.text);
    confirmPasswordController.addListener(
        () => confirmPassword.value = confirmPasswordController.text);
  }

  // void initDeepLinks() {
  //   uriLinkStream.listen((Uri? uri) {
  //     if (uri != null) {
  //       if (uri.path.contains('login')) {
  //         Get.toNamed('/login');
  //       } else if (uri.path.contains('listing-detail')) {
  //         String? id = uri.pathSegments.last;
  //         Get.toNamed('/listing-detail/$id');
  //       }
  //     }
  //   }, onError: (err) {
  //     print('Deep link error: $err');
  //   });
  // }

  @override
  void onInit() {
    super.onInit();
    // initDeepLinks();
    initControllers();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
