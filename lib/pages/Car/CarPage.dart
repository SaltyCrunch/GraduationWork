import 'dart:developer';
import 'dart:io';

import 'package:diplom_vlad/pages/Car/EditCar.dart';
import 'package:diplom_vlad/pages/PathList/PathsList.dart';
import 'package:diplom_vlad/pages/PathList/EditPathList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../client/hive_names.dart';
import '../../tools/utils.dart';
import '../../models/employee.dart';
import '../../tools/button.dart';
import '../BottomNavBar.dart';

enum ImageSourceType { gallery, camera }

class CarPage extends StatefulWidget {
  CarPage({Key key, this.employee, this.car}) : super(key: key);
  Employee employee;
  Car car;

  @override
  State<CarPage> createState() => _CarPageState();
}

class _CarPageState extends State<CarPage> {
  DateTime date = DateTime.now();

  String carNumber;
  int employee;

  var status;

  String technicalStatus;

  String numberCar;

  Employee carEmployee;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Color(0x6ea85100),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        employee: widget.employee,
      ),
      backgroundColor: Color(0xfffff3e9),
      body: ValueListenableBuilder(
          valueListenable: Hive.box<Car>(HiveBoxes.car).listenable(),
          builder: (context, Box<Car> box, _) {
            return ValueListenableBuilder(
                valueListenable:
                Hive.box<Employee>(HiveBoxes.employee).listenable(),
                builder: (context, Box<Employee> boxEmployee, _) {
                  return ValueListenableBuilder(
                      valueListenable:
                      Hive.box<PathList>(HiveBoxes.pathList).listenable(),
                      builder: (context, Box<PathList> boxPaths, _) {
                        carEmployee = boxEmployee.values.firstWhere((element) => element.id == widget.car.employeeId, orElse: () => null);
                        return Center(
                          child: Column(
                            children: [
                              const Padding(
                                padding:
                                EdgeInsets.fromLTRB(0, 60, 0, 0),
                                child: Text(
                                  "Автомобиль",
                                  style: TextStyle(
                                      color: Color(0xbaa85100),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 24,
                                      fontFamily: "Ghotic"),
                                ),
                              ),
                              Padding(
                                padding:
                                const EdgeInsets.fromLTRB(20, 50, 20, 0),
                                child: Table(
                                  border: TableBorder.all(
                                      color: Color(0x6ea85100)),
                                  children: [
                                    TableRow(children: [
                                      const TableCell(
                                          verticalAlignment:
                                          TableCellVerticalAlignment
                                              .middle,
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Center(
                                                child: Text(
                                                  "Номер ТС",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w400,
                                                      fontSize: 18,
                                                      fontFamily: "Ghotic"),
                                                )),
                                          )),
                                      TableCell(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: Text(
                                              '${widget.car.numberCar}',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 18,
                                                  fontFamily: "Ghotic"),
                                            ),
                                          ))
                                    ]),
                                    TableRow(children: [
                                      const TableCell(
                                          verticalAlignment:
                                          TableCellVerticalAlignment
                                              .middle,
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Center(
                                                child: Text(
                                                  "Водитель",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w400,
                                                      fontSize: 18,
                                                      fontFamily: "Ghotic"),
                                                )),
                                          )),
                                      TableCell(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              carEmployee != null ?
                                              carEmployee.name: "Нет",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 18,
                                                  fontFamily: "Ghotic"),
                                            ),
                                          )),
                                    ]),
                                    TableRow(children: [
                                      const TableCell(
                                          verticalAlignment:
                                          TableCellVerticalAlignment
                                              .middle,
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Center(
                                                child: Text(
                                                  "Статус",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w400,
                                                      fontSize: 18,
                                                      fontFamily: "Ghotic"),
                                                )),
                                          )),
                                      TableCell(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: Text(
                                              widget.car.status,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 18,
                                                  fontFamily: "Ghotic"),
                                            ),
                                          )),
                                    ]),
                                    TableRow(children: [
                                      const TableCell(
                                          verticalAlignment:
                                          TableCellVerticalAlignment
                                              .middle,
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Center(
                                                child: Text(
                                                  "Техн. состояние",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w400,
                                                      fontSize: 18,
                                                      fontFamily: "Ghotic"),
                                                )),
                                          )),
                                      TableCell(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: Text(
                                              widget.car.technicalStatus,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 18,
                                                  fontFamily: "Ghotic"),
                                            ),
                                          ))
                                    ]),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 18, 0, 0),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    MaterialButton(
                                      onPressed: () {
                                        if (widget.employee.post.compareTo("Механик") != 0) {
                                          try {
                                            PathList pathList = boxPaths.values
                                                .firstWhere((
                                                element) =>
                                            element.numberCar ==
                                                widget.car.numberCar);
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      PathsList(
                                                        car: widget.car,
                                                        employee: widget.employee,
                                                      ),
                                                ));
                                          } on StateError catch(e) {
                                            showDialog<String>(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  AlertDialog(
                                                    title: const Text('Ошибка'),
                                                    content: const Text(
                                                        'Путевых листов нет'),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.of(context).pop(),
                                                        child: const Text('Ок'),
                                                      ),
                                                    ],
                                                  ),
                                            );
                                          }
                                        } else {
                                          Utils.showSnackBar(
                                              context, 'Доступ ограничен');
                                        }
                                      },
                                      child: Container(
                                        height: 30,
                                        width: MediaQuery.of(context).size.width *
                                            0.4,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: Color(0xbaa85100),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            "Путевые листы",
                                            style: TextStyle(
                                                color: Color(0xffFFF3E9),
                                                fontWeight: FontWeight.w400,
                                                fontSize: 18,
                                                fontFamily: "Ghotic"),
                                          ),
                                        ),
                                      ),
                                    ),



                                    MaterialButton(
                                      onPressed: () {
                                        if (widget.employee.post.compareTo("Администратор") == 0) {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    EditCar(
                                                      car: widget.car,
                                                      employee: widget.employee,
                                                    ),
                                              ));
                                        } else {
                                          Utils.showSnackBar(
                                              context, 'Доступ ограничен');
                                        }
                                      },
                                      child: Container(
                                        height: 30,
                                        width: MediaQuery.of(context).size.width *
                                            0.4,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: Color(0xbaa85100),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            "Редактировать",
                                            style: TextStyle(
                                                color: Color(0xffFFF3E9),
                                                fontWeight: FontWeight.w400,
                                                fontSize: 18,
                                                fontFamily: "Ghotic"),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      });
                });
          }),
    );
  }

  Widget getDropDown(Box<Car> list) {
    if (list.isNotEmpty) {
      return DropdownButton(
          items: list.values
              .toList()
              .where((element) => element.status == "Доступен")
              .map((Car value) {
            return DropdownMenuItem<String>(
              value: value.numberCar,
              child: Text(value.numberCar),
            );
          }).toList(),
          onChanged: (value) {
            carNumber = value;
          });
    } else {
      return Container(child: Text("Все машины заняты или на ремонте"));
    }
  }

  @override
  // TODO: implement widget
  Widget buildDatePicker() => SizedBox(
    height: 180,
    child: CupertinoDatePicker(
        mode: CupertinoDatePickerMode.date,
        initialDateTime: DateTime.now(),
        onDateTimeChanged: (DateTime newDateTime) {
          setState(() => this.date = date);
        }),
  );

}
