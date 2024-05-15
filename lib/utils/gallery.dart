import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:gallery_picker/gallery_picker.dart';

Future<MediaFile?> getImageFromGallery(BuildContext context) async {
  try {
    List<MediaFile>? media =
        await GalleryPicker.pickMedia(context: context, singleMedia: true);

    return media?.first;
  } catch (e) {
    print(e);
  }

  return null;
}
