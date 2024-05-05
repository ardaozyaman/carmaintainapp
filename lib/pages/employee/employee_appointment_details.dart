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

class EmployeeAppointmentDetailPage extends StatefulWidget {
  final Appointment appointment;

  const EmployeeAppointmentDetailPage({Key? key, required this.appointment})
      : super(key: key);

  @override
  State createState() => _EmployeeAppointmentDetailPageState();
}

class _EmployeeAppointmentDetailPageState
    extends State<EmployeeAppointmentDetailPage> {
  late TextEditingController _operationTypeController;
  late TextEditingController _costController;

  @override
  void initState() {
    super.initState();
    _operationTypeController = TextEditingController();
    _costController = TextEditingController();
  }

  @override
  void dispose() {
    _operationTypeController.dispose();
    _costController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Randevu Detayı'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Randevu Tarihi: ${widget.appointment.appointmentDate}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text('Araç Markası: ${widget.appointment.car!.brand}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 5),
            Text('Araç Modeli: ${widget.appointment.car!.modelName}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 5),
            Text('Açıklama: ${widget.appointment.description}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            const Text(
              'Operasyon Ekle',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _operationTypeController,
              decoration: const InputDecoration(labelText: 'Operasyon Türü'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _costController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Maliyet'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addOperation,
              child: const Text('Operasyon Ekle'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Geçmiş Operasyonlar:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            FutureBuilder<List<Operation>>(
              future: _getOperations(widget.appointment),
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

  void _addOperation() async {
    String operationType = _operationTypeController.text.trim();
    String cost = _costController.text;

    if (operationType.isNotEmpty) {
      Operation operation = Operation(
        appointmentId: widget.appointment.id!,
        operationType: operationType,
        cost: cost,
      );

      DbHelper dbHelper = DbHelper();
      await dbHelper.insertOperation(operation);

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Operasyon eklendi')));
      _clearFields();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lütfen tüm alanları doldurun')));
    }
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


  Future<List<Operation>> _getOperations(Appointment appointment) async {
    DbHelper dbHelper = DbHelper();
    return await dbHelper.getOperationsByAppointmentId(appointment.id!);
    //return await dbHelper.getOperationsByCarId(appointment.id!);
  }

  void _clearFields() {
    _operationTypeController.clear();
    _costController.clear();
  }
}
