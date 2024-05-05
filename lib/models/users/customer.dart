import 'package:carmaintainapp/models/users/user.dart';

import '../appointment.dart';
import '../car.dart';

class Customer extends User {
  List<Car> cars = [];
  List<Appointment> appointments = [];

  Customer({
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

  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
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
    //map['address'] = address;
    return map;
  }
}
