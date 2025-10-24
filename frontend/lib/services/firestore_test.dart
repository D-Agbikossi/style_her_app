import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> testFirestore() async {
  try {
    await FirebaseFirestore.instance.collection('test').add({'check': 'connected'});
    print('✅ Firestore write succeeded');
  } catch (e) {
    print('❌ Firestore error: $e');
  }
}