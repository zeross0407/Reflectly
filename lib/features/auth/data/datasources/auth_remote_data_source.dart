import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myrefectly/core/error/exceptions.dart';
import 'package:myrefectly/core/network/dio_client.dart';
import 'package:myrefectly/di/injection.dart';
import 'package:myrefectly/features/auth/data/models/user_model.dart';
import 'package:myrefectly/models/data.dart';

abstract class AuthRemoteDataSource {
  /// Calls the /api/Account/login endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<UserModel> login(String email, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final dioClient = serviceLocator<DioClient>();
  final http.Client client;
  final String baseUrl = server_root_url + "/api/Account";

  AuthRemoteDataSourceImpl({required this.client});

  @override
  Future<UserModel> login(String email, String password) async {
    final response = await dioClient.post(
      '$baseUrl/login',
      data: {
        'email': email,
        'password': password,
      },
    );
    // final response = await client.post(
    //   Uri.parse('$baseUrl/login'),
    //   headers: {'Content-Type': 'application/json'},
    //   body: jsonEncode({
    //     'email': email,
    //     'password': password,
    //   }),
    // );

    if (response.statusCode == 200) {
      return UserModel.fromJson(response.data);
    } else {
      throw AuthException(
        code: response.statusCode,
        message: "Login failed with status: ${response.statusCode}",
      );
    }
  }
}
