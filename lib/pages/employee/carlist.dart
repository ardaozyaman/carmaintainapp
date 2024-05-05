import 'package:carmaintainapp/data/dbhelper.dart';
import 'package:carmaintainapp/models/car.dart';
import 'package:flutter/material.dart';

class CarList extends StatelessWidget {
  const CarList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
            future: getAllCarsFromDB(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return listBuilder(snapshot.data!);
              } else {
                return const Padding(
                  padding: EdgeInsets.all(8),
                  child: LinearProgressIndicator(),
                );
              }
            }),
      ),
    );
  }

  Future<List<Car>> getAllCarsFromDB() async {
    DbHelper dbHelper = DbHelper();
    return dbHelper.getAllCars();
  }

  listBuilder(List<Car> cars) {
    return ListView.builder(
      itemCount: cars.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('${cars[index].brand} ${cars[index].modelName}'),
          subtitle: Text('Plaka: ${cars[index].licenseId}'),
          onTap: () {
            // Burada aracın detaylarına gitmek için bir işlev çağrılabilir.
            // Örneğin: Navigator.push(context, MaterialPageRoute(builder: (context) => VehicleDetailScreen(vehicle: vehicles[index])));
          },
        );
      },
    );
  }
}
