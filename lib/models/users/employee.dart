/****************************************************************************
 **                              DÜZCE ÜNİVERSİTESİ
 **                          LİSANSÜSTÜ EĞİTİM ENSTİTÜSÜ
 **                       BİLGİSAYAR MÜHENDİLİĞİ ANABİLİM DALI
 **                       ÖĞRENCİ ADI :          ARDA ÖZYAMAN
 **                       ÖĞRENCİ NUMARASI :     2345007016
 **
 ****************************************************************************/
import 'package:carmaintainapp/models/users/user.dart';
import '../appointment.dart';
import '../car.dart';

class Employee extends User {
  List<Car> _cars = [];
  List<Appointment> _appointments = [];

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
    return map;
  }

  List<Appointment> get appointments => _appointments;

  set appointments(List<Appointment> value) {
    if(value.isEmpty){
      throw ArgumentError("Liste boş");
    }
    _appointments = value;
  }

  List<Car> get cars => _cars;

  set cars(List<Car> value) {
    _cars = value;
  }
}