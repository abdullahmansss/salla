import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla/shared/app_cubit/cubit.dart';
import 'package:salla/shared/app_cubit/states.dart';
import 'package:salla/shared/components/constants.dart';
import 'package:salla/shared/styles/icon_broken.dart';

class HomeLayout extends StatelessWidget
{
  @override
  Widget build(BuildContext context)
  {
    print(userToken);

    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                Text(
                  appLang(context).salla,
                ),
                SizedBox(
                  width: 20.0,
                ),
                Expanded(
                  child: InkWell(
                    onTap: (){},
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          5.0,
                        ),
                        color: Colors.white,
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 15.0,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            IconBroken.Search,
                            color: Colors.grey,
                            size: 16.0,
                          ),
                          SizedBox(
                            width: 15.0,
                          ),
                          Expanded(
                            child: Text(
                              appLang(context).search,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: AppCubit.get(context)
              .bottomWidgets[AppCubit.get(context).currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            onTap: (index) {
              AppCubit.get(context).changeBottomIndex(index);
            },
            type: BottomNavigationBarType.fixed,
            currentIndex: AppCubit.get(context).currentIndex,
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  IconBroken.Home,
                ),
                label: appLang(context).home,
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  IconBroken.Category,
                ),
                label: appLang(context).categories,
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  IconBroken.Bag,
                ),
                label: appLang(context).cart,
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  IconBroken.Setting,
                ),
                label: appLang(context).settings,
              ),
            ],
          ),
        );
      },
    );
  }
}