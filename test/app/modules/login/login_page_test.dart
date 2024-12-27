import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:hoode/app/core/widgets/social_button.dart';
import 'package:hoode/app/modules/login/login_controller.dart';
import 'package:hoode/app/modules/login/login_page.dart';
import 'package:hoode/app/data/enums/enums.dart';
import 'package:mockito/mockito.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class MockLoginController extends GetxController with Mock implements LoginController {
  @override
  final isPasswordVisible = false.obs;
  @override
  final status = Status.initial.obs;
}

void main() {
  late MockLoginController mockController;

  setUp(() {
    mockController = MockLoginController();
    Get.put<LoginController>(mockController);
  });

  tearDown(() {
    Get.reset();
  });

  testWidgets('LoginPage renders all essential elements', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: LoginPage(),
      ),
    );

    expect(find.text('Hoode'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.text("Don't have an account? Sign Up"), findsOneWidget);
    expect(find.text('Or continue with'), findsOneWidget);
    expect(find.byType(SocialButton), findsNWidgets(3));
  });

  testWidgets('Email validation shows error for invalid input', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: LoginPage(),
      ),
    );

    await tester.enterText(find.byType(TextField).first, 'invalid-email');
    await tester.pump();
    await tester.tap(find.text('Login'));
    await tester.pump();

    expect(find.text('Please enter a valid email address'), findsOneWidget);
  });

  testWidgets('Password toggle visibility works', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: LoginPage(),
      ),
    );

    final passwordField = find.byType(TextField).last;
    expect(tester.widget<TextField>(passwordField).obscureText, true);

    await tester.tap(find.byIcon(IconlyLight.show));
    await tester.pump();

    expect(mockController.isPasswordVisible.value, true);
  });

  testWidgets('Social login buttons trigger correct methods', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: LoginPage(),
      ),
    );

    when(mockController.googleSignIn()).thenAnswer((_) async => null);
    when(mockController.appleSignIn()).thenAnswer((_) async => null);
    when(mockController.facebookSignIn()).thenAnswer((_) async => null);

    await tester.tap(find.byType(SocialButton).first);
    verify(mockController.googleSignIn()).called(1);

    await tester.tap(find.byType(SocialButton).at(1));
    verify(mockController.appleSignIn()).called(1);

    await tester.tap(find.byType(SocialButton).last);
    verify(mockController.facebookSignIn()).called(1);
  });

  testWidgets('Successful login navigates to NavBarPage', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: LoginPage(),
      ),
    );

    when(mockController.login()).thenAnswer((_) async {
      mockController.status.value = Status.success;
    });

    await tester.enterText(find.byType(TextField).first, 'test@email.com');
    await tester.enterText(find.byType(TextField).last, 'password123');
    await tester.tap(find.text('Login'));
    await tester.pump(const Duration(seconds: 3));

    verify(mockController.login()).called(1);
  });

  testWidgets('Banner ad displays when available', (WidgetTester tester) async {
    mockController.bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/9214589741',
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: LoginPage(),
      ),
    );

    expect(find.byType(AdWidget), findsOneWidget);
  });
}
