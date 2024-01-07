import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/enums/post_type_enums.dart';
import '../../../core/utils.dart';
import 'package:image_cropper/image_cropper.dart';

final postTypeControllerProvider =
    ChangeNotifierProvider<PostTypeController>((ref) {
  return PostTypeController();
});

class PostTypeController extends ChangeNotifier {
  PostType _postType = PostType.text;
  File? _bannerFile;
  Uint8List? _bannerWebFile;

  File? get bannerFile => _bannerFile;
  Uint8List? get bannerWebFile => _bannerWebFile;
  PostType get postType => _postType;

  void setPostTypeImage() {
    _postType = PostType.image;
    notifyListeners();
  }

  void setPostTypeText() {
    _postType = PostType.text;
    notifyListeners();
  }

  void setPostTypeLink() {
    _postType = PostType.link;
    notifyListeners();
  }

  void setPostTypeVideo() {
    _postType = PostType.video;
    notifyListeners();
  }

  void selectBannerImage() async {
    final res = await pickImage();
    if (kIsWeb) {
      _bannerWebFile = await res!.readAsBytes();
    } else {
      _bannerFile = File(res!.path);
    }
    notifyListeners();
  }
}
