import 'package:get_it/get_it.dart';
import 'package:teacher_mate/core/api/api_handler.dart';
import 'package:teacher_mate/core/api/dio_helper.dart';
import 'package:teacher_mate/src/bloc/calendar_bloc/calendar_bloc.dart';
import 'package:teacher_mate/src/config/i_app_config.dart';
import 'package:teacher_mate/src/repository/calendar_repository/calendar_repository.dart';

final injector = GetIt.instance;

Future<void> initInjector(IAppConfig config) async {
  await _registerApi(config);
  // await _registerUtils();
  // await _registerServices();
  await _registerRepositories();
  await _registerBloc();
}

Future<void> _registerApi(IAppConfig config) async {
  injector.registerSingleton<DioHelper>(
    DioHelper(),
  );

  injector.registerSingleton(
    ApiHandler(
      injector.get<DioHelper>().dio,
      baseUrl: config.baseUrl,
    ),
  );
}

Future<void> _registerRepositories() async {
  injector.registerSingleton<ICalendarRepository>(
    CalendarRepository(
      injector.get(),
    ),
  );
}

Future<void> _registerBloc() async {
  injector.registerSingleton<CalendarBloc>(
    CalendarBloc(
      injector.get(),
    ),
  );
}
