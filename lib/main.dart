import 'package:ecommerce_app/core/di/depandcy_injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';
import 'features/auth/presentation/bloc/auth_state.dart';
import 'features/auth/presentation/screen/auth_screen.dart';
import 'features/product/presentation/screen/product_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DepandcyInjection.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-commerce App',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        fontFamily: "cairo",
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),

        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.teal, width: 2),
          ),
        ),
      ),
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: BlocBuilder<AuthBloc, AuthState>(
          bloc: sl<AuthBloc>()..add(CheckAuthStatusEvent()),
          builder: (context, state) {
            if (state is AuthAuthenticated) {
              return HomeScreen();
            }
            return const LoginScreen();
          },
        ),
      ),
    );
  }
}
