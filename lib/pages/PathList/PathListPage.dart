import 'dart:developer';
import 'dart:io';

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

class PathListPage extends StatefulWidget {
  PathListPage({Key key, this.employee, this.pathList, this.car}) : super(key: key);
  Employee employee;
  PathList pathList;
  Car car;
  @override
  State<PathListPage> createState() => _PathListPageState();
}

class _PathListPageState extends State<PathListPage> {
  DateTime date;
  File _image;
  final _keyForm = GlobalKey<FormState>();
  ImagePicker imagePicker = new ImagePicker();
  String carNumber;
  int indexCar;
  Car car;


  @override
  Widget build(BuildContext context) {
    log((_image != null).toString());

    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: BottomNavBar(
        employee: widget.employee,
      ),
      backgroundColor: Color(0xfffff3e9),
      body: ValueListenableBuilder(
          valueListenable: Hive.box<PathList>(HiveBoxes.pathList).listenable(),
          builder: (context, Box<PathList> box, _) {
            return ValueListenableBuilder(
                valueListenable: Hive.box<Car>(HiveBoxes.car).listenable(),
                builder: (context, Box<Car> boxCar, _) {
                  return Center(
                    child: Form(
                      key: _keyForm,
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.fromLTRB(0, 60, 0, 0),
                            child: Text(
                              "Путевой лист",
                              style: TextStyle(
                                  color: Color(0xbaa85100),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 24,
                                  fontFamily: "Ghotic"),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
                            child: Table(
                              border: TableBorder.all(color: Color(0x6ea85100)),
                              children: [
                                TableRow(children: [
                                  const TableCell(
                                      verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                      child: Center(
                                          child: Text(
                                            "Дата отправления",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 18,
                                                fontFamily: "Ghotic"),
                                          ))),
                                  TableCell(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(8.0, 0, 8, 0),
                                          child: Text(
                                            '${widget.pathList.date.month}-${widget.pathList.date.day}-${widget.pathList.date.year}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 18,
                                                fontFamily: "Ghotic"),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ])
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                            child: Center(
                              child: GestureDetector(
                                child: Container(
                                  child: widget.pathList.image != null
                                      ? Image.file(
                                        widget.pathList.image,
                                        width: MediaQuery.of(context).size.width - 50,
                                        height: MediaQuery.of(context).size.height / 3,
                                        fit: BoxFit.scaleDown,
                                      )
                                      : Container(
                                    color: Color(0x6ea85100),
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width - 60,
                                    height: MediaQuery
                                        .of(context)
                                        .size
                                        .height * 0.40,
                                    child: Icon(
                                      Icons.camera_alt,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 18, 0, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                MaterialButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Container(
                                    height: 30,
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width * 0.4,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Color(0xbaa85100),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Назад",
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
                                          MaterialPageRoute(builder: (context) =>
                                              EditPathList(
                                                pathList: widget.pathList,
                                                employee: widget.employee,
                                                )));
                                    } else {
                                      Utils.showSnackBar(context, 'Доступ ограничен');
                                    }
                                  },
                                  child: Container(
                                    height: 30,
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width * 0.4,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Color(0xbaa85100),
                                    ),
                                    child: Center(
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
                          ),
                        ],
                      ),
                    ),
                  );
                }

            );
          }),
    );
  }
}