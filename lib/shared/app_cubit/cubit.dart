import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla/shared/app_cubit/states.dart';

class AppCubit extends Cubit<AppStates>
{
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  List<bool> selectedLanguage =
  [
    false,
    false,
  ];

  int selectedLanguageIndex;

  TextDirection appDirection = TextDirection.ltr;

  changeSelectedLanguage(int index)
  {
    selectedLanguageIndex = index;

    for(int i = 0 ; i < selectedLanguage.length ; i ++)
    {
      if(i == index)
      {
        selectedLanguage[i] = true;
      } else
        {
          selectedLanguage[i] = false;
        }
    }

    emit(AppSelectLanguageState());
  }
}