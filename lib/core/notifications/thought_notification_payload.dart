import '../constants/app_strings.dart';
import '../models/profile.dart';

class ThoughtNotificationPayload {
  const ThoughtNotificationPayload({
    required this.title,
    required this.body,
    required this.topic,
  });

  final String title;
  final String body;
  final String topic;
}

class ThoughtNotificationPayloadFactory {
  const ThoughtNotificationPayloadFactory();

  ThoughtNotificationPayload create({
    required Profile sender,
    required String body,
  }) {
    return ThoughtNotificationPayload(
      title:
          AppStrings.thoughtNotificationTitle(sender.senderName, sender.icon),
      body: body,
      topic: sender.senderTopic,
    );
  }
}
