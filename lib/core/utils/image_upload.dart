// import 'dart:io';
// import 'package:firebase_storage/firebase_storage.dart';

// Future<void> uploadImageWithProgress(File file) async {
//   final storageRef = FirebaseStorage.instance.ref();
//   final imagesRef = storageRef.child(
//     "uploads/${DateTime.now().millisecondsSinceEpoch}.jpg",
//   );

//   final uploadTask = imagesRef.putFile(file);

//   // Listen tiến trình
//   uploadTask.snapshotEvents.listen((taskSnapshot) {
//     switch (taskSnapshot.state) {
//       case TaskState.running:
//         final progress =
//             100.0 * (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
//         print("Upload is $progress% complete.");
//         break;
//       case TaskState.paused:
//         print("Upload is paused.");
//         break;
//       case TaskState.success:
//         print("Upload success!");
//         break;
//       case TaskState.canceled:
//         print("Upload canceled.");
//         break;
//       case TaskState.error:
//         print("Upload error!");
//         break;
//     }
//   });

//   // Khi xong thì lấy URL
//   final snapshot = await uploadTask;
//   final downloadUrl = await snapshot.ref.getDownloadURL();
//   print("Download URL: $downloadUrl");
// }
