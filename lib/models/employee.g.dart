part of 'employee.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EmployeeAdapter extends TypeAdapter<Employee> {
  @override
  final typeId = 0;

  @override
  Employee read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    print(fields.values.toString());
    return Employee(
      post: fields[1] as String,
      login: fields[2] as String,
      password: fields[3] as String,
      birthday: fields[4] as DateTime,
      phone: fields[5] as String,
      email: fields[6] as String,
      name: fields[7] as String,
    )..id = fields[0] as int;
  }

  @override
  void write(BinaryWriter writer, Employee obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.post)
      ..writeByte(2)
      ..write(obj.login)
      ..writeByte(3)
      ..write(obj.password)
      ..writeByte(4)
      ..write(obj.birthday)
      ..writeByte(5)
      ..write(obj.phone)
      ..writeByte(6)
      ..write(obj.email)
      ..writeByte(7)
      ..write(obj.name);
  }
}

class CarAdapter extends TypeAdapter<Car> {
  @override
  final typeId = 1;

  @override
  Car read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    print(fields.values.toString());
    return Car(
      numberCar: fields[1] as String,
      status: fields[2] as String,
      destination: fields[3] as String,
      technicalStatus: fields[4] as String,
      employeeId: fields[5] as int,
    )..id = fields[0] as int;
  }

  @override
  void write(BinaryWriter writer, Car obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.numberCar)
      ..writeByte(2)
      ..write(obj.status)
      ..writeByte(3)
      ..write(obj.destination)
      ..writeByte(4)
      ..write(obj.technicalStatus)
      ..writeByte(5)
      ..write(obj.employeeId);
  }
}

class PathListAdapter extends TypeAdapter<PathList> {
  @override
  final typeId = 2;

  @override
  PathList read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    print(fields.values.toString());
    return PathList(
      numberCar: fields[1] as String,
      date: fields[2] as DateTime,
      image: fields[3] as File,
    )..id = fields[0] as int;
  }

  @override
  void write(BinaryWriter writer, PathList obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.numberCar)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.image);
  }
}

class StoreAdapter extends TypeAdapter<Store> {
  @override
  final typeId = 3;

  @override
  Store read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    print(fields.values.toString());
    return Store(
      name: fields[1] as String,
      remains: fields[2] as int,
      manufacturer: fields[3] as String,
      desc: fields[4] as String,
    )..id = fields[0] as int;
  }

  @override
  void write(BinaryWriter writer, Store obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.remains)
      ..writeByte(3)
      ..write(obj.manufacturer)
      ..writeByte(4)
      ..write(obj.desc);
  }
}
