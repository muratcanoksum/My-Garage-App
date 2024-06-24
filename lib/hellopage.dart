// ignore_for_file: non_constant_identifier_names, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:toautoapp/registrationpage.dart';

int BG_CLR = 0X00181818;

class HelloPage extends StatefulWidget {
  const HelloPage({super.key});

  @override
  State<HelloPage> createState() => _HelloPageState();
}

class _HelloPageState extends State<HelloPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(24, 24, 24, 1),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Image.asset("assets/helloto.png")),
            const Text(
              '''The app will help you spend money efficiently on car maintenance. It takes into account all variable costs: fuel, parking, fines, accidents, maintenance, spare parts, consumables, taxes, insurance, maintenance and depreciation.
        The app will remind you of scheduled events, such as oil and timing belt changes.
        
        In the app you will be able to keep detailed expense statistics with visual graphs. It can calculate the cost of owning a car and the cost of a kilometer of mileage. You will be able to add notes and photos''',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  fontFamily: "Gilroy"),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromRGBO(214, 39, 39, 1),
                      Color.fromRGBO(157, 25, 25, 1),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(
                      10), // Adjust the border radius if needed
                ),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RegistrationScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          8), // Match the border radius of the container
                    ),
                  ),
                  child: const Text(
                    "START",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.normal,
                      fontFamily: "Gilroy",
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
