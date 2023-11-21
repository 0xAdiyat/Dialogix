import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../theme/palette.dart';

void showSnackBar(BuildContext ctx, String text) => ScaffoldMessenger.of(ctx)
  ..hideCurrentSnackBar()
  ..showSnackBar(SnackBar(
    content: Text(text, style: const TextStyle(color: Palette.redColor)),
  ));

Future<FilePickerResult?> pickImage() async {
  final image = await FilePicker.platform.pickFiles(type: FileType.image);
  return image;
}
