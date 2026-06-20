import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:modish_store/core/colors.dart';
import 'package:modish_store/core/fontstyle.dart';
import 'package:modish_store/features/HomePage/data/models/notification/notification_model.dart';
import 'package:modish_store/features/HomePage/logic/notification_cubit/notification_cubit.dart';
import 'package:modish_store/features/HomePage/logic/notification_cubit/notification_state.dart';
import 'package:modish_store/features/HomePage/presentation/view/widget/custom_app_bar.dart';

class NotificationBody extends StatelessWidget {
  const NotificationBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationCubit, NotificationState>(
      builder: (context, state) {
        if (state is NotificationLoading) {
          return const Center(
            child: CircularProgressIndicator(color: kPrimaryColor),
          );
        } else if (state is NotificationError) {
          return Center(
            child: Text(
              state.message,
              style: t16.copyWith(color: Colors.red),
            ),
          );
        } else if (state is NotificationLoaded) {
          final notifications = state.notifications;
          final isEmpty = notifications.isEmpty;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: CustomAppbar(
                  leftIcon: "assets/icons/Arrow.svg",
                  title: "Notification",
                  rightIcon: "assets/icons/Icon.svg", // recycle/delete icon from assets
                  showIcon: !isEmpty,
                  leftIconOnTap: () {
                    Navigator.pop(context);
                  },
                  rightIconOnTap: () {
                    _showClearAllDialog(context);
                  },
                ),
              ),
              if (isEmpty) ...[
                SizedBox(height: MediaQuery.of(context).size.height * .2),
                Image.asset("assets/images/illustration  & text.png", height: 280),
                const SizedBox(height: 32),
                Text(
                  "NO NOTIFICATIONS",
                  style: t18.copyWith(
                    color: kPrimaryText(context),
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ] else ...[
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      final notification = notifications[index];
                      return NotificationItemCard(notification: notification);
                    },
                  ),
                ),
              ],
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  void _showClearAllDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          "Clear All",
          style: t18.copyWith(
            fontWeight: FontWeight.bold,
            color: kPrimaryText(context),
          ),
        ),
        content: Text(
          "Are you sure you want to delete all notifications?",
          style: t14.copyWith(color: kSecondaryText(context)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: Text(
              "Cancel",
              style: TextStyle(color: kSecondaryText(context)),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              context.read<NotificationCubit>().clearAllNotifications();
              Navigator.pop(dialogCtx);
            },
            child: const Text("Clear All", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class NotificationItemCard extends StatefulWidget {
  final NotificationModel notification;
  const NotificationItemCard({super.key, required this.notification});

  @override
  State<NotificationItemCard> createState() => _NotificationItemCardState();
}

class _NotificationItemCardState extends State<NotificationItemCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final notification = widget.notification;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: kCardColor(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.grey.shade100,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          key: PageStorageKey(notification.id),
          initiallyExpanded: _isExpanded,
          onExpansionChanged: (expanded) {
            setState(() {
              _isExpanded = expanded;
            });
            if (!notification.isRead) {
              context.read<NotificationCubit>().markAsRead(notification.id);
            }
          },
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.shopping_bag_outlined,
              color: Colors.green,
              size: 24,
            ),
          ),
          title: Text(
            notification.title,
            style: t14.copyWith(
              color: kPrimaryText(context),
              fontWeight: notification.isRead ? FontWeight.w600 : FontWeight.w900,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Gap(4),
              Text(
                notification.message,
                style: t12.copyWith(color: kSecondaryText(context)),
              ),
              const Gap(6),
              Text(
                _formatDateTime(notification.timestamp),
                style: TextStyle(
                  fontSize: 10,
                  color: kSecondaryText(context).withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
          trailing: Icon(
            _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
            color: kPrimaryText(context),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(height: 1),
                  const Gap(12),
                  Text(
                    "Order Details",
                    style: t14.copyWith(
                      fontWeight: FontWeight.w700,
                      color: kPrimaryText(context),
                    ),
                  ),
                  const Gap(8),
                  if (notification.items != null && notification.items!.isNotEmpty)
                    ...notification.items!.map((item) => Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: item.productImage != null &&
                                        item.productImage!.startsWith('http')
                                    ? CachedNetworkImage(
                                        imageUrl: item.productImage!,
                                        width: 40,
                                        height: 40,
                                        fit: BoxFit.cover,
                                        errorWidget: (_, _, _) => Container(
                                          width: 40,
                                          height: 40,
                                          color: isDark ? Colors.white10 : Colors.grey.shade100,
                                          child: const Icon(Icons.image, size: 20, color: Colors.grey),
                                        ),
                                      )
                                    : Container(
                                        width: 40,
                                        height: 40,
                                        color: isDark ? Colors.white10 : Colors.grey.shade100,
                                        child: const Icon(Icons.image, size: 20, color: Colors.grey),
                                      ),
                              ),
                              const Gap(10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.productName,
                                      style: t13.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: kPrimaryText(context),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      "Quantity: ${item.quantity}",
                                      style: t12.copyWith(color: kSecondaryText(context)),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                "\$${(item.price * item.quantity).toStringAsFixed(2)}",
                                style: t13.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: kPrimaryText(context),
                                ),
                              ),
                            ],
                          ),
                        )),
                  const Divider(height: 16),
                  if (notification.shippingAddress != null) ...[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.location_on_outlined, size: 16, color: kSecondaryText(context)),
                        const Gap(6),
                        Expanded(
                          child: Text(
                            "Shipping Address: ${notification.shippingAddress}",
                            style: t12.copyWith(color: kSecondaryText(context)),
                          ),
                        ),
                      ],
                    ),
                    const Gap(8),
                  ],
                  if (notification.totalPrice != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total Amount:",
                          style: t14.copyWith(
                            fontWeight: FontWeight.w700,
                            color: kPrimaryText(context),
                          ),
                        ),
                        Text(
                          "\$${notification.totalPrice!.toStringAsFixed(2)}",
                          style: t14.copyWith(
                            fontWeight: FontWeight.w900,
                            color: kPrimaryColor,
                          ),
                        ),
                      ],
                    ),
                  const Divider(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.redAccent,
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        ),
                        onPressed: () {
                          context.read<NotificationCubit>().deleteNotification(notification.id);
                        },
                        icon: const Icon(Icons.delete_outline, size: 16),
                        label: const Text("Delete", style: TextStyle(fontSize: 12)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dt) {
    final now = DateTime.now();
    final difference = now.difference(dt);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} mins ago';
    } else if (difference.inHours < 24 && now.day == dt.day) {
      final hour = dt.hour == 0 ? 12 : (dt.hour > 12 ? dt.hour - 12 : dt.hour);
      final period = dt.hour >= 12 ? 'PM' : 'AM';
      final minute = dt.minute.toString().padLeft(2, '0');
      return 'Today, $hour:$minute $period';
    } else if (difference.inDays < 2 &&
        now.subtract(const Duration(days: 1)).day == dt.day) {
      final hour = dt.hour == 0 ? 12 : (dt.hour > 12 ? dt.hour - 12 : dt.hour);
      final period = dt.hour >= 12 ? 'PM' : 'AM';
      final minute = dt.minute.toString().padLeft(2, '0');
      return 'Yesterday, $hour:$minute $period';
    } else {
      final months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      final hour = dt.hour == 0 ? 12 : (dt.hour > 12 ? dt.hour - 12 : dt.hour);
      final period = dt.hour >= 12 ? 'PM' : 'AM';
      final minute = dt.minute.toString().padLeft(2, '0');
      return '${dt.day} ${months[dt.month - 1]} ${dt.year}, $hour:$minute $period';
    }
  }
}
