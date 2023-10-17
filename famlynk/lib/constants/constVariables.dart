import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';


class MyProperties {
  Color backgroundColor =  HexColor('#0175C8');
  Color buttonColor = HexColor('#0175C8');
  double fontSize = 18.0;
  Color textColor = HexColor('#0175C8');
  Color fillColor = Colors.grey.shade200;
}


// class FirebaseUtils {
//   static firebase_storage.Reference storageRef =
//       firebase_storage.FirebaseStorage.instance.ref();

//   static Future<File?> getImageFile(String imagePath) async {
//     try {
//       final String downloadUrl = await storageRef.child(imagePath).getDownloadURL();
//       final HttpClient httpClient = HttpClient();
//       final HttpClientRequest request = await httpClient.getUrl(Uri.parse(downloadUrl));
//       final HttpClientResponse response = await request.close();
//       if (response.statusCode == 200) {
//         final bytes = await consolidateHttpClientResponseBytes(response);
//         final tempDir = await getTemporaryDirectory();
//         final File file = File('${tempDir.path}/temp_image.jpg');
//         await file.writeAsBytes(bytes);
//         return file;
//       }
//     } catch (e) {
//       print('Error getting image from Firebase: $e');
//     }
//     return null;
//   }
// }
