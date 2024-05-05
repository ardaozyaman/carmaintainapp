import 'package:carmaintainapp/models/users/user.dart';

import '../appointment.dart';
import '../car.dart';

class Employee extends User {
  List<Car> cars = [];
  List<Appointment> appointments = [];
  Employee({
    required int? id,
    required String name,
    required String surname,
    required String pass,
    required String mail,
    required String phone,
    required String type,
  }) : super(
    id: id,
    name: name,
    surname: surname,
    pass: pass,
    mail: mail,
    phone: phone,
    type: type,
  );

  factory Employee.fromMap(Map<String, dynamic> map) {
    return Employee(
      id: map['id'],
      name: map['name'],
      surname: map['surname'],
      pass: map['pass'],
      mail: map['mail'],
      phone: map['phone'],
      type: map['type'],
    );
  }


  @override
  Map<String, dynamic> toMap() {
    var map = super.toMap();
    //map['department'] = department;
    return map;
  }
}