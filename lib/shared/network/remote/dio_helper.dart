import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:salla/shared/components/constants.dart';
import 'dart:async';

import 'package:salla/shared/network/errors.dart';

abstract class DioHelper {
  Future<Response> postData({
    @required String url,
    @required dynamic data,
    String token,
  });

  Future<Response> putData({
    @required String url,
    @required dynamic data,
    String token,
  });

  Future<Response> getData({
    @required String url,
    dynamic query,
    String token,
  });
}

class DioImplementation extends DioHelper
{
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'https://student.valuxapps.com/api/',
      receiveDataWhenStatusError: true,
    ),
  );

  @override
  Future<Response> postData({
    String url,
    dynamic data,
    String token,
  }) async {
    dio.options.headers = {
      'lang': appLanguage,
      'Content-Type': 'application/json',
      'Authorization': token ?? '',
    };

    return await dio.post(
      url,
      data: data,
    );
  }

  @override
  Future<Response> putData({
    String url,
    dynamic data,
    String token,
  }) async {
    dio.options.headers = {
      'lang': appLanguage,
      'Content-Type': 'application/json',
      'Authorization': token ?? '',
    };

    return await dio.put(
      url,
      data: data,
    );
  }

  @override
  Future<Response> getData({
    String url,
    dynamic query,
    String token,
  }) async {
    dio.options.headers = {
      'lang': appLanguage,
      'Content-Type': 'application/json',
      'Authorization': token ?? '',
    };

    return await dio.get(
      url,
      queryParameters: query,
    );
  }
}
//
// extension on DioHelper {
//   Future _request(Future<Response> request()) async {
//     try {
//       final r = await request.call();
//       return r.data;
//     } on DioError catch (e) {
//       throw ServerException(e.response.data);
//     } catch (e) {
//       throw Exception();
//     }
//   }
// }
