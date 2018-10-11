import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImageWithLoader extends StatelessWidget {
  final url;

  const ImageWithLoader(this.url);

  @override
  Widget build(BuildContext context) => CachedNetworkImage(
        placeholder: const CircularProgressIndicator(),
        imageUrl: url,
        errorWidget: Text("laod $url failed"),
      );
}
