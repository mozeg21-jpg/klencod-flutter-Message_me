import 'package:flutter/material.dart';
import 'audio_player_widget.dart';

class MessageBubble extends StatelessWidget {
  final Map<String, dynamic> message; final bool mine; final VoidCallback onReply;
  const MessageBubble({super.key, required this.message, required this.mine, required this.onReply});
  @override
  Widget build(BuildContext context) {
    final audio = (message['audioBase64'] ?? '').toString();
    final bg = mine ? const Color(0xFFE85C5C) : Colors.white;
    final textColor = mine ? Colors.white : const Color(0xFF111111);
    final time = DateTime.fromMillisecondsSinceEpoch((message['time'] is num ? (message['time'] as num).toInt() : DateTime.now().millisecondsSinceEpoch));
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) => Opacity(opacity: value, child: Transform.translate(offset: Offset(((mine ? 10 : -10) * (1 - value)).toDouble(), 0), child: child)),
      child: GestureDetector(onLongPress: onReply, child: Align(alignment: mine ? Alignment.centerRight : Alignment.centerLeft, child: Container(margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), padding: const EdgeInsets.fromLTRB(12, 8, 12, 6), constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.72), decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(18), border: mine ? null : Border.all(color: const Color(0xFFF3C9C9)), boxShadow: const [BoxShadow(color: Color(0x12000000), blurRadius: 5, offset: Offset(0, 2))]), child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
      if (!mine && (message['senderName'] ?? '').toString().isNotEmpty) Align(alignment: Alignment.centerRight, child: Text(message['senderName'], textDirection: TextDirection.rtl, style: const TextStyle(color: Color(0xFFE85C5C), fontWeight: FontWeight.bold, fontSize: 12))),
      if ((message['replyTo'] as Map?) != null) Container(width: double.infinity, margin: const EdgeInsets.only(bottom: 6), padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: mine ? Colors.white24 : const Color(0xFFFFF1F1), borderRadius: BorderRadius.circular(8)), child: Text(((message['replyTo'] as Map)['text'] ?? '').toString(), maxLines: 2, overflow: TextOverflow.ellipsis, textDirection: TextDirection.rtl, style: TextStyle(color: textColor, fontSize: 12))),
      if (audio.isNotEmpty) AudioPlayerWidget(id: (message['id'] ?? '').toString(), base64Audio: audio, waveform: (message['waveform'] ?? '').toString(), duration: (message['audioDuration'] as num? ?? 0).toInt(), color: textColor) else Text((message['text'] ?? '').toString(), textDirection: TextDirection.rtl, style: TextStyle(color: textColor, fontSize: 15)),
      const SizedBox(height: 2), Text('${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}', style: TextStyle(color: mine ? Colors.white70 : Colors.grey, fontSize: 10)),
    ])))));
  }
}
