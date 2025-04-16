import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class GeminiService {
  final String apiKey = "AIzaSyDG52Y0MVjXX08PfpUJd1xR3Xt12sE0QGc"; // Replace with your key

  Future<List<String>> analyzeImage(XFile imageFile) async {
    try {
      // Convert image to Base64
      List<int> imageBytes = await File(imageFile.path).readAsBytes();
      String base64Image = base64Encode(imageBytes);

      // Gemini API URL
      final String url = "https://generativelanguage.googleapis.com/v1/models/gemini-1.5-flash:generateContent?key=$apiKey";
      // Prepare request payload
      var requestBody = {
        "contents": [
          {
            "parts": [
              {
                "text": "Extract three key topics from the text in this image respond with three words only sperated by a '-'."
              },
              {
                "inline_data": {
                  "mime_type": "image/jpeg",
                  "data": base64Image
                }
              }
            ]
          }
        ]
      };

      // Make the API request
      var response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        for(int i=0;i<100;i++)
          print(1);
        var jsonResponse = jsonDecode(response.body);
        String textOutput = jsonResponse["candidates"][0]["content"]["parts"][0]["text"];
        print(textOutput);
        // Extract three topics from the response
        List<String> topics = textOutput.split("-").take(3).toList();
        return topics;
      } else {
        throw Exception("API Error: ${response.body}");
      }
    } catch (e) {
      for(int i=0;i<100;i++)
        print(2);
      print("Error: $e");
      return [];
    }
  }
}