import 'package:flutter/material.dart';
import '../theme_cubit.dart';
import '../widgets/chat_bubble.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final msgs = [
      {'me': false, 'text': 'Hi, Nicholas Good Evening 😊', 'time': '10:45'},
      {
        'me': false,
        'text': 'How was your Hair Styling Course Like? 😊',
        'time': '12:45',
      },
      {'me': true, 'text': 'Hi, Morning too Ronald', 'time': '15:29'},
      {
        'me': true,
        'text': 'Hello, I also just finished practicing my styling skills.',
        'time': '15:52',
      },
      {'me': false, 'text': 'OMG, This is Amazing..', 'time': '15:59'},
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Natasha'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.search),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: const Text(
              'Today',
              style: TextStyle(color: AppTheme.softText),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: msgs.length,
              itemBuilder: (_, i) {
                final m = msgs[i];
                return ChatBubble(
                  text: m['text'] as String,
                  isMe: m['me'] as bool,
                  time: m['time'] as String,
                );
              },
            ),
          ),
          _inputBar(),
        ],
      ),
    );
  }

  Widget _inputBar() {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: AppTheme.accent,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Message',
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.emoji_emotions_outlined),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.attach_file_outlined),
            ),
            Container(
              decoration: const BoxDecoration(
                color: AppTheme.primary,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.send, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
