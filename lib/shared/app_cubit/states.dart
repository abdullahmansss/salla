import 'package:salla/models/home/home_model.dart';

abstract class AppStates {}

class AppInitialState extends AppStates {}

class AppSelectLanguageState extends AppStates {}

class AppChangeBottomIndexState extends AppStates {}

class AppSetLanguageState extends AppStates {}

class AppSetAppDirectionState extends AppStates {}

class AppSuccessState extends AppStates
{
  final HomeModel homeModel;

  AppSuccessState(this.homeModel);
}

class AppErrorState extends AppStates
{
  final String error;

  AppErrorState(this.error);
}