import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CloudinaryService {
  static const String cloudName = 'ddb9q1n1p';
  static const String apiKey = '814363151746926';
  static const String apiSecret = 'eo8Kimc_AbfXHMU1BpMs5R5Y7fU';
  static const String uploadPreset = 'ml_default'; // Optional if using unsigned uploads

  static Future<String?> uploadImage(File imageFile) async {
    final url = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');
    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = uploadPreset // Required if using unsigned uploads
      ..fields['api_key'] = apiKey
      ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    final response = await request.send();
    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      final jsonResponse = json.decode(responseData);
      return jsonResponse['secure_url']; // Cloudinary URL
    } else {
      print('Upload failed: ${response.reasonPhrase}');
      return null;
    }
  }
}
