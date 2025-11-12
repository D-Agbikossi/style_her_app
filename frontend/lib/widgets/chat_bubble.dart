import 'package:flutter/material.dart';
import '../theme.dart';

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isMe;
  final String time;
  const ChatBubble({super.key, required this.text, required this.isMe, required this.time});

  @override
  Widget build(BuildContext context) {
    final bg = isMe ? AppTheme.primary : Colors.white;
    final fg = isMe ? Colors.white : AppTheme.text;
    final align = isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final radius = BorderRadius.only(
      topLeft: const Radius.circular(12),
      topRight: const Radius.circular(12),
      bottomLeft: Radius.circular(isMe ? 12 : 2),
      bottomRight: Radius.circular(isMe ? 2 : 12),
    );
    return Column(
      crossAxisAlignment: align,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          margin: EdgeInsets.only(top: 8, bottom: 2, left: isMe ? 48 : 0, right: isMe ? 0 : 48),
          decoration: BoxDecoration(color: bg, borderRadius: radius, boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(.05), blurRadius: 8, offset: const Offset(0,2))
          ]),
          child: Text(text, style: TextStyle(color: fg, fontSize: 14)),
        ),
        Padding(
          padding: EdgeInsets.only(left: isMe ? 0 : 4, right: isMe ? 4 : 0),
          child: Text(time, style: const TextStyle(color: AppTheme.softText, fontSize: 11)),
        ),
      ],
    );
  }
}
