import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla/modules/login/cubit/states.dart';
import 'package:salla/shared/components/end_points.dart';
import 'package:salla/shared/network/remote/dio_helper.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());

  static LoginCubit get(context) => BlocProvider.of(context);

  userLogin({
    @required String email,
    @required String password,
  })
  {
    DioHelper.postData(
      path: LOGIN,
      data: {
        'email':'abdelrahman123968754@gmail.com',
        'password':'123456',
      },
    ).then((value)
    {
      print(value.data.toString());
      emit(LoginSuccessState());
    }).catchError((error) {
      emit(LoginErrorState(error));
    });
  }
}
