import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef OnSuccess<T> = Future<void> Function(BuildContext context, T data);

class LisenerLoading<C extends StateStreamable<S>, S, T>
    extends StatelessWidget {
  const LisenerLoading({
    super.key,
    required this.child,
    required this.onSuccess,
    this.onError,
    this.onLoading,
  });

  final Widget child;
  final OnSuccess<T> onSuccess;

  /// لو عايز تتحكم في شكل اللودينج
  final VoidCallback? onLoading;

  /// لو عايز تعرض ايرور بطريقة مختلفة
  final void Function(BuildContext context, String error)? onError;

  @override
  Widget build(BuildContext context) {
    return BlocListener<C, S>(
      listener: (context, state) {
        // ✅ هنا بنستخدم dynamic عشان نستفيد من whenOrNull في freezed
        final s = state as dynamic;

        s.whenOrNull?.call(
          loading: () {
            if (onLoading != null) {
              onLoading!.call();
              return;
            }
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => const Center(child: CircularProgressIndicator()),
            );
          },
          success: (T data) async {
            // اقفل اللودينج لو مفتوح
            if (Navigator.canPop(context)) Navigator.pop(context);
            await onSuccess(context, data);
          },
          error: (String error) {
            if (Navigator.canPop(context)) Navigator.pop(context);
            if (onError != null) {
              onError!(context, error);
              return;
            }
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                icon: const Icon(Icons.error, color: Colors.red, size: 32),
                content: Text(error),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Got it'),
                  ),
                ],
              ),
            );
          },
        );
      },
      child: child,
    );
  }
}