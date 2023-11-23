import 'dart:io';
import 'dart:typed_data';

import 'package:dialogix/core/failure.dart';
import 'package:dialogix/core/providers/firebase_providers.dart';
import 'package:dialogix/core/type_defs.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final storageRepositoryProvider = Provider<StorageRepository>((ref) {
  final storage = ref.read(storageProvider);
  return StorageRepository(firebaseStorage: storage);
});

class StorageRepository {
  final FirebaseStorage _firebaseStorage;

  StorageRepository({required FirebaseStorage firebaseStorage})
      : _firebaseStorage = firebaseStorage;

  FutureEither<String> storeFile({
    required String path,
    required String id,
    File? file,
    Uint8List? webFile,
  }) async {
    try {
      final ref = _firebaseStorage.ref().child(path).child(id);
      final UploadTask uploadTask;
      if (kIsWeb) {
        uploadTask = ref.putData(webFile!); 
      } else {
        uploadTask = ref.putFile(file!);
      }
      final snapshot = await uploadTask;

      return right(await snapshot.ref.getDownloadURL());
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
