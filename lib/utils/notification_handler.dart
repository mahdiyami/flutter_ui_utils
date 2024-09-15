import 'package:get/get.dart';

class NotificationHandler {
  final NotificationData notificationData;

  NotificationHandler(this.notificationData);

  Future<void> navigateToScreen() async {
    switch (notificationData.type) {
      case NotificationType.order:
        _handleOrderNotification();
        break;
      case NotificationType.systemMessage:
        _handleSystemMessageNotification();
        break;
      case NotificationType.inviteInRoom:
        _handleInviteInRoomNotification();
        break;
      case NotificationType.newMessage:
        _handleInviteInRoomNotification();
        break;
      case NotificationType.externalLink:
        _externalLinkNotification();
        break;
      case NotificationType.unknown:
        break;
    }
  }

  Future<void> _handleOrderNotification() async {
    Get.toNamed(Routes.orderDetailPage, arguments: notificationData.object);
  }

  Future<void> _handleProductNotification() async {
    Get.toNamed(Routes.productDetailPage, arguments: notificationData.object);
  }

  Future<void> _handleSystemMessageNotification() async {
    Get.toNamed(Routes.notifyPage, arguments: 1);
  }

  Future<void> _handleInviteInRoomNotification() async {
    Get.find<MainPageController>().changeIndex(3);
  }

  Future<void> _externalLinkNotification() async {
    launchUrl(Uri.parse(notificationData.object));
  }
}
