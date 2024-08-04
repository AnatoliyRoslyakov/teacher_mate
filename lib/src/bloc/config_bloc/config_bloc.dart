import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

sealed class ConfigEvent {
  const ConfigEvent();

  const factory ConfigEvent.init() = ConfigInitEvent;
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
  late StreamSubscription<List<ConnectivityResult>> subscription;

  ConfigBloc() : super(ConfigState.initial()) {
    on<ConfigInitEvent>(_init);
    add(const ConfigInitEvent());
  }

  Future<void> _init(
      ConfigInitEvent event, Emitter<ConfigState> emitter) async {
    return emitter.forEach(Connectivity().onConnectivityChanged,
        onData: (data) {
      final isConnected = !data.contains(ConnectivityResult.none);
      return state.copyWith(isConnected: isConnected);
    });
  }

  @override
  Future<void> close() {
    subscription.cancel();
    return super.close();
  }
}
