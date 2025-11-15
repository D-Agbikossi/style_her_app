import 'package:flutter/material.dart';
import '../theme.dart';

class InboxScreen extends StatelessWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final chats = [
      {'name':'Natasha','msg':'Hi, Good Evening Bro!','time':'14:59','count':2},
      {'name':'Alex','msg':'I Just Finished It!','time':'12:47','count':2},
      {'name':'John','msg':'How are you?','time':'09:10','count':0},
      {'name':'Mia','msg':'OMG, This is Amazing.','time':'21:07','count':2},
      {'name':'Maria','msg':'Wow, This is Really Epic.','time':'16:51','count':0},
      {'name':'Tiya','msg':'I Just Finished It.','time':'08:49','count':0},
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Inbox'), actions: const [Padding(padding: EdgeInsets.only(right:16), child: Icon(Icons.search))]),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: chats.length,
        separatorBuilder: (_, __)=> const SizedBox(height: 12),
        itemBuilder: (_, i){
          final c = chats[i];
          return InkWell(
            onTap: ()=>Navigator.pushNamed(context, '/chat'),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.white, borderRadius: AppTheme.radius12, boxShadow: [BoxShadow(color: Colors.black.withOpacity(.05), blurRadius: 8)]),
              child: Row(children: [
                const CircleAvatar(radius: 22, backgroundColor: Colors.black12),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(c['name'] as String, style: const TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(c['msg'] as String, style: const TextStyle(color: AppTheme.softText, fontSize: 13), overflow: TextOverflow.ellipsis),
                ])),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Text(c['time'] as String, style: const TextStyle(color: AppTheme.softText, fontSize: 12)),
                  const SizedBox(height: 6),
                  if((c['count'] as int) > 0)
                    Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: AppTheme.primary, borderRadius: BorderRadius.circular(12)), child: Text('${c['count']}', style: const TextStyle(color: Colors.white))),
                ])
              ]),
            ),
          );
        },
      ),
    );
  }
}
