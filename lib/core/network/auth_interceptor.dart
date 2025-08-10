// core/network/auth_interceptor.dart
import 'package:dio/dio.dart';
import 'package:ecarrgo/core/features/auth/providers/auth_token_provider.dart';

class AuthInterceptor extends Interceptor {
  final AuthTokenProvider authTokenProvider;

  AuthInterceptor(this.authTokenProvider);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = authTokenProvider.token;
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }
}
