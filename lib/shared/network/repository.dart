import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:salla/shared/network/end_points.dart';
import 'package:salla/shared/network/errors.dart';
import 'package:salla/shared/network/remote/dio_helper.dart';
import 'local/cache_helper.dart';

abstract class Repository {
  Future<Response> userLogin({
    @required String email,
    @required String password,
  });

  Future<Response> getHomeData({
    @required String token,
  });

  Future<Response> getCartData({
    @required String token,
  });

  Future<Response> getSingleCategory({
    @required String token,
    @required int id,
  });

  Future<Response> getCategories();

  Future<Response> addOrRemoveFavourite({
    @required String token,
    @required int id,
  });

  Future<Response> addOrRemoveCart({
    @required String token,
    @required int id,
  });

  Future<Response> updateCart({
    @required String token,
    @required int id,
    @required int quantity,
  });

// Future<Either<String, UserModel>> userLogin({
//   @required String email,
//   @required String password,
// });
//
// Future<Either<String, List<BlogsModel>>> getAllBlog({
//   @required String token,
// });
//
// Future<Either<String, BlogsModel>> getSingleBlog({
//   @required String token,
//   @required String id,
// });
}

class RepoImplementation extends Repository {
  final DioHelper dioHelper;
  final CacheHelper cacheHelper;

  RepoImplementation({
    @required this.dioHelper,
    @required this.cacheHelper,
  });

  @override
  Future<Response> userLogin({
    String email,
    String password,
  }) async {
    return await dioHelper.postData(
      url: LOGIN,
      data:
      {
        'email':email,
        'password':password,
      },
    );
  }

  @override
  Future<Response> addOrRemoveFavourite({
    String token,
    int id,
  }) async {
    return await dioHelper.postData(
      url: ADD_FAVOURITE,
      token: token,
      data:
      {
        'product_id':id,
      },
    );
  }

  @override
  Future<Response> addOrRemoveCart({
    String token,
    int id,
  }) async {
    return await dioHelper.postData(
      url: ADD_CART,
      token: token,
      data:
      {
        'product_id':id,
      },
    );
  }

  @override
  Future<Response> updateCart({
    String token,
    int id,
    int quantity,
  }) async {
    return await dioHelper.putData(
      url: '$ADD_CART/$id',
      token: token,
      data:
      {
        'quantity':quantity,
      },
    );
  }

  @override
  Future<Response> getHomeData({
    String token,
  }) async
  {
    return await dioHelper.getData(
      url: HOME_DATA,
      token: token,
    );
  }

  @override
  Future<Response> getCartData({
    String token,
  }) async
  {
    return await dioHelper.getData(
      url: ADD_CART,
      token: token,
    );
  }

  @override
  Future<Response> getSingleCategory({
    String token,
    int id,
  }) async
  {
    return await dioHelper.getData(
      url: GET_PRODUCTS,
      token: token,
      query: {
        'category_id':id,
      },
    );
  }

  @override
  Future<Response> getCategories() async
  {
    return await dioHelper.getData(
      url: GET_CATEGORIES,
    );
  }

// @override
// Future<Either<String, List<BlogsModel>>> getAllBlog({
//   @required String token,
// }) async {
//   return _basicErrorHandling<List<BlogsModel>>(
//     onSuccess: () async {
//       final f = await dioHelper.getData(
//         url: ALL_BLOG,
//         token: token,
//       );
//
//       List<BlogsModel> list = [];
//
//       f.forEach((v)
//       {
//         list.add(BlogsModel.fromJson(v));
//       });
//
//       return list;
//     },
//     onServerError: (exception) async
//     {
//       final f = exception.error;
//       final msg = _handleErrorMessages(f['message']);
//       return msg;
//     },
//   );
// }
//
// @override
// Future<Either<String, BlogsModel>> getSingleBlog({
//   @required String token,
//   @required String id,
// }) async {
//   return _basicErrorHandling<BlogsModel>(
//     onSuccess: () async
//     {
//       final f = await dioHelper.getData(
//         url: '$SINGLE_BLOG$id',
//         token: token,
//       );
//
//       return BlogsModel.fromJson(f);
//     },
//     onServerError: (exception) async
//     {
//       final f = exception.error;
//       final msg = _handleErrorMessages(f['message']);
//       return msg;
//     },
//   );
// }
//
// @override
// Future<Either<String, UserModel>> userLogin({
//   @required String email,
//   @required String password,
// }) async {
//   return _basicErrorHandling<UserModel>(
//     onSuccess: () async {
//       final f = await dioHelper.postData(
//         url: LOGIN,
//         data: {
//           'email':email,
//           'password':password,
//         },
//       );
//       return UserModel.fromJson(f);
//     },
//     onServerError: (exception) async
//     {
//       final f = exception.error;
//       final msg = _handleErrorMessages(f['message']);
//       return msg;
//     },
//   );
// }
}

extension on Repository {
  String _handleErrorMessages(final dynamic f) {
    String msg = '';
    if (f is String) {
      msg = f;
    } else if (f is Map) {
      for (dynamic l in f.values) {
        if (l is List) {
          for (final s in l) {
            msg += '$s\n';
          }
        }
      }
      if (msg.contains('\n')) {
        msg = msg.substring(0, msg.lastIndexOf('\n'));
      }
      if (msg.isEmpty) {
        msg = 'Server Error';
      }
    } else {
      msg = 'Server Error';
    }
    return msg;
  }

  Future<Either<String, T>> _basicErrorHandling<T>({
    @required Future<T> onSuccess(),
    Future<String> onServerError(ServerException exception),
    Future<String> onCacheError(CacheException exception),
    Future<String> onOtherError(Exception exception),
  }) async {
    try {
      final f = await onSuccess();
      return Right(f);
    } on ServerException catch (e, s) {
      print(s);
      if (onServerError != null) {
        final f = await onServerError(e);
        return Left(f);
      }
      return Left('Server Error');
    } on CacheException catch (e, s) {
//      print(e);
      if (onCacheError != null) {
        final f = await onCacheError(e);
        return Left(f);
      }
      return Left('Cache Error');
    } catch (e, s) {
      print(s);
      if (onOtherError != null) {
        final f = await onOtherError(e);
        return Left(f);
      }
      return Left(e.toString());
    }
  }
}
