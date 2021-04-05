import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla/modules/login/login_screen.dart';
import 'package:salla/modules/select_language/select_language_screen.dart';
import 'package:salla/shared/app_cubit/cubit.dart';
import 'package:salla/shared/app_cubit/states.dart';
import 'package:salla/shared/components/constants.dart';
import 'package:salla/shared/di/di.dart';
import 'package:salla/shared/network/remote/dio_helper.dart';

import 'layout/home_layout.dart';

void main() async
{
  WidgetsFlutterBinding.ensureInitialized();

  await init();

  appLanguage = await getAppLanguage();

  userToken = await getUserToken();

  String translation = await getTranslationFile(appLanguage);

  Widget start;

  if(appLanguage != null && userToken != null)
  {
    start = HomeLayout();
  } else if(appLanguage != null && userToken == null)
  {
    start = LoginScreen();
  } else
    {
      start = SelectLanguageScreen();
    }

  runApp(MyApp(
    translationFile: translation,
    code: appLanguage,
    start: start,
  ));
}

class MyApp extends StatelessWidget
{
  final String translationFile;
  final String code;
  final Widget start;

  const MyApp({
    @required this.translationFile,
    @required this.code,
    @required this.start,
  });

  @override
  Widget build(BuildContext context)
  {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => di<AppCubit>()..setLanguage(
            translationFile: translationFile,
            code: code,
          )..getHomeData()..getCategories()..getCart(),
        ),
      ],
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state)
        {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              fontFamily: 'Jannah',
              primarySwatch: Colors.blue,
              scaffoldBackgroundColor: Colors.white,
            ),
            home: Directionality(
              textDirection: AppCubit.get(context).appDirection,
              child: start,
            ),
          );
        },
      ),
    );
  }
}