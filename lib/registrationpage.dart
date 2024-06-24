// ignore_for_file: prefer_const_constructors, unused_local_variable, prefer_const_declarations, prefer_const_literals_to_create_immutables, avoid_print, non_constant_identifier_names, must_be_immutable, use_build_context_synchronously

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toautoapp/home.dart';

int BG_CLR = 0x00181818;
XFile? pickedFile;
bool isOkey = false;

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  String addLeadingZero(int value) {
    if (value < 10) {
      return '0$value';
    } else {
      return '$value';
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        _dateController.text =
            "${addLeadingZero(picked.day)}.${addLeadingZero(picked.month)}.${picked.year}";
      });
    }
  }

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        isOkey =
            _nameController.text.isNotEmpty && _dateController.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(BG_CLR),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(BG_CLR),
        title: Text(
          'REGISTRATION',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.of(context).size.width / 3),
              UploadPhotoButton(),
              SizedBox(height: 40),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Enter your personal information:',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              SizedBox(height: 20),
              Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Column(
                      children: [
                        TextField(
                          controller: _nameController,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.transparent,
                            hintText: 'Enter your name or nickname',
                            hintStyle: TextStyle(color: Colors.grey),
                            prefixIcon:
                                Icon(Icons.person_outline, color: Colors.grey),
                          ),
                        ),
                        TextField(
                          controller: _dateController,
                          style: TextStyle(color: Colors.white),
                          readOnly: true,
                          onTap: () => _selectDate(context),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.transparent,
                            hintText: 'Enter your birth day',
                            hintStyle: TextStyle(color: Colors.grey),
                            prefixIcon:
                                Icon(Icons.cake_outlined, color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  )),
              SizedBox(height: 100),
              ElevatedButton(
                onPressed: isOkey
                    ? () async {
                        try {
                          setData("photo", pickedFile!.path);
                        } catch (e) {
                          setData("photo", "assets/profile.png");
                        }
                        setData("name", _nameController.text);
                        setData("birthday", _dateController.text);
                        setboolData("isSetup", true);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => Home()),
                        );
                      }
                    : () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: isOkey
                      ? Color.fromARGB(255, 150, 54, 48)
                      : Colors.grey[800], // Butonun arka plan rengi
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  minimumSize: Size(double.infinity,
                      0), // Buton genişliğini ekran genişliğine eşitler
                ),
                child: Text(
                  'NEXT',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 24,
                      height: 0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> setData(String name, String value) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(name, value);
}

Future<void> setboolData(String name, bool value) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool(name, value);
}

class UploadPhotoButton extends StatefulWidget {
  const UploadPhotoButton({super.key});

  @override
  State<UploadPhotoButton> createState() => _UploadPhotoButtonState();
}

class _UploadPhotoButtonState extends State<UploadPhotoButton> {
  final ImagePicker picker = ImagePicker();
  bool imagesel = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double diameter = constraints.maxWidth * 0.5;
        double borderWidth = 20;
        return Stack(
          alignment: Alignment.center,
          children: [
            CustomPaint(
              size: Size(diameter + borderWidth, diameter + borderWidth),
              painter: DashedCirclePainter(),
            ),
            GestureDetector(
              onTap: () async {
                pickedFile =
                    await picker.pickImage(source: ImageSource.gallery);
                setState(() {
                  imagesel = pickedFile == null ? false : true;
                });
              },
              child: Container(
                width: diameter,
                height: diameter,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(77, 24, 24, 1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: imagesel
                      ? ClipOval(
                          child: Image.file(
                            File(pickedFile!.path),
                            width: diameter,
                            height: diameter,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_photo_alternate,
                              size: 50,
                              color: Colors.white,
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Tap to upload photo',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class DashedCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color.fromRGBO(77, 24, 24, 1)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    final double radius = size.width / 2;
    final double gap = 5;
    final double dashLength = 10;
    double startAngle = 0;
    final double totalCircumference = 2 * 3.141592653589793 * radius;
    final int dashCount = (totalCircumference / (dashLength + gap)).floor();

    for (int i = 0; i < dashCount; i++) {
      final double start = i * (dashLength + gap) / radius;
      final double end = start + dashLength / radius;
      canvas.drawArc(
        Rect.fromCircle(center: Offset(radius, radius), radius: radius),
        start,
        end - start,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
