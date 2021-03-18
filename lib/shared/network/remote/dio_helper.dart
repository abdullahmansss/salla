import 'package:dio/dio.dart';

class DioHelper {
  static Dio dio;

  DioHelper() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://student.valuxapps.com/api/',
        headers:
        {
          'Content-Type': 'application/json',
          'lang': 'en',
        },
      ),
    );
  }

  static Future<Response> postData({
    path,
    data,
    token,
    query,
  }) async
  {
    if (token != null) {
      dio.options.headers = {
        'Authorization': '$token',
      };
    }

    return await dio.post(
      path,
      data: data ?? null,
      queryParameters: query ?? null,
    );
  }
}
