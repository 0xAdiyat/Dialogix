import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../theme/palette.dart';

class DialogixCachedNetworkImage extends StatelessWidget {
  final String imgUrl;
  const DialogixCachedNetworkImage({super.key, required this.imgUrl});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imgUrl,
      fit: BoxFit.cover,
      placeholder: (context, url) => const Center(
        child: CupertinoActivityIndicator(),
      ),
      errorWidget: (context, url, err) => const Center(
        child: Icon(
          Icons.error_outline,
          color: Palette.redColor,
        ),
      ),
    );
  }
}
