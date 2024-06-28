import 'package:flutter/material.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';

class CustomTooltipMenu extends JustTheTooltip {
  const CustomTooltipMenu({
    super.key,
    required super.content,
    required super.child,
    super.isModal = true,
    super.offset = 18,
    super.shadow = const Shadow(
      color: Color(0xcc000000),
      offset: const Offset(0, -4),
      blurRadius: 12,
    ),
    super.margin = const EdgeInsets.all(16),
    super.tailLength = 8.0,
    super.tailBaseWidth = 12.0,
  });
}
