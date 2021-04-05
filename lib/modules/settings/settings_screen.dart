import 'package:flutter/material.dart';
import 'package:salla/shared/app_cubit/cubit.dart';
import 'package:salla/shared/components/components.dart';
import 'package:salla/shared/components/constants.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: ()
      {
        setAppLanguageToShared('en')
            .then((value)
        {
          getTranslationFile('en').then((value)
          {
            AppCubit.get(context).setLanguage(
              translationFile: value,
              code: 'en',
            ).then((value)
            {

            });
          }).catchError((error) {});
        })
            .catchError((error) {});
      },
      child: Text(
        'change',
      ),
    );
  }
}
