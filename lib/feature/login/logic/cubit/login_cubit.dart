import 'package:bloc/bloc.dart';
import 'package:gym_management_app/core/api/api_result.dart';
import 'package:gym_management_app/core/api/token_storage.dart';
import 'package:gym_management_app/core/helpers/device_id_service.dart';
import 'package:gym_management_app/feature/login/data/model/login_request_body.dart';
import 'package:gym_management_app/feature/login/data/repo/login_repo.dart';
import 'package:gym_management_app/feature/login/logic/cubit/login_states.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

enum LoginType { email, phone }

// Egyptian phone validator
Map<String, dynamic>? egyptianPhoneValidator(AbstractControl<dynamic> control) {
  final phone = (control.value ?? '').toString().trim();
  if (phone.isEmpty) return null;
  final isValid = RegExp(r'^(010|011|012|015)\d{8}$').hasMatch(phone);
  return isValid ? null : {'invalidPhone': true};
}

class LoginCubit extends Cubit<LoginStates> {
  final LoginRepo _loginRepo;
  LoginCubit(this._loginRepo) : super(LoginStates.initial());
  final deviceId = DeviceIdService.getDeviceId();
  ValueNotifier<LoginType> loginType = ValueNotifier(LoginType.email);
  ValueNotifier<bool> rememberMe = ValueNotifier(false);
  static const String countryCode = '+20';
  final FormGroup form = FormGroup({
    'email': FormControl<String>(validators: [Validators.required]),
    'phone': FormControl<String>(
      validators: [
        Validators.required,
        Validators.delegate(egyptianPhoneValidator),
      ],
    ),
    'password': FormControl<String>(validators: [Validators.required]),
  });

  void toggleLoginType(LoginType type) {
    loginType.value = type;
    // Clear the fields when switching
    form.control('email').value = '';
    form.control('phone').value = '';
  }

  // Check if form is valid based on login type
  bool isFormValid() {
    final password = form.control('password').value ?? '';
    if (password.isEmpty) return false;
    if (loginType.value == LoginType.phone) {
      final phone = form.control('phone').value ?? '';
      if (phone.isEmpty) return false;
      // Check Egyptian phone format
      return RegExp(r'^(010|011|012|015)\d{8}$').hasMatch(phone);
    } else {
      final email = form.control('email').value ?? '';
      return email.isNotEmpty;
    }
  }

  void toggleRememberMe(bool value) {
    rememberMe.value = value;
  }

  // Get the username based on login type
  String getUserName() {
    if (loginType.value == LoginType.phone) {
      String phone = form.control('phone').value ?? '';
      // Remove leading 0 if exists (Egyptian numbers)
      if (phone.startsWith('0')) {
        phone = phone.substring(1);
      }
      return '$countryCode$phone';
    } else {
      return form.control('email').value ?? '';
    }
  }

  void emitLoginStates() async {
    emit(const LoginStates.loading());
    final deviceId = await DeviceIdService.getDeviceId();
    final response = await _loginRepo.login(
      LoginRequestBody(
        userName: getUserName(),
        password: form.control('password').value ?? '',
        deviceToken: "",
        deviceId: deviceId ?? "",
        rememberMe: rememberMe.value,
      ),
    );
    response.when(
      success: (loginResponse) async {
        await TokenStorage.saveLoginData(loginResponse);
        emit(LoginStates.success(loginResponse));
      },
      failure: (error) {
        emit(LoginStates.error(error: error.apiErrorModel.message ?? ''));
      },
    );
  }
}
