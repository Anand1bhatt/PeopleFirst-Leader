import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants/app_constants.dart';

class ToastState {
  final String? message;
  final bool visible;

  const ToastState({this.message, this.visible = false});

  ToastState copyWith({String? message, bool? visible}) {
    return ToastState(
      message: message ?? this.message,
      visible: visible ?? this.visible,
    );
  }
}

class ToastNotifier extends StateNotifier<ToastState> {
  ToastNotifier() : super(const ToastState());

  void show(String message) {
    state = ToastState(message: message, visible: true);
    Future.delayed(AppConstants.toastDuration, () {
      if (mounted) {
        state = state.copyWith(visible: false);
      }
    });
  }

  void dismiss() {
    state = state.copyWith(visible: false);
  }
}

final toastProvider = StateNotifierProvider<ToastNotifier, ToastState>(
  (ref) => ToastNotifier(),
);
