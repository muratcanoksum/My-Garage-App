// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toautoapp/home.dart';
import 'package:toautoapp/registrationpage.dart';

bool? setup;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _initialize();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (_) =>
            setup == null ? const RegistrationScreen() : const Home(),
      ));
    });
  }

  Future<void> _initialize() async {
    setup = await getBool();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 28, 28, 28),
              Color.fromARGB(255, 20, 20, 20)
            ],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Image.asset("assets/helloto.png")],
        ),
      ),
    );
  }
}

Future<bool?> getBool() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  bool? asd = prefs.getBool("isSetup");
  return asd;
}
