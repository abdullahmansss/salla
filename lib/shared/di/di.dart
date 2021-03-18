import 'package:get_it/get_it.dart';
import 'package:salla/shared/app_cubit/cubit.dart';
import 'package:salla/shared/network/local/cache_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

GetIt di = GetIt.I..allowReassignment = true;

Future init() async
{
  final sp = await SharedPreferences.getInstance();

  di.registerLazySingleton<SharedPreferences>(
        () => sp,
  );

  di.registerLazySingleton<CacheHelper>(
        () => CacheImplementation(
      di<SharedPreferences>(),
    ),
  );

  di.registerFactory<AppCubit>(
        () => AppCubit(),
  );
}