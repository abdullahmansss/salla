import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla/modules/select_language/select_language_screen.dart';
import 'package:salla/shared/app_cubit/cubit.dart';
import 'package:salla/shared/app_cubit/states.dart';
import 'package:salla/shared/di/di.dart';
import 'package:salla/shared/network/remote/dio_helper.dart';

void main() async
{
  WidgetsFlutterBinding.ensureInitialized();

  DioHelper();
  await init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget
{
  @override
  Widget build(BuildContext context)
  {
    return MultiBlocProvider(
      providers:
      [
        BlocProvider(
          create: (context) => di<AppCubit>(),
        ),
      ],
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              fontFamily: 'Jannah',
              primarySwatch: Colors.blue,
            ),
            home: Directionality(
              textDirection: AppCubit.get(context).appDirection,
              child: SelectLanguageScreen(),
            ),
          );
        },
      ),
    );
  }
}