/****************************************************************************
 **                              DÜZCE ÜNİVERSİTESİ
 **                          LİSANSÜSTÜ EĞİTİM ENSTİTÜSÜ
 **                       BİLGİSAYAR MÜHENDİLİĞİ ANABİLİM DALI
 **                       ÖĞRENCİ ADI :          ARDA ÖZYAMAN
 **                       ÖĞRENCİ NUMARASI :     2345007016
 **
 ****************************************************************************/
class Car {
  int? id;
  int customerId;
  String licenseId;
  String brand;
  String modelName;

  Car({
    this.id,
    required this.customerId,
    required this.licenseId,
    required this.brand,
    required this.modelName,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customerId': customerId,
      'licenseId': licenseId,
      'brand': brand,
      'modelName': modelName,
    };
  }

  static Car fromMap(Map<String, dynamic> map) {
    return Car(
      id: map['id'],
      customerId: map['customerId'],
      licenseId: map['licenseId'],
      brand: map['brand'],
      modelName: map['modelName'],
    );
  }
}