// import 'dart:io';
// import 'dart:typed_data';
// import 'package:flutter_image_compress/flutter_image_compress.dart';
// import 'package:image/image.dart' as img; // Thêm thư viện image để lấy kích thước ảnh

// Future<Uint8List?> compressIMG(File imageFile) async {
//   // Đọc file và lấy độ phân giải ảnh
//   final image = img.decodeImage(await imageFile.readAsBytes());
//   if (image == null) return null;

//   int width = image.width;
//   int height = image.height;

//   // Tùy chỉnh chất lượng dựa trên độ phân giải
//   int quality = 90; // Chất lượng mặc định
//   if (width * height > 2000000) { // Nếu ảnh lớn hơn 2MP
//     quality = 50;
//   } else if (width * height > 1000000) { // Nếu ảnh lớn hơn 1MP
//     quality = 70;
//   }

//   Uint8List? webpImage = await FlutterImageCompress.compressWithFile(
//     imageFile.absolute.path,
//     format: CompressFormat.png,
//     quality: quality,
//   );

//   // Nếu file vẫn lớn hơn 200 KB, giảm chất lượng xuống thêm
//   int targetSize = 200 * 1024; // 200 KB
//   while (webpImage != null && webpImage.length > targetSize && quality > 10) {
//     quality -= 10;
//     webpImage = await FlutterImageCompress.compressWithFile(
//       imageFile.absolute.path,
//       format: CompressFormat.png,
//       quality: quality,
//     );
//   }

//   return webpImage;
// }

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image/image.dart' as img;

Future<Uint8List?> compressIMG(File imageFile) async {
  // Đọc file và lấy độ phân giải ảnh
  final image = img.decodeImage(await imageFile.readAsBytes());
  if (image == null) return null;

  int width = image.width;
  int height = image.height;

  // Tùy chỉnh chất lượng dựa trên độ phân giải
  int quality = 90; // Chất lượng mặc định
  if (width * height > 2000000) { // Nếu ảnh lớn hơn 2MP
    quality = 50;
  } else if (width * height > 1000000) { // Nếu ảnh lớn hơn 1MP
    quality = 70;
  }

  Uint8List? compressedImage = await FlutterImageCompress.compressWithFile(
    imageFile.absolute.path,
    format: CompressFormat.webp, // Dùng định dạng WebP để tối ưu dung lượng
    quality: quality,
  );

  // Mục tiêu: Giảm kích thước ảnh xuống tối đa 150 KB
  int targetSize = 100 * 1024; // 150 KB

  // Nếu ảnh sau khi nén vẫn lớn hơn 150 KB, tiếp tục giảm chất lượng
  while (compressedImage != null && compressedImage.length > targetSize && quality > 10) {
    quality -= 10; // Giảm chất lượng từng bước
    compressedImage = await FlutterImageCompress.compressWithFile(
      imageFile.absolute.path,
      format: CompressFormat.webp,
      quality: quality,
    );
  }

  // Trả về ảnh đã nén
  return compressedImage;
}
