import 'dart:io';

import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import 'color_resources.dart';

Future<File?> pickImage(ImageSource source,
    {int imageQuality = 90, bool enableCrop = true}) async {
  final pickedFile = await ImagePicker().pickImage(
    source: source,
    imageQuality: imageQuality,
  );
  if (pickedFile == null) {
    return null;
  }
  File? file;
  // getting a directory path for saving
  var localDIR = await getApplicationDocumentsDirectory();
  final String localPath = localDIR.path;

  if (enableCrop) {
    file = await cropImage(File(pickedFile.path));
  } else {
    return file = File(pickedFile.path);
  }
  // copy the file to a new path
  return await file!.copy(
      '$localPath/${DateTime.now().millisecond}_${file.path.split('/').last}');
}

Future<List<File>> pickMultiImage({
  int imageQuality = 90,
}) async {
  final pickedFile = await ImagePicker().pickMultiImage(
    imageQuality: imageQuality,
  );

  return pickedFile.map((e) => File(e.path)).toList();
}

Future<File?> cropImage(
  File image, {
  List<CropAspectRatioPreset> aspectRatioPresets = const [
    CropAspectRatioPreset.square,
  ],
  CropAspectRatio? cropAspectRatio,
  CropStyle cropStyle = CropStyle.rectangle,
}) async {
  final croppedImage = await ImageCropper().cropImage(
    sourcePath: image.path,
    aspectRatioPresets: aspectRatioPresets,
    aspectRatio: cropAspectRatio,
    uiSettings: [
      AndroidUiSettings(
        toolbarTitle: 'Crop Image',
        toolbarColor: ColorResources.primary,
        toolbarWidgetColor: ColorResources.placeHolder,
        initAspectRatio: CropAspectRatioPreset.square,
        lockAspectRatio: true,
      ),
      IOSUiSettings(
        title: 'Crop Image',
      )
    ],
    cropStyle: cropStyle,
  );

  return croppedImage == null ? null : File(croppedImage.path);
}
