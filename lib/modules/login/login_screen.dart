import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla/layout/home_layout.dart';
import 'package:salla/modules/login/cubit/cubit.dart';
import 'package:salla/modules/login/cubit/states.dart';
import 'package:salla/shared/app_cubit/cubit.dart';
import 'package:salla/shared/components/components.dart';
import 'package:salla/shared/components/constants.dart';
import 'package:salla/shared/di/di.dart';
import 'package:salla/shared/network/local/cache_helper.dart';
import 'package:salla/shared/styles/icon_broken.dart';
import 'package:salla/shared/styles/styles.dart';

class LoginScreen extends StatelessWidget {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: AppCubit.get(context).appDirection,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(),
        body: BlocProvider(
          create: (BuildContext context) => di<LoginCubit>(),
          child: BlocConsumer<LoginCubit, LoginStates>(
            listener: (context, state) {
              if (state is LoginSuccessState) {
                di<CacheHelper>()
                    .put('userData', state.userModel)
                    .then((value) {
                  di<CacheHelper>()
                      .put('userToken', state.userModel.data.token)
                      .then((value) {
                    navigateAndFinish(
                      context,
                      HomeLayout(),
                    );
                  }).catchError((error) {});
                }).catchError((error) {});
              }

              if (state is LoginErrorState) {
                showToast(
                  text: state.error,
                  color: ToastColors.ERROR,
                );
              }
            },
            builder: (context, state) {
              return Form(
                key: formKey,
                child: Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(
                            image: AssetImage('assets/images/logo.jpg'),
                            height: 150.0,
                          ),
                          Text(
                            appLang(context).loginTitle,
                            style: black20bold(),
                          ),
                          Text(
                            appLang(context).loginSubTitle,
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          TextFormField(
                            controller: emailController,
                            validator: (value) {
                              if (value.isEmpty) {
                                return appLang(context).emailValidation;
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                IconBroken.Message,
                              ),
                              labelText: appLang(context).email,
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          TextFormField(
                            controller: passwordController,
                            validator: (value) {
                              if (value.isEmpty) {
                                return appLang(context).passwordValidation;
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                IconBroken.Lock,
                              ),
                              suffixIcon: Icon(
                                IconBroken.Show,
                              ),
                              labelText: appLang(context).password,
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          defaultButton(
                            function: () {
                              if (formKey.currentState.validate()) {
                                LoginCubit.get(context).userLogin(
                                  email: emailController.text,
                                  password: passwordController.text,
                                );
                              }
                            },
                            text: appLang(context).login,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                appLang(context).donNotHave,
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                              TextButton(
                                onPressed: () {},
                                child: Text(
                                  appLang(context).registerNow,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
