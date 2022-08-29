import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipeapp/provider1/dbProvider.dart';
import 'package:recipeapp/provider1/ragisterProvider.dart';
import 'package:recipeapp/screen/LoginRegisterScreen/login.dart';
import 'package:recipeapp/screen/LoginRegisterScreen/register.dart';
import 'package:recipeapp/screen/home/homeScreen.dart';
import 'package:recipeapp/screen/home/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => RagiProvider(),),
        ChangeNotifierProvider(create: (context) => FDProvider(),),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: 'home',
        routes: {
          '/': (context) =>SplashScreen(),
          'login': (context) => LoginScreen(),
          'reg': (context) => RegisterScreen(),
          'home': (context) => HomeScreen(),
        },
      ),
    ),
  );
}
