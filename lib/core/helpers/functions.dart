import 'package:intl_phone_field/phone_number.dart' as intl;
import 'package:reactive_forms/reactive_forms.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart' as pnp;

Map<String, String Function(Object)> validationEmailMessages() {
  return {
    ValidationMessage.required: (_) => 'Email is required',
    ValidationMessage.email: (_) => 'Please enter a valid email',
  };
}

Map<String, String Function(Object)> validationPasswordMessages() {
  return {
    ValidationMessage.required: (_) => 'Password is required',
    ValidationMessage.minLength: (_) =>
        'Password must be at least 8 characters',
    ValidationMessage.maxLength: (_) =>
        'Password must be at least 16 characters',
    ValidationMessage.pattern: (_) =>
        'Password must contain:\n'
        '• one lowercase letter\n'
        '• one uppercase letter\n'
        '• one number\n'
        '• one special character',
  };
}

/// ------------------------------
/// ✅ Phone validation messages
/// ------------------------------
Map<String, String Function(Object)> validationPhoneMessages({
  String requiredMsg = 'Phone number is required',
  String invalidMsg = 'Invalid phone number',
  String digitsOnlyMsg = 'Phone must contain digits only',
  String minDigitsMsg = 'Phone number is too short',
  String maxDigitsMsg = 'Phone number is too long',
}) {
  return {
    ValidationMessage.required: (_) => requiredMsg,
    // for custom validators
    'egPhone': (_) => invalidMsg, // Egypt
    'e164': (_) => invalidMsg, // +2010...
    'digitsOnly': (_) => digitsOnlyMsg,
    'minDigits': (_) => minDigitsMsg,
    'maxDigits': (_) => maxDigitsMsg,
  };
}

/// ✅ Egypt phone validator (010/011/012/015 + 8 digits)

Map<String, dynamic>? egyptPhoneValidator(AbstractControl<dynamic> control) {
  final raw = (control.value ?? '').toString().trim();
  if (raw.isEmpty) return null;
  final normalized = raw.startsWith('0') ? raw : '0$raw';
  final ok = RegExp(r'^(010|011|012|015)\d{8}$').hasMatch(normalized);
  return ok ? null : {'egPhone': true};
}

/// ✅ E164 validator (works for any country): +{7..15 digits}
/// Example: +2010xxxxxxx, +9665xxxxxxx

Map<String, dynamic>? e164Validator(AbstractControl<dynamic> control) {
  final v = (control.value ?? '').toString().trim();
  if (v.isEmpty) return null;
  final ok = RegExp(r'^\+\d{7,15}$').hasMatch(v);
  return ok ? null : {'e164': true};
}

/// ✅ Generic digits-length validator (any country local format)

ValidatorFunction digitsLengthValidator({required int min, required int max}) {
  return (AbstractControl<dynamic> control) {
    final v = (control.value ?? '').toString().trim();
    if (v.isEmpty) return null;
    if (!RegExp(r'^\d+$').hasMatch(v)) return {'digitsOnly': true};
    if (v.length < min) return {'minDigits': true};
    if (v.length > max) return {'maxDigits': true};

    return null;
  };
}

Map<String, dynamic>? internationalPhoneValidator(
  AbstractControl<dynamic> control,
) {
  final raw = (control.value ?? '').toString().trim();
  if (raw.isEmpty) return null;

  final v = raw.replaceAll(RegExp(r'[\s\-\(\)]'), '');
  if (!v.startsWith('+')) return {'e164': true};

  try {
    final parsed = pnp.PhoneNumber.parse(v);
    return parsed.isValid() ? null : {'e164': true};
  } catch (_) {
    return {'e164': true};
  }
}
String toE164AnyCountry(intl.PhoneNumber p) {
  // raw مثال فرنسا: +33 + 06xxxxxxxx
  // raw مثال مصر:  +20 + 010xxxxxxxx
  final raw = ('${p.countryCode}${p.number}')
      .replaceAll(RegExp(r'[\s\-\(\)]'), '');

  try {
    final parsed = pnp.PhoneNumber.parse(raw);

    // بعض الإصدارات فيها e164 مباشرة، وبعضها لا.
    // جرّب ده أولًا:
    // return parsed.e164;

    // لو مفيش e164 استخدم international وشيّل المسافات:
    return parsed.international.replaceAll(' ', '');
  } catch (_) {
    // fallback: رجّع raw زي ما هو (أو ارمي error)
    return raw;
  }
  
}

// String? fileToBase64(File? file) {
//   if (file == null) return null;
//   return base64Encode(file.readAsBytesSync());
// }
// extension SingUpRequestModelMapper on SingUpRequestModel {
//   Future<FormData> asFormData() async {
//     final map = toJson();
//     if (userImage != null) {
//       map['userImage'] = await MultipartFile.fromFile(
//         userImage!.path,
//         filename: userImage!.path.split('/').last,
//       );
//     }
//     return FormData.fromMap(map);
//   }
// }
/*
FormControl<String>(
  validators: [
    Validators.required,
    Validators.delegate(e164Validator),
  ],
);
*/

/*
FormControl<String>(
  validators: [
    Validators.required,
    digitsLengthValidator(min: 8, max: 12),
  ],
);
*/
