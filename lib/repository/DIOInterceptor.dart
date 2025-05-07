import 'dart:isolate';
import 'package:dio/dio.dart';
import 'package:myrefectly/main.dart';
import 'package:myrefectly/repository/sync.dart';

class TokenInterceptor extends Interceptor {
  final Dio dio;
  String? accessToken;
  String? refreshToken;
  SendPort? sendPort;

  TokenInterceptor({
    required this.dio,
    this.accessToken,
    this.refreshToken,
    this.sendPort,
  }) {
    print(sendPort == null);
  }
  void change() {
    if (sendPort != null) {
      sendPort!
          .send(New_Token(access_token: accessToken ?? "", refresh_token: ""));
    }
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Thêm Access Token vào header
    if (refreshToken != null) {
      options.headers['Authorization'] = 'Bearer $refreshToken';
    }
    handler.next(options); // Gửi yêu cầu đi tiếp
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Nếu lỗi 401 (Access Token hết hạn), thực hiện đổi token
    if (err.response?.statusCode == 401 && refreshToken != null) {
      try {
        if (sendPort != null) {
          sendPort!.send(-999);
        } else {
          if (!force_reset) {
            force_reset = true;
            force_log_out();
          }
        }
        // final tokenResponse = await dio.post(
        //   '/api/Account/get_access_token?refreshToken=$refreshToken',
        // );
        // accessToken = await tokenResponse.data['accessToken'];
        // //refreshToken = tokenResponse.data['refreshToken'];
        // change();
        // // Thêm Access Token mới vào request và tái gửi
        // err.requestOptions.headers['Authorization'] = 'Bearer $accessToken';
        // final retryResponse = await dio.request(
        //   err.requestOptions.path,
        //   options: Options(
        //     method: err.requestOptions.method,
        //     headers: err.requestOptions.headers,
        //   ),
        //   data: err.requestOptions.data,
        // );
        // handler.resolve(retryResponse); // Gửi lại phản hồi mới
      } catch (refreshError) {
        print(refreshError.toString());
        handler.next(refreshError as DioException);
      }
    } else {
      // Tiếp tục nếu không phải lỗi 401
      handler.next(err);
    }
  }
}
