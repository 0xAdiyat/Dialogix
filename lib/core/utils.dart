import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

void showSnackBar(BuildContext ctx, String text) => ScaffoldMessenger.of(ctx)
  ..hideCurrentSnackBar()
  ..showSnackBar(SnackBar(content: Text(text)));

Future<FilePickerResult?> pickImage() async {
  final image = await FilePicker.platform.pickFiles(type: FileType.image);
  return image;
}
