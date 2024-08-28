import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:teacher_mate/core/api/auth_interceptors.dart';
import 'package:teacher_mate/core/api/dio_auth_action.dart';
import 'package:teacher_mate/src/repository/auth_repository/auth_repository.dart';

sealed class AuthEvent {
  const AuthEvent();

  const factory AuthEvent.init() = AuthInitEvent;

  const factory AuthEvent.logout() = AuthLogoutEvent;

  const factory AuthEvent.updateCode(String code) = AuthUpdateCodeEvent;

  const factory AuthEvent.getToken() = AuthGetTokenEvent;
}

class AuthInitEvent extends AuthEvent {
  const AuthInitEvent();
}

class AuthLogoutEvent extends AuthEvent {
  const AuthLogoutEvent();
}

class AuthGetTokenEvent extends AuthEvent {
  const AuthGetTokenEvent();
}

class AuthUpdateCodeEvent extends AuthEvent {
  final String code;
  const AuthUpdateCodeEvent(this.code);
}

class AuthState {
  final String token;
  final String code;
  final bool isFirstStart;
  final bool failur;
  const AuthState({
    required this.failur,
    required this.isFirstStart,
    required this.code,
    required this.token,
  });

  factory AuthState.notAuthed() => const AuthState(
        isFirstStart: false,
        code: '',
        token: '',
        failur: false,
      );

  AuthState copyWith({
    String? token,
    String? code,
    bool? isFirstStart,
    bool? failur,
  }) {
    return AuthState(
      token: token ?? this.token,
      code: code ?? this.code,
      isFirstStart: isFirstStart ?? this.isFirstStart,
      failur: failur ?? this.failur,
    );
  }
}

class AuthBloc extends Bloc<AuthEvent, AuthState>
    implements AbstractDioAuthActions {
  IAuthRepository authRepository;
  final AuthInterceptor authInterceptor;
  AuthBloc(this.authRepository, this.authInterceptor)
      : super(AuthState.notAuthed()) {
    authInterceptor.authActions = this;
    on<AuthInitEvent>(_init);
    on<AuthUpdateCodeEvent>(_updateCode);
    on<AuthLogoutEvent>(_logout);
    on<AuthGetTokenEvent>(_getToken);
  }

  Future<void> _init(AuthInitEvent event, Emitter<AuthState> emitter) async {
    String token = await authRepository.checkAuth();
    bool firstStart = await authRepository.checkFirstLaunch();
    if (token.isNotEmpty) {
      emitter(state.copyWith(token: token, isFirstStart: false));
      return;
    }
    emitter(state.copyWith(isFirstStart: firstStart));
  }

  Future<void> _logout(
      AuthLogoutEvent event, Emitter<AuthState> emitter) async {
    emitter(
      AuthState.notAuthed(),
    );

    await authRepository.logout();
  }

  Future<void> _getToken(
      AuthGetTokenEvent event, Emitter<AuthState> emitter) async {
    try {
      String token = await authRepository.login(code: state.code);
      log(token);
      emitter(state.copyWith(token: token, isFirstStart: false, failur: false));
    } catch (e) {
      emitter(
        state.copyWith(failur: true),
      );
      emitter(
        state.copyWith(failur: false),
      );
    }
  }

  Future<void> _updateCode(
      AuthUpdateCodeEvent event, Emitter<AuthState> emitter) async {
    emitter(state.copyWith(code: event.code, isFirstStart: false));
  }

  @override
  void onUnAuthedError() {}

  @override
  String? get token => state.token;
}
