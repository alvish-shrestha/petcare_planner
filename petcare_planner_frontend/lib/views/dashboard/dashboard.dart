// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:petcare_planner_frontend/models/nav_items.dart';
import 'package:petcare_planner_frontend/widgets/app_colors.dart';
import 'package:petcare_planner_frontend/view_models/dashboard_view_model.dart';
import 'package:petcare_planner_frontend/views/dashboard/screens/calendar.dart';
import 'package:petcare_planner_frontend/views/dashboard/screens/home.dart';
import 'package:petcare_planner_frontend/views/dashboard/screens/rewards.dart';
import 'package:petcare_planner_frontend/views/dashboard/screens/settings.dart';
import 'package:provider/provider.dart';
import '../../widgets/bottom_nav/custom_bottom_nav.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DashboardViewModel>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: _buildBody(vm.currentTab),
      bottomNavigationBar: CustomBottomNav(
        current: vm.currentTab,
        onChanged: vm.changeTab,
      ),
    );
  }

  Widget _buildBody(NavItem tab) {
    switch (tab) {
      case NavItem.home:
        return const Home();
      case NavItem.calendar:
        return const Calendar();
      case NavItem.rewards:
        return const Rewards();
      case NavItem.settings:
        return const Settings();
    }
  }
}
