import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teacher_mate/core/api/api_handler.dart';
import 'package:teacher_mate/core/api/auth_interceptors.dart';
import 'package:teacher_mate/core/api/dio_helper.dart';
import 'package:teacher_mate/src/bloc/auth_bloc/auth_bloc.dart';
import 'package:teacher_mate/src/bloc/config_bloc/config_bloc.dart';
import 'package:teacher_mate/src/bloc/lesson_bloc/lesson_bloc.dart';
import 'package:teacher_mate/src/bloc/settings_bloc/settings_bloc.dart';
import 'package:teacher_mate/src/bloc/student_bloc/student_bloc.dart';
import 'package:teacher_mate/src/bloc/user_details_bloc/user_details_bloc.dart';
import 'package:teacher_mate/src/config/i_app_config.dart';
import 'package:teacher_mate/src/repository/auth_repository/auth_repository.dart';
import 'package:teacher_mate/src/repository/lesson_repository/lesson_repository.dart';
import 'package:teacher_mate/src/repository/student_repository/student_repository.dart';
import 'package:teacher_mate/src/repository/user_details_repository/user_details_repository.dart';
import 'package:teacher_mate/core/router/app_router.dart';

final injector = GetIt.instance;

Future<void> initInjector(IAppConfig config) async {
  await _registerLibraries();
  await _registerApi(config);
  // await _registerUtils();
  // await _registerServices();
  await _registerRepositories();
  await _registerBloc();
}

Future<void> _registerLibraries() async {
  final sharedPrefs = await SharedPreferences.getInstance();
  injector.registerSingleton<SharedPreferences>(sharedPrefs);
}

Future<void> _registerApi(IAppConfig config) async {
  injector.registerSingleton(
    AuthInterceptor(),
  );
  injector.registerSingleton<DioHelper>(
    DioHelper(
      authInterceptor: injector.get(),
    ),
  );

  injector.registerSingleton(
    ApiHandler(
      injector.get<DioHelper>().dio,
      baseUrl: config.baseUrl,
    ),
  );
}

// Future<void> _registerUtils() async {
//   injector.registerSingleton<AppRouter>(AppRouter(sharedPreferences: injector.get()));
// }

Future<void> _registerRepositories() async {
  injector.registerSingleton<ILessonRepository>(
    LessonRepository(
      injector.get(),
    ),
  );

  injector.registerSingleton<IStudentRepository>(
    StudentRepository(
      injector.get(),
    ),
  );

  injector.registerSingleton<IAuthRepository>(
    AuthRepository(
      injector.get(),
      injector.get(),
    ),
  );

  injector.registerSingleton<IUserDetailsRepository>(
    UserDetailsRepository(
      injector.get(),
    ),
  );
}

Future<void> _registerBloc() async {
  injector.registerFactory<LessonBloc>(
    () => LessonBloc(
      injector.get(),
    ),
  );

  injector.registerFactory<SettingsBloc>(
    () => SettingsBloc(
        // injector.get(),
        ),
  );

  injector.registerFactory<StudentBloc>(
    () => StudentBloc(
      injector.get(),
    ),
  );

  injector.registerSingleton<UserDetailsBloc>(
    UserDetailsBloc(
      injector.get(),
    ),
  );

  injector.registerSingleton<AuthBloc>(
    AuthBloc(
      injector.get(),
      injector.get(),
    ),
  );

  injector.registerSingleton<ConfigBloc>(
    ConfigBloc(),
  );
}
