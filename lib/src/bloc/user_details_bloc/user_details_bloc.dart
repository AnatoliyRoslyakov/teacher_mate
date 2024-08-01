import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teacher_mate/src/repository/user_details_repository/user_details_repository.dart';

sealed class UserDetailsEvent {
  const UserDetailsEvent();

  const factory UserDetailsEvent.init() = UserDetailsInitEvent;
}

class UserDetailsInitEvent extends UserDetailsEvent {
  const UserDetailsInitEvent();
}

class UserDetailsState {
  final String tgName;
  final String name;
  const UserDetailsState({required this.tgName, required this.name});
  factory UserDetailsState.initial() =>
      const UserDetailsState(tgName: '', name: '');

  UserDetailsState copyWith({
    String? tgName,
    String? name,
  }) {
    return UserDetailsState(
      tgName: tgName ?? this.tgName,
      name: name ?? this.name,
    );
  }
}

class UserDetailsBloc extends Bloc<UserDetailsEvent, UserDetailsState> {
  final IUserDetailsRepository userDetailsRepository;
  UserDetailsBloc(this.userDetailsRepository)
      : super(UserDetailsState.initial()) {
    on<UserDetailsInitEvent>(_init);
  }

  Future<void> _init(
      UserDetailsInitEvent event, Emitter<UserDetailsState> emitter) async {
    final result = await userDetailsRepository.getUserDetails();
    emitter(state.copyWith(name: result.name, tgName: result.username));
  }
}
