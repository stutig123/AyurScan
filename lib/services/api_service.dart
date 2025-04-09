import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://10.9.191.116:5000';// For Android emulator

  static Future<Map<String, dynamic>?> uploadImage(File imageFile) async {
    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/predict'));
    request.files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    try {
      var response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final jsonData = jsonDecode(responseBody);

        // Return the full JSON map
        if (jsonData is Map<String, dynamic>) {
          return jsonData;
        }
      }

      return null;
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }
}
