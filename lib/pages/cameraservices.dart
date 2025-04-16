import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:refresher/api/apiuse.dart';
import 'package:refresher/auth/gemini.dart';

class cameraservices{
  final ImagePicker _picker = ImagePicker();

  void captureImage() async {

    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image == null) return ;

    File imageFile = File(image.path);
    GeminiService().analyzeImage(image);

  }
}