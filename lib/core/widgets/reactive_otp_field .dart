import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:gym_management_app/core/helpers/spacing_helper.dart';
import 'package:gym_management_app/core/theming/app_color_manager.dart';
import 'package:gym_management_app/core/theming/styles.dart';
import 'package:gym_management_app/core/widgets/app_text_button.dart';
import 'package:gym_management_app/core/widgets/app_text_form_field.dart';

class OtpReactiveController {
  final int length;
  late final FormGroup form;
  OtpReactiveController({this.length = 4}) {
    form = FormGroup({
      for (int i = 0; i < length; i++)
        'otp_$i': FormControl<String>(validators: [Validators.required]),
    });
  }
  String get code => List.generate(
    length,
    (i) => (form.control('otp_$i').value ?? '') as String,
  ).join();

  bool validate() {
    form.markAllAsTouched();
    return form.valid;
  }

  void clear() {
    for (int i = 0; i < length; i++) {
      form.control('otp_$i').value = '';
    }
  }
}

class OtpVerifyWidgetReactive extends StatefulWidget {
  final OtpReactiveController controller;

  final String verifyText;
  final String resendPrefix;
  final String resendActionText;

  final Future<void> Function(String code) onVerify;
  final Future<void> Function()? onResend;

  final bool enableSmsAutofill;
  final Duration resendCooldown;

  final Color borderActiveColor;
  final Color borderInactiveColor;
  final Color digitColor;
  final List<Color> buttonGradient;

  final void Function(String code)? onCompleted;

  const OtpVerifyWidgetReactive({
    super.key,
    required this.controller,
    required this.onVerify,
    this.onResend,
    this.onCompleted,
    this.verifyText = 'Verify code',
    this.resendPrefix = "Haven’t got the email yet?",
    this.resendActionText = "Resend Code",
    this.enableSmsAutofill = true,
    this.resendCooldown = const Duration(seconds: 30),
    this.borderActiveColor = AppColorManager.primaryColor,
    this.borderInactiveColor = const Color(0xFFD9D9D9),
    this.digitColor = const Color(0xFF4A4A4A),
    this.buttonGradient = const [Color(0xFF1F73C9), Color(0xFF174E9E)],
  });

  @override
  State<OtpVerifyWidgetReactive> createState() =>
      _OtpVerifyWidgetReactiveState();
}

