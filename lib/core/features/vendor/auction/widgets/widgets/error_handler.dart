import 'package:dio/dio.dart';

String getErrorMessage(DioException error) {
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
      return "Waktu koneksi habis. Periksa jaringan Anda.";
    case DioExceptionType.receiveTimeout:
      return "Server terlalu lama merespons. Coba lagi nanti.";
    case DioExceptionType.connectionError:
      return "Tidak bisa terhubung ke server. Periksa internet Anda.";
    case DioExceptionType.badResponse:
      if (error.response?.statusCode == 404) {
        return "Halaman atau data tidak ditemukan (404).";
      } else if (error.response?.statusCode == 500) {
        return "Terjadi kesalahan di server (500).";
      }
      return "Server mengembalikan error: ${error.response?.statusCode}";
    default:
      return "Terjadi kesalahan yang tidak diketahui. Coba lagi nanti.";
  }
}
