enum AppointmentState{
  waiting,
  inProgress,
  finished,
  cancelled,
}


extension StateExtension on AppointmentState{
  String get asString{
    switch (this){
      case AppointmentState.cancelled:
        return "İptal";
      case AppointmentState.waiting:
        return "Bekliyor";
      case AppointmentState.inProgress:
        return "İşlemde";
      case AppointmentState.finished:
        return "Bitti";
    }
  }
  static AppointmentState fromString(String value) {
    switch (value) {
      case "İptal":
        return AppointmentState.cancelled;
      case "Bekliyor":
        return AppointmentState.waiting;
      case "İşlemde":
        return AppointmentState.inProgress;
      case "Bitti":
        return AppointmentState.finished;
      default:
        throw ArgumentError("Geçersiz durum: $value");
    }
  }
}



