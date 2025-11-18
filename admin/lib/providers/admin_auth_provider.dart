/**
 * Admin Authentication Provider
 * 
 * Manages admin authentication with role-based access control.
 * Only users with admin role can access the admin interface.
 */

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AdminAuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _user;
  bool _isAdmin = false;
  bool _isLoading = true;
  StreamSubscription<User?>? _authSubscription;

  User? get user => _user;
  bool get isAdmin => _isAdmin;
  bool get isAuthenticated => _user != null;
  bool get isLoading => _isLoading;

  AdminAuthProvider() {
    _authSubscription = _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  Future<void> _onAuthStateChanged(User? user) async {
    _user = user;
    if (user != null) {
      await _checkAdminRole(user.uid);
    } else {
      _isAdmin = false;
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> _checkAdminRole(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      final role = doc.data()?['role'] as String?;
      _isAdmin = role == 'admin';
    } catch (e) {
      _isAdmin = false;
    }
    notifyListeners();
  }

  Future<void> signIn(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();

      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        await _checkAdminRole(credential.user!.uid);
        if (!_isAdmin) {
          await signOut();
          throw Exception('Access denied. Admin privileges required.');
        }
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    _user = null;
    _isAdmin = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}

