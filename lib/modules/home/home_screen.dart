import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla/models/categories/categories.dart';
import 'package:salla/models/home/home_model.dart';
import 'package:salla/modules/single_category/single_category_screen.dart';
import 'package:salla/shared/app_cubit/cubit.dart';
import 'package:salla/shared/app_cubit/states.dart';
import 'package:salla/shared/components/components.dart';
import 'package:salla/shared/components/constants.dart';
import 'package:salla/shared/styles/colors.dart';
import 'package:salla/shared/styles/icon_broken.dart';
import 'package:salla/shared/styles/styles.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var model = AppCubit.get(context).homeModel;
        var categories = AppCubit.get(context).categoriesModel;

        return ConditionalBuilder(
          condition: model != null && categories != null,
          builder: (context) => SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CarouselSlider(
                  options: CarouselOptions(
                    height: 200,
                    viewportFraction: 1.0,
                    enlargeCenterPage: false,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    reverse: false,
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 3),
                    autoPlayAnimationDuration: Duration(seconds: 1),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    //onPageChanged: callbackFunction,
                    scrollDirection: Axis.horizontal,
                  ),
                  items: model.data.banners
                      .map(
                        (item) => Image(
                          image: NetworkImage(item.image),
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      )
                      .toList(),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.0,
                  ),
                  child: Row(
                    children: [
                      Text(
                        appLang(context).browse,
                        style: black20bold(),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 110,
                  padding: EdgeInsets.all(
                    10.0,
                  ),
                  child: ListView.separated(
                    itemBuilder: (context, index) =>
                        categoryItem(categories.data.data[index], context),
                    separatorBuilder: (context, index) => SizedBox(
                      width: 10.0,
                    ),
                    itemCount: categories.data.data.length,
                    scrollDirection: Axis.horizontal,
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.only(
                    start: 10.0,
                  ),
                  child: Text(
                    appLang(context).new_arrivals,
                    style: black20bold(),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  width: double.infinity,
                  height: 1.0,
                  color: Colors.grey[300],
                ),
                Container(
                  color: Colors.grey[300],
                  child: GridView.count(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    crossAxisSpacing: 1.0,
                    mainAxisSpacing: 1.0,
                    childAspectRatio: 1 / 1.8,
                    children: List.generate(
                      model.data.products.length,
                      (index) => productGridItem(
                        model: model.data.products[index],
                        context: context,
                        index: index,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          fallback: (context) => Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  Widget categoryItem(ProductData model, context) => InkWell(
    onTap: (){
      navigateTo(context, SingleCategoryScreen(model.id, model.name),);
    },
    child: Container(
          width: 90.0,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Image(
                image: NetworkImage(
                  model.image,
                ),
                fit: BoxFit.cover,
                height: 90.0,
                width: 90.0,
              ),
              Container(
                width: double.infinity,
                height: 25.0,
                color: Colors.black.withOpacity(
                  .8,
                ),
                child: Center(
                  child: Text(
                    model.name,
                    style: white12bold(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
  );

  Widget productGridItem({
    @required Products model,
    @required BuildContext context,
    @required int index,
  }) =>
      Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                bottom: 20.0,
              ),
              child: Stack(
                alignment: AlignmentDirectional.bottomEnd,
                children: [
                  Image(
                    image: NetworkImage(
                      model.image,
                    ),
                    //fit: BoxFit.cover,
                    height: 250.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: AlignmentDirectional.bottomStart,
                      child: Column(
                        children: [
                          FloatingActionButton(
                            onPressed: () {
                              AppCubit.get(context).changeFav(
                                id: model.id,
                              );
                            },
                            heroTag : '4',
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
                            heroTag : '3',
                            backgroundColor: AppCubit.get(context).cart[model.id]
                                ? Colors.green
                                : null,
                            mini: true,
                            child: Icon(
                              IconBroken.Buy,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (model.discount != 0)
                    Container(
                      child: Text(
                        appLang(context).discount,
                        style: white12regular(),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 5.0,
                      ),
                      color: Colors.red,
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    model.name,
                    maxLines: 2,
                    style: TextStyle(
                      height: 1.4,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
