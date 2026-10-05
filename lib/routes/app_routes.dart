import 'package:flutter/material.dart';

import '../screens/auth/forgot_password_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/otp_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/auth/welcome_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/jars/create_jar_screen.dart';
import '../screens/jars/edit_jar_screen.dart';
import '../screens/jars/jar_detail_screen.dart';
import '../screens/jars/jar_list_screen.dart';
import '../screens/transactions/deposit_screen.dart';
import '../screens/transactions/transaction_success_screen.dart';
import '../widgets/app_shell.dart';

class AppRoutes {
  static const String welcome = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String otp = '/otp';
  static const String forgotPassword = '/forgot-password';

  static const String home = '/home';

  static const String jars = '/jars';
  static const String createJar = '/jars/create';
  static const String jarDetail = '/jars/detail';
  static const String editJar = '/jars/edit';

  static const String expenses = '/expenses';
  static const String deposit = '/deposit';
  static const String withdraw = '/withdraw';
  static const String transfer = '/transfer';
  static const String addExpense = '/expense/add';
  static const String ocrScan = '/ocr';
  static const String notifications = '/notifications';

  static const String transactionSuccess =
      '/transaction-success';

  static Route<dynamic> generateRoute(
    RouteSettings settings,
  ) {
    switch (settings.name) {
      case welcome:
        return MaterialPageRoute(
          builder: (_) => const WelcomeScreen(),
        );

      case login:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        );

      case register:
        return MaterialPageRoute(
          builder: (_) => const RegisterScreen(),
        );

      case otp:
        return MaterialPageRoute(
          builder: (_) => const OtpScreen(),
        );

      case forgotPassword:
        return MaterialPageRoute(
          builder: (_) => const ForgotPasswordScreen(),
        );

      case home:
        return MaterialPageRoute(
          builder: (_) => const AppShell(),
        );

      case jars:
        return MaterialPageRoute(
          builder: (_) => const JarListScreen(),
        );

      case createJar:
        return MaterialPageRoute(
          builder: (_) => const CreateJarScreen(),
        );

      case jarDetail:
        return MaterialPageRoute(
          builder: (_) => const JarDetailScreen(),
        );

      case editJar:
        return MaterialPageRoute(
          builder: (_) => const EditJarScreen(),
        );

      case deposit:
        return MaterialPageRoute(
          builder: (_) => const DepositScreen(),
        );

      case transactionSuccess:
        return MaterialPageRoute(
          builder: (_) => const TransactionSuccessScreen(),
          settings: settings,
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        );
    }
  }
}