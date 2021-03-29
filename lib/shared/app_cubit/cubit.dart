import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla/models/add_cart/add_cart_model.dart';
import 'package:salla/models/add_fav/add_fav_model.dart';
import 'package:salla/models/categories/categories.dart';
import 'package:salla/models/home/home_model.dart';
import 'package:salla/modules/cart/cart_screen.dart';
import 'package:salla/modules/categories/categories_screen.dart';
import 'package:salla/modules/home/home_screen.dart';
import 'package:salla/modules/settings/settings_screen.dart';
import 'package:salla/shared/app_cubit/states.dart';
import 'package:salla/shared/components/constants.dart';
import 'package:salla/shared/language/app_language_model.dart';
import 'package:salla/shared/network/repository.dart';

class AppCubit extends Cubit<AppStates> {
  final Repository repository;

  AppCubit(this.repository) : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  List<bool> selectedLanguage = [
    false,
    false,
  ];

  int selectedLanguageIndex;

  void changeSelectedLanguage(int index) {
    selectedLanguageIndex = index;

    for (int i = 0; i < selectedLanguage.length; i++) {
      if (i == index) {
        selectedLanguage[i] = true;
      } else {
        selectedLanguage[i] = false;
      }
    }

    emit(AppSelectLanguageState());
  }

  AppLanguageModel languageModel;
  TextDirection appDirection = TextDirection.ltr;

  Future<void> setLanguage({
    @required String translationFile,
    @required String code,
  }) async {
    languageModel = AppLanguageModel.fromJson(json.decode(translationFile));
    appDirection = code == 'ar' ? TextDirection.rtl : TextDirection.ltr;

    emit(AppSetLanguageState());
  }

  List<Widget> bottomWidgets = [
    HomeScreen(),
    CategoriesScreen(),
    CartScreen(),
    SettingsScreen(),
  ];

  int currentIndex = 0;

  void changeBottomIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomIndexState());
  }

  HomeModel homeModel;
  List<bool> favourites = [];
  List<bool> cart = [];
  int cartProductsNumber = 0;

  getHomeData() {
    emit(AppLoadingState());

    repository
        .getHomeData(
      token: userToken,
    )
        .then((value) {
      homeModel = HomeModel.fromJson(value.data);

      homeModel.data.products.forEach((element) {
        favourites.add(element.inFavorites);
        cart.add(element.inCart);

        if(element.inCart)
        {
          cartProductsNumber++;
        }
      });

      emit(AppSuccessState(homeModel));

      print(value.data.toString());
    }).catchError((error) {
      print(error.toString());
      emit(AppErrorState(error.toString()));
    });
  }

  CategoriesModel categoriesModel;

  getCategories()
  {
    repository
        .getCategories()
        .then((value)
    {
      categoriesModel = CategoriesModel.fromJson(value.data);

      emit(AppCategoriesSuccessState());

      print(value.data.toString());
    }).catchError((error) {
      print(error.toString());
      emit(AppCategoriesErrorState(error.toString()));
    });
  }

  AddFavModel addFavModel;

  changeFav({
    @required int id,
    @required int index,
  }) {
    print(index);
    print(id);

    favourites[index] = !favourites[index];

    emit(AppChangeFavLoadingState());

    repository
        .addOrRemoveFavourite(
      token: userToken,
      id: id,
    )
        .then((value)
    {
      print(value.data);
      addFavModel = AddFavModel.fromJson(value.data);

      if(addFavModel.status == false)
      {
        favourites[index] = !favourites[index];
      }

      emit(AppChangeFavSuccessState());
    }).catchError((error)
    {
      favourites[index] = !favourites[index];
      emit(AppChangeFavErrorState(error.toString()));
    });
  }

  AddCartModel addCartModel;

  changeCart({
    @required int id,
    @required int index,
  }) {
    print(index);
    print(id);

    changeLocalCart(index);

    emit(AppChangeCartLoadingState());

    repository
        .addOrRemoveCart(
      token: userToken,
      id: id,
    )
        .then((value)
    {
      print(value.data);
      addCartModel = AddCartModel.fromJson(value.data);

      if(addCartModel.status == false)
      {
        changeLocalCart(index);
      }

      emit(AppChangeCartSuccessState());
    }).catchError((error)
    {
      changeLocalCart(index);

      emit(AppChangeCartErrorState(error.toString()));
    });
  }

  void changeLocalCart(index)
  {
    cart[index] = !cart[index];

    if(cart[index])
    {
      cartProductsNumber++;
    } else
    {
      cartProductsNumber--;
    }

    emit(AppChangeCartLocalState());
  }
}
