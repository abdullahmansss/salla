import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla/models/home/home_model.dart';
import 'package:salla/modules/single_category/cubit/cubit.dart';
import 'package:salla/modules/single_category/cubit/states.dart';
import 'package:salla/shared/app_cubit/cubit.dart';
import 'package:salla/shared/app_cubit/states.dart';
import 'package:salla/shared/components/constants.dart';
import 'package:salla/shared/di/di.dart';
import 'package:salla/shared/styles/colors.dart';
import 'package:salla/shared/styles/icon_broken.dart';
import 'package:salla/shared/styles/styles.dart';

class SingleCategoryScreen extends StatelessWidget
{
  final int id;
  final String title;

  SingleCategoryScreen(this.id, this.title);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => di<SingleCategoryCubit>()..getCategories(id, context),
      child: BlocConsumer<SingleCategoryCubit, SingleCategoryStates>(
        listener: (context, state) {},
        builder: (context, state)
        {
          var model = SingleCategoryCubit.get(context).singleCategoryModel;

          return Scaffold(
            appBar: AppBar(
              title: Text(
                title,
              ),
            ),
            body: ConditionalBuilder(
              condition: model != null,
              builder: (context) => ListView.separated(
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) => singleProductItem(
                  model: model.data.data[index],
                  context: context,
                  index: index,
                ),
                separatorBuilder: (context, index) => Container(
                  width: double.infinity,
                  height: 1.0,
                  color: Colors.grey[300],
                ),
                itemCount: model.data.data.length,
              ),
              fallback: (context) => Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget singleProductItem({
    @required Products model,
    @required BuildContext context,
    @required int index,
  }) =>
      InkWell(
        onTap: () {
          //navigateTo(context, SingleCategoryScreen(),);
        },
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            height: 130.0,
            child: Row(
              children: [
                Container(
                  height: 130.0,
                  width: 130.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      2.0,
                    ),
                    image: DecorationImage(
                      image: NetworkImage(
                        '${model.image}',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(
                  width: 20.0,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                    [
                      if (model.discount != 0)
                        Padding(
                          padding: const EdgeInsetsDirectional.only(
                            bottom: 10.0,
                          ),
                          child: Container(
                            child: Text(
                              appLang(context).discount,
                              style: white12regular(),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 5.0,
                            ),
                            color: Colors.red,
                          ),
                        ),
                      Text(
                        model.name,
                        maxLines: 2,
                        style: TextStyle(
                          height: 1.4,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Spacer(),
                      BlocConsumer<AppCubit, AppStates>(
                        listener: (context, state) {},
                        builder: (context, state) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Column(
                                  children:
                                  [
                                    Row(
                                      children: [
                                        Text(
                                          '${model.price.round()}',
                                          style: black16bold().copyWith(
                                            height: .5,
                                            color: defaultColor,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5.0,
                                        ),
                                        Text(
                                          appLang(context).currency,
                                          style: black12bold().copyWith(
                                            height: .5,
                                            color: defaultColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (model.discount != 0)
                                      Row(
                                        children: [
                                          Text(
                                            '${model.oldPrice.round()}',
                                            style: black12bold().copyWith(
                                              color: Colors.grey,
                                              decoration: TextDecoration.lineThrough,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 5.0,
                                            ),
                                            child: Container(
                                              width: 1.0,
                                              height: 10.0,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Text(
                                            '${model.discount}%',
                                            style: black12bold().copyWith(
                                              color: Colors.red,
                                            ),
                                          ),
                                        ],
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                      ),
                                  ],
                                ),
                              ),
                              FloatingActionButton(
                                onPressed: ()
                                {
                                  AppCubit.get(context).changeFav(
                                    id: model.id,
                                  );
                                },
                                heroTag : '2',
                                backgroundColor:
                                AppCubit.get(context).favourites[model.id]
                                    ? Colors.green
                                    : null,
                                mini: true,
                                child: Icon(
                                  IconBroken.Heart,
                                ),
                              ),
                              FloatingActionButton(
                                onPressed: () {
                                  AppCubit.get(context).changeCart(
                                    id: model.id,
                                  );
                                },
                                heroTag : '1',
                                backgroundColor: AppCubit.get(context).cart[model.id]
                                    ? Colors.green
                                    : null,
                                mini: true,
                                child: Icon(
                                  IconBroken.Buy,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}