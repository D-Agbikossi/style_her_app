import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Example user profile CRUD under users/{uid}
  CollectionReference<Map<String, dynamic>> get users => _db.collection('users');

  Future<void> createOrUpdateUser(String uid, Map<String, dynamic> data) async {
    await users.doc(uid).set({
      ...data,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUser(String uid) async {
    return await users.doc(uid).get();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> watchUser(String uid) {
    return users.doc(uid).snapshots();
  }

  // Example subcollection: users/{uid}/wardrobes
  CollectionReference<Map<String, dynamic>> wardrobes(String uid) => users.doc(uid).collection('wardrobes');

  Future<DocumentReference<Map<String, dynamic>>> addWardrobe(String uid, Map<String, dynamic> data) async {
    return await wardrobes(uid).add({
      ...data,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> watchWardrobes(String uid) {
    return wardrobes(uid).orderBy('createdAt', descending: true).snapshots();
  }
}
