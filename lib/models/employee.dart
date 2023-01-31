import 'dart:io';
import 'dart:ui';

import 'package:hive/hive.dart';
part 'employee.g.dart';


@HiveType(typeId: 0)
class Employee extends HiveObject {
  @HiveField(0)
  int id;
  @HiveField(1)
  String post;
  @HiveField(2)
  String login;
  @HiveField(3)
  String password;
  @HiveField(4)
  DateTime birthday;
  @HiveField(5)
  String phone;
  @HiveField(6)
  String email;
  @HiveField(7)
  String name;

  Employee({this.id = -1, this.name = "", this.post = '', this.login = "", this.password, this.email, this.phone, this.birthday});


}

@HiveType(typeId: 1)
class Car extends HiveObject {
  @HiveField(0)
  int id;
  @HiveField(1)
  String numberCar;
  @HiveField(2)
  String status;
  @HiveField(3)
  String destination;
  @HiveField(4)
  String technicalStatus;
  @HiveField(5)
  int employeeId;

  Car({this.id = -1, this.numberCar = "", this.status = "Доступен", this.destination = "", this.technicalStatus, this.employeeId});


}

@HiveType(typeId: 2)
class PathList extends HiveObject {
  @HiveField(0)
  int id;
  @HiveField(1)
  String numberCar;
  @HiveField(2)
  DateTime date;
  @HiveField(3)
  File image;


  PathList({this.id = -1, this.numberCar = "", this.date, this.image});

}


@HiveType(typeId: 3)
class Store extends HiveObject {
  @HiveField(0)
  int id;
  @HiveField(1)
  String name;
  @HiveField(2)
  int remains;
  @HiveField(3)
  String manufacturer;
  @HiveField(4)
  String desc;


  Store({this.id = -1, this.name,this.remains, this.manufacturer, this.desc});

}

