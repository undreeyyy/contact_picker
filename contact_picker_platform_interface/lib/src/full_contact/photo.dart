import 'dart:typed_data';

import 'package:flutter/widgets.dart';

/// Representation of a user image
class Photo {
  /// An [Uint8List] containing the raw bytes of the image
  final Uint8List bytes;

  Photo(this.bytes);

  factory Photo.fromMap(Map<dynamic, dynamic> map) =>
      Photo(map['photo'] as Uint8List);

  /// Returns the Image as an [ImageProvider]
  /// See [Image]
  ImageProvider asProvider() => MemoryImage(bytes);

  /// Returns the Image as an [ResizeImage]
  /// See [Image.memory]
  ImageProvider asResizedProvider({
    double scale = 1.0,
    int? cacheWidth,
    int? cacheHeight,
  }) =>
      ResizeImage.resizeIfNeeded(
          cacheWidth, cacheHeight, MemoryImage(bytes, scale: scale));

  /// Returns the Image as an [Image]
  /// See [Image.memory]
  Image asWidget({
    double scale = 1.0,
    int? cacheWidth,
    int? cacheHeight,
  }) =>
      Image.memory(
        bytes,
        scale: scale,
        cacheHeight: cacheHeight,
        cacheWidth: cacheWidth,
      );
}
