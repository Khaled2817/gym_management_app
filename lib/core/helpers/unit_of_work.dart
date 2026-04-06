// import 'package:checkinapp/Data/repository/attendance_repo.dart';
// import 'package:checkinapp/Data/repository/authentication_repo.dart';
// import 'package:checkinapp/Data/repository/employee_repo.dart';
// import 'package:checkinapp/Data/repository/lopkup_repo.dart';
// import 'package:checkinapp/Data/repository/shift_repo.dart';
// import 'package:checkinapp/Data/repository/user_repo.dart';
// import 'package:checkinapp/Data/repository/user_type_repo.dart';

// class UnitOfWork {
//   final AuthenticationRepo authenticationRepo;
//   final EmployeeRepo employeeRepo;
//   final AttendanceRepo attendanceRepo;
//   final LookupRepository lookupRepository;
//   final UserTypeRepo userTypeRepo;
//   final UserRepo userRepo;
//   final ShiftRepo shiftRepo;

//   static final UnitOfWork _instance = UnitOfWork._internal();

//   factory UnitOfWork() => _instance;

//   UnitOfWork._internal()
//       : authenticationRepo = AuthenticationRepo(),
//         attendanceRepo = AttendanceRepo(),
//         lookupRepository = LookupRepository(),
//         userRepo = UserRepo(),
//         userTypeRepo = UserTypeRepo(),
//         shiftRepo = ShiftRepo(),
//         employeeRepo = EmployeeRepo();
// }