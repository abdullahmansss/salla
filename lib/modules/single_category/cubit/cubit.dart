import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla/models/single_category/single_category_model.dart';
import 'package:salla/modules/single_category/cubit/states.dart';
import 'package:salla/shared/app_cubit/cubit.dart';
import 'package:salla/shared/components/constants.dart';
import 'package:salla/shared/network/repository.dart';

class SingleCategoryCubit extends Cubit<SingleCategoryStates>
{
  final Repository repository;

  SingleCategoryCubit(this.repository) : super(SingleCategoryInitialState());

  static SingleCategoryCubit get(context) => BlocProvider.of(context);

  SingleCategoryModel singleCategoryModel;

  getCategories(int id, context)
  {
    emit(SingleCategoryLoadingState());

    repository
        .getSingleCategory(token: userToken, id: id)
        .then((value)
    {
      singleCategoryModel = SingleCategoryModel.fromJson(value.data);

      singleCategoryModel.data.data.forEach((element)
      {
        if(!AppCubit.get(context).favourites.containsKey(element.id))
        {
          AppCubit.get(context).favourites.addAll({
            element.id: element.inFavorites
          });
        }

        if(!AppCubit.get(context).cart.containsKey(element.id))
        {
          AppCubit.get(context).cart.addAll({
            element.id: element.inCart
          });

          if(element.inCart)
          {
            AppCubit.get(context).cartProductsNumber++;
          }
        }

      });

      emit(SingleCategorySuccessState());

      print(value.data.toString());
    }).catchError((error) {
      print(error.toString());
      emit(SingleCategoryErrorState(error.toString()));
    });
  }
}