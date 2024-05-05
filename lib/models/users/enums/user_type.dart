enum UserType {
  customer,
  employee,
}

extension UserTypesAsString on UserType {
  String get asString {
    switch (this) {
      case UserType.employee:
        return "Employee";
      case UserType.customer:
        return "Customer";
    }
  }
}

Map<String, UserType> userTypeMap = {
  "Employee": UserType.employee,
  "Customer": UserType.customer,
};

UserType stringToUserType(String string) {
  return userTypeMap[string]!;
}

extension UserTypesAsInt on UserType {
  int get asInt {
    switch (this) {
      case UserType.employee:
        return 1;
      case UserType.customer:
        return 2;
    }
  }
}

extension UserTypesSetInt on UserType {
  UserType? fromInt(int a) {
    switch (a) {
      case 1:
        return UserType.employee;
      case 2:
        return UserType.customer;
      default:
        return UserType.employee;
    }
  }
}
