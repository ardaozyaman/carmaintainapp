/****************************************************************************
 **                              DÜZCE ÜNİVERSİTESİ
 **                          LİSANSÜSTÜ EĞİTİM ENSTİTÜSÜ
 **                       BİLGİSAYAR MÜHENDİLİĞİ ANABİLİM DALI
 **                       ÖĞRENCİ ADI :          ARDA ÖZYAMAN
 **                       ÖĞRENCİ NUMARASI :     2345007016
 **
 ****************************************************************************/


import 'package:flutter/material.dart';
import 'package:carmaintainapp/models/appointment.dart';
import 'package:carmaintainapp/data/dbhelper.dart';
import 'package:carmaintainapp/models/operation.dart';

class AppointmentDetailPage extends StatelessWidget {
  final Appointment appointment;

  const AppointmentDetailPage({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Randevu Detayı'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Randevu Tarihi: ${appointment.appointmentDate}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text('Araç Markası: ${appointment.car!.brand}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 5),
            Text('Araç Modeli: ${appointment.car!.modelName}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 5),
            Text('Açıklama: ${appointment.description}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            const Text(
              'Operasyonlar:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            FutureBuilder<List<Operation>>(
              future: _getOperations(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return _buildOperationList(snapshot.data!);
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<List<Operation>> _getOperations() async {
    DbHelper dbHelper = DbHelper();
    return await dbHelper.getOperationsByAppointmentId(appointment.id!);
  }

  Widget _buildOperationList(List<Operation> operations) {
    if (operations.isEmpty) {
      return const Text('Bu randevu için henüz operasyon yapılmamış.');
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: operations.map((operation) {
          return ListTile(
            title: Text('Operasyon: ${operation.operationType}'),
            subtitle: Text('Maliyet: ${operation.cost}'),
          );
        }).toList(),
      );
    }
  }
}
