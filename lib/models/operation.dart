class Operation {
  int id;
  int appointmentId;
  String operationType;
  double cost;

  Operation({
    required this.id,
    required this.appointmentId,
    required this.operationType,
    required this.cost,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'appointmentId': appointmentId,
      'operationType': operationType,
      'cost': cost,
    };
  }

  static Operation fromMap(Map<String, dynamic> map) {
    return Operation(
      id: map['id'],
      appointmentId: map['appointmentId'],
      operationType: map['operationType'],
      cost: map['cost'],
    );
  }
}
