import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

ImageProvider fileImageProvider(String path) => FileImage(File(path));

VideoPlayerController fileVideoController(String path) =>
    VideoPlayerController.file(File(path));
