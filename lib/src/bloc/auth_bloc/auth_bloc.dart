// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:teacher_mate/src/repository/auth_repository/auth_repository.dart';

sealed class AuthEvent {
  const AuthEvent();

  const factory AuthEvent.init() = AuthInitEvent;

  const factory AuthEvent.logout() = AuthLogoutEvent;
}

class AuthInitEvent extends AuthEvent {
  const AuthInitEvent();
}

class AuthLogoutEvent extends AuthEvent {
  const AuthLogoutEvent();
}

class AuthState {
  final String token;
  const AuthState({required this.token});
  const factory AuthState.authed({
    required String token,
  }) = AuthState;
  factory AuthState.notAuthed() => const AuthState(token: '');
}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  IAuthRepository authRepository;
  AuthBloc(
    this.authRepository,
  ) : super(AuthState.notAuthed()) {
    on<AuthInitEvent>(_init);
    on<AuthLogoutEvent>(_logout);
  }

  Future<void> _init(AuthInitEvent event, Emitter<AuthState> emitter) async {
    final token = await authRepository.checkAuth();
    if (token.isNotEmpty) {
      emitter(AuthState.authed(token: token));
      return;
    }
    emitter(AuthState.notAuthed());
  }

  Future<void> _logout(
      AuthLogoutEvent event, Emitter<AuthState> emitter) async {
    emitter(
      AuthState.notAuthed(),
    );
    await authRepository.logout();
  }
}

// понять что такое AbstractDioAuthActions 
// понять зачем и почему dioHelper?.dioAuthActions = this;
// посмотреть в di
