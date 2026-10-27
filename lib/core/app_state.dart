import 'package:flutter/foundation.dart';

/// Role model. Owner sees everything; Manager hides revenue/cost/margin;
/// Accounts sees money pages but cannot allocate vehicles or bid.
enum UserRole { owner, manager, accounts }

extension UserRoleX on UserRole {
  String get label {
    switch (this) {
      case UserRole.owner:
        return 'Owner';
      case UserRole.manager:
        return 'Manager';
      case UserRole.accounts:
        return 'Accounts';
    }
  }

  bool get canSeeFinancials => this != UserRole.manager;
  bool get canAllocateAndBid => this != UserRole.accounts;
}

/// Single flag required by the brief. Flip to false once real repositories exist.
const bool USE_MOCK_DATA = true;

// TODO: Replace with Riverpod StateNotifierProvider for production
class AppState extends ChangeNotifier {
  UserRole _role = UserRole.owner;
  bool _offline = false;
  int _unreadNotifications = 4;

  UserRole get role => _role;
  bool get offline => _offline;
  int get unreadNotifications => _unreadNotifications;

  void setRole(UserRole value) {
    if (_role == value) return;
    _role = value;
    notifyListeners();
  }

  void setOffline(bool value) {
    if (_offline == value) return;
    _offline = value;
    notifyListeners();
  }

  void clearNotifications() {
    _unreadNotifications = 0;
    notifyListeners();
  }
}

final AppState appState = AppState();
