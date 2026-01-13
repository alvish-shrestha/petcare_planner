import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:petcare_planner_frontend/models/notification_item.dart';
import 'package:petcare_planner_frontend/view_models/notification_view_model.dart';
import 'package:provider/provider.dart';
import 'package:petcare_planner_frontend/widgets/app_colors.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    // Load notifications from local storage when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationViewModel>().loadNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Watch the ViewModel for changes
    final viewModel = context.watch<NotificationViewModel>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              const SizedBox(height: 20),

              /// --- HEADER ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x19000000),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        size: 18,
                        color: AppColors.textPrimary,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const Text(
                    "Notifications",
                    style: TextStyle(
                      fontFamily: "Poppins-Bold",
                      fontSize: 20,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 40), // Balance
                ],
              ),

              const SizedBox(height: 30),

              /// --- BODY CONTENT ---
              Expanded(
                child: viewModel.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : viewModel.notifications.isEmpty
                    ? _buildEmptyState()
                    : RefreshIndicator(
                        onRefresh: () => viewModel.loadNotifications(),
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // TODAY SECTION
                              if (viewModel.todayNotifications.isNotEmpty) ...[
                                _buildSectionHeader("Today"),
                                const SizedBox(height: 10),
                                ...viewModel.todayNotifications.map(
                                  (n) => _NotificationItem(notification: n),
                                ),
                                const SizedBox(height: 20),
                              ],

                              // YESTERDAY SECTION
                              if (viewModel
                                  .yesterdayNotifications
                                  .isNotEmpty) ...[
                                _buildSectionHeader("Yesterday"),
                                const SizedBox(height: 10),
                                ...viewModel.yesterdayNotifications.map(
                                  (n) => _NotificationItem(notification: n),
                                ),
                                const SizedBox(height: 20),
                              ],

                              // OLDER SECTION
                              if (viewModel.olderNotifications.isNotEmpty) ...[
                                _buildSectionHeader("Earlier"),
                                const SizedBox(height: 10),
                                ...viewModel.olderNotifications.map(
                                  (n) => _NotificationItem(notification: n),
                                ),
                              ],

                              const SizedBox(height: 50), // Bottom Padding
                            ],
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontFamily: "Poppins-SemiBold",
          fontSize: 16,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.notifications_off_outlined, size: 60, color: Colors.grey),
          SizedBox(height: 10),
          Text(
            "No notifications yet",
            style: TextStyle(
              fontFamily: "Poppins",
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationItem extends StatelessWidget {
  final NotificationItem notification;

  const _NotificationItem({required this.notification});

  @override
  Widget build(BuildContext context) {
    // Format Time (e.g. 10:30 AM)
    final String timeString = DateFormat('jm').format(notification.createdAt);

    // Determine icon based on type
    IconData getIcon() {
      switch (notification.type.toLowerCase()) {
        case 'feeding':
          return Icons.restaurant;
        case 'walking':
          return Icons.directions_walk;
        case 'grooming':
          return Icons.content_cut;
        case 'medical':
          return Icons.local_hospital;
        default:
          return Icons.notifications;
      }
    }

    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        // Delete from storage
        final vm = context.read<NotificationViewModel>();
        vm.deleteNotification(notification.id);
      },
      background: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFFF6B6B),
          borderRadius: BorderRadius.circular(18),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: GestureDetector(
        onTap: () {
          // Mark as read when tapped
          if (!notification.isRead) {
            context.read<NotificationViewModel>().markAsRead(notification.id);
          }
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0D000000), // Very subtle shadow
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- ICON BOX ---
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: notification.isRead
                      ? const Color(0xFFF2F2F2)
                      : const Color(0xFFFFE1B3),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  getIcon(),
                  color: notification.isRead
                      ? Colors.grey
                      : AppColors.textPrimary,
                  size: 22,
                ),
              ),

              const SizedBox(width: 16),

              // --- CONTENT ---
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: TextStyle(
                              fontFamily: "Poppins-Medium",
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: notification.isRead
                                  ? Colors.grey[600]
                                  : AppColors.strongText,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          timeString,
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 12,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.body,
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 13,
                        height: 1.4,
                        color: notification.isRead
                            ? Colors.grey[500]
                            : AppColors.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // --- UNREAD DOT ---
              if (!notification.isRead)
                Padding(
                  padding: const EdgeInsets.only(left: 8, top: 5),
                  child: Container(
                    height: 8,
                    width: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
