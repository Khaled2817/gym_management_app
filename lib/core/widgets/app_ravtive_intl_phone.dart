import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:gym_management_app/core/theming/app_color_manager.dart';
import 'package:gym_management_app/core/theming/styles.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart' as pnp;

enum PhoneStoreFormat { national, e164 }

class AppReactiveIntlPhoneField extends ReactiveFormField<String, String> {
  AppReactiveIntlPhoneField({
    super.key,
    required String formControlName,
    String initialCountryCode = 'EG',
    String hintText = '010*****',
    InputDecoration? decoration,
    String initialValue = '',
    PhoneStoreFormat storeFormat = PhoneStoreFormat.national,
    void Function(PhoneNumber phone)? onPhoneChanged,
    Map<String, String Function(Object)>? validationMessages,
    bool enabled = true,
    bool lockCountry = false,
    int? maxLength,
    required BuildContext context,
  }) : super(
         formControlName: formControlName,
         validationMessages: validationMessages,
         showErrors: (c) => c.invalid && (c.touched || c.dirty),
         builder: (field) {
           final control = field.control;

           final errorText =
               (control.invalid && (control.touched || control.dirty))
               ? field.errorText
               : null;

           return Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               IntlPhoneField(
                 initialValue: initialValue,
                 style: TextStyleManager.font14Medium(context),
                 dropdownTextStyle: TextStyleManager.font14Medium(context),
                 keyboardType: TextInputType.phone,
                 enabled: enabled,
                 cursorColor: AppColorManager.primaryColor,
                 initialCountryCode: initialCountryCode,
                 disableLengthCheck: true,

                 showDropdownIcon: !lockCountry,
                 inputFormatters: [
                   FilteringTextInputFormatter.digitsOnly,
                   if (maxLength != null)
                     LengthLimitingTextInputFormatter(maxLength),
                 ],

                 decoration:
                     (decoration ??
                             InputDecoration(
                               hintText: hintText,
                               filled: true,
                               focusedErrorBorder: OutlineInputBorder(
                                 borderSide: const BorderSide(
                                   color: Colors.red,
                                   width: 1.3,
                                 ),
                                 borderRadius: BorderRadius.circular(16.0.r),
                               ),
                               errorBorder: OutlineInputBorder(
                                 borderSide: const BorderSide(
                                   color: Colors.red,
                                   width: 1.3,
                                 ),
                                 borderRadius: BorderRadius.circular(16.0.r),
                               ),
                               hintStyle:
                                   TextStyleManager.font14LightGrayRegular(
                                     context,
                                   ),
                               fillColor: AppColorManager.backGroundFeildColor,
                               border: OutlineInputBorder(
                                 borderRadius: BorderRadius.circular(16.r),
                                 borderSide: BorderSide.none,
                               ),
                             ))
                         .copyWith(
                           errorText: errorText,
                           errorStyle:
                               TextStyleManager.font13LighRedRegularError(
                                 context,
                               ),
                           // ✅ Counter يدوي يظهر 3/11
                           counter: maxLength == null
                               ? null
                               : ReactiveValueListenableBuilder<String>(
                                   formControlName: formControlName,
                                   builder: (context, c, _) {
                                     final v = (c.value ?? '').toString();
                                     final len = v.length;
                                     return Text('$len/$maxLength');
                                   },
                                 ),
                         ),

                 onChanged: (phone) {
                   control.markAsTouched();

                   final rawInternational = phone.completeNumber
                       .trim()
                       .replaceAll(RegExp(r'[\s\-\(\)]'), '');

                   String value = rawInternational;

                   // ✅ طبّع الرقم (يشيل 0 المحلية لو موجودة ويطلع فورمات صح حسب الدولة)
                   try {
                     final parsed = pnp.PhoneNumber.parse(rawInternational);
                     value = parsed.international.replaceAll(
                       ' ',
                       '',
                     ); // غالبًا هيكون +....
                     // لو عندك parsed.e164 في نسختك استخدمه بدل international
                   } catch (_) {
                     value = rawInternational;
                   }

                   field.didChange(value);
                   control.updateValueAndValidity();
                   onPhoneChanged?.call(phone);
                 },

                 onCountryChanged: (_) {
                   control.markAsTouched();
                   control.updateValueAndValidity();
                 },
               ),

               //  if (errorText != null)
               //    Padding(
               //      padding: EdgeInsets.only(top: 6, left: 25.w),
               //      child: Text(
               //        errorText,
               //        style: TextStyleManager.font13LighRedRegularError(context),
               //      ),
               //    ),
             ],
           );
         },
       );

  // static String _normalizeEgyptNational(String v) {
  //   if (v.isEmpty) return v;
  //   return v.startsWith('0') ? v : '0$v';
  // }
}
