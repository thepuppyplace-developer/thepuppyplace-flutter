import 'package:flutter/material.dart';
import '../../util/common.dart';

class UrlText extends StatelessWidget {

  final String text;
  final TextStyle? style;

  const UrlText({
    Key? key,
    required this.text,
    this.style,
  }) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => RichText(
    text: TextSpan(
      style: style ?? CustomTextStyle.w500(context),
      children: _getSpans(text, 'w', CustomTextStyle.w600(context))
    ),
  );

  List<TextSpan> _getSpans(String text, String matchWord, TextStyle style) {

    List<TextSpan> spans = [];
    int spanBoundary = 0;

    do {
      final startIndex = text.indexOf(matchWord, spanBoundary);
      if (startIndex == -1) {
        spans.add(TextSpan(text: text.substring(spanBoundary)));
        return spans;
      }
      if (startIndex > spanBoundary) {
        spans.add(TextSpan(text: text.substring(spanBoundary, startIndex)));
      }
      final endIndex = startIndex + matchWord.length;
      final spanText = text.substring(startIndex, endIndex);
      spans.add(TextSpan(text: spanText, style: style));
      spanBoundary = endIndex;
    }
    while (spanBoundary < text.length);
    return spans;
  }
}