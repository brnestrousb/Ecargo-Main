import 'package:dio/dio.dart';
import 'package:ecarrgo/core/features/auth/domain/entities/user.dart';
import 'package:ecarrgo/core/features/auth/data/models/user_model.dart';
import 'package:ecarrgo/core/network/storage/secure_storage_service.dart';
import 'package:logger/logger.dart';

abstract class AuthRemoteDataSource {
  Future<User> register({
    required String name,
    required String company,
    required String email,
    required String password,
    required String phone,
    required String address,
    String? fcmToken,
  });

  Future<User> login({
    required String email,
    required String password,
    String? fcmToken,
  });

  Future<void> sendFcmToken({
    required String fcmToken,
    required String accessToken,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;
  final Logger logger;

  AuthRemoteDataSourceImpl(this.dio) : logger = Logger();

  @override
  Future<void> sendFcmToken({
    required String fcmToken,
    required String accessToken,
  }) async {
    final url = '/users/insert-or-update-user-devices';

    try {
      logger.i('Sending PATCH request to $url');
      logger.i('Authorization: Bearer $accessToken');
      logger.i('Body: { "token_fcm": "$fcmToken" }');

      final response = await dio.patch(
        url,
        data: {'token_fcm': fcmToken},
        options: Options(headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        }),
      );

      logger.i('Response status: ${response.statusCode}');
      logger.i('Response data: ${response.data}');
    } on DioException catch (e) {
      logger.e('PATCH request failed!');
      if (e.response != null) {
        logger.e('Status code: ${e.response?.statusCode}');
        logger.e('Response data: ${e.response?.data}');
      } else {
        logger.e('Error: ${e.message}');
      }
      rethrow;
    } catch (e) {
      logger.e('Unexpected error: $e');
      rethrow;
    }
  }

  @override
  Future<User> register({
    required String name,
    required String company,
    required String email,
    required String password,
    required String phone,
    required String address,
    String? fcmToken,
  }) async {
    try {
      final response = await dio.post(
        '/auth/register',
        data: {
          'name': name,
          'company': company,
          'email': email,
          'password': password,
          'phone': phone,
          'address': address,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final user = UserModel.fromJson(response.data);

        if (fcmToken != null) {
          await sendFcmToken(
            fcmToken: fcmToken,
            accessToken: user.accessToken,
          );
        }

        await SecureStorageService().saveToken(user.accessToken);

        return user;
      } else {
        logger.e('Register failed with status: ${response.statusCode}');
        throw Exception('Register failed with status: ${response.statusCode}');
      }
    } on DioException catch (e) {
      logger.e('Dio error during registration: ${e.message}');
      throw Exception('Dio error during registration: ${e.message}');
    } catch (e) {
      logger.e('An unexpected error occurred: $e');
      throw Exception('An unexpected error occurred: $e');
    }
  }

  @override
  Future<User> login({
    required String email,
    required String password,
    String? fcmToken,
  }) async {
    try {
      final response = await dio.post(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json'
          }, // opsional tapi aman ditambahkan
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final user = UserModel.fromJson(response.data);

        if (fcmToken != null) {
          await sendFcmToken(
            fcmToken: fcmToken,
            accessToken: user.accessToken,
          );
        }

        await SecureStorageService().saveToken(user.accessToken);

        return user;
      } else {
        logger.e('Login failed with status: ${response.statusCode}');
        throw Exception('Login failed with status: ${response.statusCode}');
      }
    } on DioException catch (e) {
      logger.e('Dio error during login: ${e.message}');
      if (e.response != null) {
        logger.e('Response data: ${e.response?.data}');
      }
      throw Exception('Dio error during login: ${e.message}');
    } catch (e) {
      logger.e('An unexpected error occurred: $e');
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
