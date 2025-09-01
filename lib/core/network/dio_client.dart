import 'package:dio/dio.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  late final Dio dio;

  factory DioClient() {
    return _instance;
  }

  DioClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.example.com', // base url kamu
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    // Optionally add interceptors
    dio.interceptors.add(LogInterceptor(responseBody: true));
  }
}

// import 'package:dio/dio.dart';
// import 'package:ecarrgo/core/network/api_constants.dart';

// class DioClient {
//   static final DioClient _instance = DioClient._internal();
//   late final Dio dio;

//   factory DioClient(Dio dio) {
//     return _instance;
//   }

//   DioClient._internal() {
//     dio = Dio(
//       BaseOptions(
//         // Ganti sesuai kebutuhan
//         baseUrl: ApiConstants.baseUrl, 
//         connectTimeout: const Duration(seconds: 10),
//         receiveTimeout: const Duration(seconds: 10),
//         headers: {
//           'Accept': 'application/json',
//           'Content-Type': 'application/json',
//         },
//       ),
//     );

//     dio.interceptors.add(LogInterceptor(responseBody: true));
//   }
// }

