# myrefectly

Demo Video

[![Hướng dẫn dự án trên YouTube](https://img.youtube.com/vi/_Yjp-0Sbfto/hqdefault.jpg)](https://www.youtube.com/watch?v=_Yjp-0Sbfto&t=83s&ab_channel=FLutterIntern)



/lib/core/network/
  - dio_client.dart (Client chính xử lý các request)
  - network_info.dart (Kiểm tra kết nối mạng)
  - api_endpoints.dart (Quản lý tập trung các API endpoint)
  
/lib/core/network/interceptors/
  - auth_interceptor.dart (Xử lý authentication)
  - logging_interceptor.dart (Ghi log request/response)
  - cache_interceptor.dart (Cache response)
  
/lib/core/di/
  - network_module.dart (Dependency injection cho network)