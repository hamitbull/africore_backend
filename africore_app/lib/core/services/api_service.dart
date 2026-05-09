import 'package:dio/dio.dart';

import '../config/api_endpoints.dart';

class ApiService {

  final Dio dio = Dio(
    BaseOptions(
      baseUrl: ApiEndpoints.baseUrl,
      headers: {
        "Content-Type": "application/json"
      },
    ),
  );

  Future<Response> get(String path) async {
    return await dio.get(path);
  }

  Future<Response> post(
      String path,
      Map<String, dynamic> data,
      ) async {

    return await dio.post(
      path,
      data: data,
    );
  }
}