class _OtpVerifyWidgetReactiveState extends State<OtpVerifyWidgetReactive>
    with CodeAutoFill {
  late final List<FocusNode> _focusNodes;
  late final List<TextEditingController> _textControllers;

  Timer? _timer;
  final ValueNotifier<int> _secondsLeft = ValueNotifier<int>(0);

  bool get _cooldown => _secondsLeft.value > 0;

  @override
  void initState() {
    super.initState();

    _focusNodes = List.generate(widget.controller.length, (_) => FocusNode());
    _textControllers = List.generate(
      widget.controller.length,
      (_) => TextEditingController(),
    );

    for (int i = 0; i < widget.controller.length; i++) {
      final v =
          (widget.controller.form.control('otp_$i').value ?? '') as String;
      _textControllers[i].text = v;
    }

    if (widget.enableSmsAutofill) {
      listenForCode();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _secondsLeft.dispose();
    for (final f in _focusNodes) {
      f.dispose();
    }
    for (final c in _textControllers) {
      c.dispose();
    }
    cancel();
    super.dispose();
  }

  void _startCooldown() {
    _timer?.cancel();
    _secondsLeft.value = widget.resendCooldown.inSeconds;

    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsLeft.value <= 1) {
        t.cancel();
        _secondsLeft.value = 0;
      } else {
        _secondsLeft.value--;
      }
    });
  }

  @override
  void codeUpdated() {
    if (code == null) return;

    final digits = code!.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) return;

    for (int i = 0; i < widget.controller.length; i++) {
      final char = i < digits.length ? digits[i] : '';
      widget.controller.form.control('otp_$i').value = char;
      _textControllers[i].text = char;
      _textControllers[i].selection = TextSelection.collapsed(
        offset: char.length,
      );
    }

    FocusScope.of(context).unfocus();

    final c = widget.controller.code;
    if (c.length == widget.controller.length && !c.contains('')) {
      widget.onCompleted?.call(c);
    }
  }

  void _onChanged(int index, String value) {
    final digit = value.isEmpty ? '' : value[value.length - 1];

    widget.controller.form.control('otp_$index').value = digit;

    if (_textControllers[index].text != digit) {
      _textControllers[index].text = digit;
      _textControllers[index].selection = TextSelection.collapsed(
        offset: digit.length,
      );
    }

    if (digit.isNotEmpty) {
      if (index < widget.controller.length - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        FocusScope.of(context).unfocus();
      }
    }

    final c = widget.controller.code;
    if (c.length == widget.controller.length && !c.contains('')) {
      widget.onCompleted?.call(c);
    }
  }

  void _onBackspace(int index) {
    final current = _textControllers[index].text;

    if (current.isNotEmpty) {
      _onChanged(index, '');
      return;
    }

    if (index > 0) {
      _onChanged(index - 1, '');
      _focusNodes[index - 1].requestFocus();
    }
  }

  Future<void> _verify() async {
    if (!widget.controller.validate()) return;
    await widget.onVerify(widget.controller.code);
  }

  Future<void> _resend() async {
    if (_cooldown) return;
    if (widget.onResend == null) return;

    await widget.onResend!.call();
    _startCooldown();
  }

  @override
  Widget build(BuildContext context) {
    final len = widget.controller.length;

    return ReactiveForm(
      formGroup: widget.controller.form,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(len, (i) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: SizedBox(
                  width: 58,
                  height: 58,
                  child: _OtpBox(
                    focusNode: _focusNodes[i],
                    controller: _textControllers[i],
                    borderActive: widget.borderActiveColor,
                    borderInactive: widget.borderInactiveColor,
                    digitColor: widget.digitColor,
                    onChanged: (v) => _onChanged(i, v),
                    onBackspace: () => _onBackspace(i),
                  ),
                ),
              );
            }),
          ),
          verticalSpace(35),
          AppTextButton(
            buttonText: 'Verify Code',
            textStyle: TextStyleManager.font16BoldWhite(context),
            onPressed: _verify,
            backgroundGradient: AppColorManager.primaryLinearGradient,
          ),
          verticalSpace(30),
          ValueListenableBuilder<int>(
            valueListenable: _secondsLeft,
            builder: (_, secs, __) {
              final disabled = secs > 0 || widget.onResend == null;
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.resendPrefix,
                    style: TextStyleManager.font14GrayRegular(context),
                  ),
                  horizontalSpace(6),
                  GestureDetector(
                    onTap: disabled ? null : _resend,
                    child: Text(
                      secs > 0
                          ? '${widget.resendActionText} (${secs}s)'
                          : widget.resendActionText,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: disabled
                            ? const Color(0xFFB0B5BA)
                            : AppColorManager.primaryColor,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _OtpBox extends StatelessWidget {
  final FocusNode focusNode;
  final TextEditingController controller;
  final Color borderActive;
  final Color borderInactive;
  final Color digitColor;
  final ValueChanged<String> onChanged;
  final VoidCallback onBackspace;

  const _OtpBox({
    required this.focusNode,
    required this.controller,
    required this.borderActive,
    required this.borderInactive,
    required this.digitColor,
    required this.onChanged,
    required this.onBackspace,
  });

  @override
  Widget build(BuildContext context) {
    final isEmpty = controller.text.isEmpty;

    return RawKeyboardListener(
      focusNode: FocusNode(),
      onKey: (event) {
        if (event is RawKeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.backspace) {
          onBackspace();
        }
      },
      child: Directionality(
        // ✅ مهم: يمنع ميل الرقم يمين/شمال في RTL
        textDirection: TextDirection.ltr,
        child: SizedBox(
          height: 58, // نفس حجم البوكس
          child: Center(
            // ✅ يثبتها في النص عموديًا
            child: AppTextFormField(
              focusNode: focusNode,
              controller: controller,
              hintText: '',
              textAlign: TextAlign.center,
              textAlignVertical: TextAlignVertical.center,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              maxLength: 1,

              // ✅ أهم سطرين: بدون padding + dense
              contentPadding: EdgeInsets.symmetric(vertical: 30.h),

              inputTextStyle: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: digitColor,
                height: 1.0,
              ),

              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(1),
              ],

              backgroundColor: Colors.white,
              enabledBorderColor: isEmpty ? borderInactive : borderActive,

              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: borderActive, width: 2),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: isEmpty ? borderInactive : borderActive,
                  width: 2,
                ),
              ),

              validator: (_) => null,
              onChanged: onChanged,
            ),
          ),
        ),
      ),
    );
  }
}
