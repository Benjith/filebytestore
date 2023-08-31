   import 'package:filebytestore/utils/color_resources.dart';
import 'package:flutter/material.dart';

Widget stoppedAnimationProgress({color}) => CircularProgressIndicator(
        strokeWidth: 2.5,
        valueColor: AlwaysStoppedAnimation<Color>(
            color ?? ColorResources.BG_COLOR),
      );