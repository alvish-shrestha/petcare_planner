import 'package:flutter/material.dart';
import 'package:petcare_planner_frontend/models/nav_items.dart';

class DashboardViewModel extends ChangeNotifier {
  NavItem _currentTab = NavItem.home;

  NavItem get currentTab => _currentTab;

  void changeTab(NavItem tab) {
    if (_currentTab == tab) return;
    _currentTab = tab;
    notifyListeners();
  }

  void reset() {
    _currentTab = NavItem.home;
    notifyListeners();
  }
}
