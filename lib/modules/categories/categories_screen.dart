import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla/models/categories/categories.dart';
import 'package:salla/modules/single_category/single_category_screen.dart';
import 'package:salla/shared/app_cubit/cubit.dart';
import 'package:salla/shared/app_cubit/states.dart';
import 'package:salla/shared/components/components.dart';

class CategoriesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context)
  {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state)
      {
        var categories = AppCubit.get(context).categoriesModel;

        return ConditionalBuilder(
          condition: categories != null,
          builder: (context) => ListView.separated(
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) => categoryItem(context, categories.data.data[index]),
            separatorBuilder: (context, index) => Container(
              width: double.infinity,
              height: 1.0,
              color: Colors.grey[300],
            ),
            itemCount: categories.data.data.length,
          ),
          fallback: (context) => Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  Widget categoryItem(context, ProductData model) => InkWell(
    onTap: (){
      navigateTo(context, SingleCategoryScreen(model.id, model.name),);
    },
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          Container(
            height: 40.0,
            width: 40.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                2.0,
              ),
              image: DecorationImage(
                image: NetworkImage(
                    '${model.image}',),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(
            width: 20.0,
          ),
          Text(
            '${model.name}',
          ),
          Spacer(),
          Icon(
            AppCubit.get(context).appDirection == TextDirection.ltr ? Icons.arrow_forward_ios : Icons.arrow_back_ios,
            size: 14.0,
          ),
        ],
      ),
    ),
  );
}
