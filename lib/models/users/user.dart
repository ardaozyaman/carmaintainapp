/****************************************************************************
 **                              DÜZCE ÜNİVERSİTESİ
 **                          LİSANSÜSTÜ EĞİTİM ENSTİTÜSÜ
 **                       BİLGİSAYAR MÜHENDİLİĞİ ANABİLİM DALI
 **                       ÖĞRENCİ ADI :          ARDA ÖZYAMAN
 **                       ÖĞRENCİ NUMARASI :     2345007016
 **
 ****************************************************************************/
import 'customer.dart';
import 'employee.dart';
import 'enums/user_type.dart';

abstract class User {
  int? id;
  String name;
  String surname;
  String pass;
  String mail;
  String phone;
  String? personImage;
  String type;

  User({
    required this.id,
    required this.name,
    required this.surname,
    required this.pass,
    required this.mail,
    required this.phone,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'surname': surname,
      'pass': pass,
      'mail': mail,
      'phone': phone,
      'personImage': personImage,
      'type': type,
    };
  }

  static User fromMap(Map<String,dynamic> map){
    if(map['type']== UserType.employee.asString){
      return Employee.fromMap(map);
    }else{
      return Customer.fromMap(map);
    }
  }

}
