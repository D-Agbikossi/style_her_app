import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../models/user_profile.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService;
  final FirestoreService _firestore;

  User? _firebaseUser;
  UserProfile? _profile;
  StreamSubscription<User?>? _authSub;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _profileSub;

  AuthProvider({AuthService? authService, FirestoreService? firestore})
      : _authService = authService ?? AuthService(),
        _firestore = firestore ?? FirestoreService() {
    _authSub = _authService.authStateChanges().listen(_onAuthChange);
  }

  User? get user => _firebaseUser;
  UserProfile? get profile => _profile;
  bool get isAuthenticated => _firebaseUser != null;
  bool get isEmailVerified => _firebaseUser?.emailVerified ?? false;

  Future<void> signIn(String email, String password) async {
    await _authService.signInWithEmail(email, password);
  }

  Future<void> signUp(String email, String password, {String? displayName}) async {
    final cred = await _authService.signUpWithEmail(email, password);
    await _firestore.createOrUpdateUser(cred.user!.uid, {
      'email': email,
      if (displayName != null) 'displayName': displayName,
    });
    await _authService.sendEmailVerification();
  }

  Future<void> signOut() async {
    await _authService.signOut();
  }

  Future<void> resetPassword(String email) => _authService.sendPasswordResetEmail(email);

  void _onAuthChange(User? user) {
    _firebaseUser = user;
    _profile = null;
    _profileSub?.cancel();

    if (user != null) {
      _profileSub = _firestore.watchUser(user.uid).listen((doc) {
        _profile = UserProfile.fromMap(user.uid, doc.data());
        notifyListeners();
      });
    } else {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _authSub?.cancel();
    _profileSub?.cancel();
    super.dispose();
  }
}
