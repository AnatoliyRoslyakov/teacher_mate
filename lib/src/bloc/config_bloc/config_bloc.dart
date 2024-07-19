import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

sealed class ConfigEvent {
  const ConfigEvent();

  const factory ConfigEvent.inint() = ConfigInitEvent;
}

class ConfigInitEvent extends ConfigEvent {
  const ConfigInitEvent();
}

class ConfigState {
  final bool isConnected;
  const ConfigState({required this.isConnected});
  factory ConfigState.initial() => const ConfigState(isConnected: true);

  ConfigState copyWith({
    bool? isConnected,
  }) {
    return ConfigState(
      isConnected: isConnected ?? this.isConnected,
    );
  }
}

class ConfigBloc extends Bloc<ConfigEvent, ConfigState> {
  ConfigBloc() : super(ConfigState.initial()) {
    on<ConfigInitEvent>(_init);
  }

  Future<void> _init(
      ConfigInitEvent event, Emitter<ConfigState> emitter) async {
    final bool isConnected = await InternetConnectionChecker().hasConnection;
    emitter(state.copyWith(isConnected: isConnected));
  }
}
