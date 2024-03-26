import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:intl/intl.dart';

import '../theme/palette.dart';

void showSnackBar(BuildContext ctx, String text) => ScaffoldMessenger.of(ctx)
  ..hideCurrentSnackBar()
  ..showSnackBar(SnackBar(
    content: Text(text, style: const TextStyle(color: Palette.redColor)),
  ));

Future<CroppedFile?> pickImage(
    {CropStyle cropStyle = CropStyle.rectangle}) async {
  late CroppedFile image;

  await FilePicker.platform.pickFiles(type: FileType.image).then((value) async {
    await ImageCropper.platform.cropImage(
      sourcePath: value!.paths.first!,
      cropStyle: cropStyle,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
    ).then((value) => image = value!);
  });

  return image;
}

String formatDateTime(DateTime dateTime, {String format = 'd MMMM, yyyy'}) =>
    DateFormat(format).format(dateTime);
