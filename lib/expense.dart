// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:toautoapp/addexpenses.dart';
import 'package:toautoapp/db_helper.dart';
import 'package:toautoapp/fixexpense.dart';

class ExpensesPage extends StatefulWidget {
  const ExpensesPage({super.key});

  @override
  State<StatefulWidget> createState() => _ExpensesPageState();
}

List<Map<String, dynamic>> carData = [];
List<Map<String, dynamic>> data2 = [];
Map<int, List<Map<String, dynamic>>> groupedData = {};

DbHelper dbHelper = DbHelper();

class _ExpensesPageState extends State<ExpensesPage> {
  @override
  void initState() {
    getData();
    getExpenseData();
    super.initState();
  }

  Future<void> getExpenseData() async {
    await dbHelper.open();
    data2 = await dbHelper.getExpenseData();
    setState(() {});
  }

  Future<void> getData() async {
    await dbHelper.open();
    carData = await dbHelper.getCarData();
    setState(() {});
  }

  List<Map<String, dynamic>> filterByCarId(
      int carId, List<Map<String, dynamic>> dataList) {
    return dataList.where((item) => item['carId'] == carId).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      width: double.infinity,
      height: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              for (int j = 0; j < carData.length; j++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 25),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[850],
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 10, left: 20, right: 20, bottom: 10),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/${carData[j]["carBody"].toString().toLowerCase()}.png",
                                fit: BoxFit.contain,
                                width: MediaQuery.of(context).size.width / 6,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                carData[j]["make"],
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                " ${carData[j]["model"]}",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 15),
                          Text(
                            "Expenses",
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          SizedBox(height: 15),
                          for (int i = 0;
                              i < filterByCarId(carData[j]["id"], data2).length;
                              i++)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    filterByCarId(carData[j]["id"], data2)[i]
                                        ["expenseName"],
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "- ${filterByCarId(carData[j]["id"], data2)[i]["expensePrice"]}\$",
                                        style: TextStyle(
                                            color: Colors.red[900],
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      SizedBox(width: 4),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      FixExpenses(
                                                          expenseId:
                                                              filterByCarId(
                                                                      carData[j]
                                                                          ["id"],
                                                                      data2)[i]
                                                                  ["id"])));
                                        },
                                        child: Icon(
                                          Icons.edit_square,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddExpenses(),
                        ),
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
                      "Add Expenses",
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
      ),
    );
  }
}
