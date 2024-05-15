import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  static final _storage = FirebaseStorage.instance;

  static Future<bool> uploadIrregularityImage(
      {required File file,
      required String userId,
      required String irregularityId}) async {
    try {
      final fileName = file.path.split('/').last;

      await _storage
          .ref("irregularity_images/$userId/$irregularityId/$fileName")
          .putFile(file);
      return true;
    } catch (e) {
      print(e);
    }

    return false;
  }

  static Future<List<Reference>?> getIrregularityImages(
      {required String userId, required String irregularityId}) async {
    try {
      final uploads = await _storage
          .ref("irregularity_images/$userId/$irregularityId")
          .listAll();

      return uploads.items;
    } catch (e) {
      print(e);
    }

    return null;
  }

  static Future<bool> deleteIrregularityImages(
      {required String userId, required String irregularityId}) async {
    try {
      final uploads = await _storage
          .ref("irregularity_images/$userId/$irregularityId")
          .delete();

      return true;
    } catch (e) {
      print(e);
    }

    return false;
  }
}
