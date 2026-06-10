const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.broadcastThoughtV1 = functions.https.onCall(async (data, context) => {
  const { title, body, topic } = data;

  if (!title || !body) {
    throw new functions.https.HttpsError('invalid-argument', 'The function must be called with a "title" and "body" attribute.');
  }

  const targetTopic = topic || 'couple_thoughts';

  const payload = {
    notification: {
      title: title,
      body: body,
    },
    topic: targetTopic,
    // Android: high priority wakes the device and uses the correct channel
    android: {
      priority: 'high',
      notification: {
        channelId: 'bunny_hoops_channel',
        priority: 'max',
        defaultSound: true,
        defaultVibrateTimings: true,
      },
    },
    // iOS: content-available wakes the app in background; apns-priority 10 = immediate delivery
    apns: {
      headers: {
        'apns-priority': '10',
      },
      payload: {
        aps: {
          'content-available': 1,
          sound: 'default',
          badge: 1,
        },
      },
    },
  };

  try {
    const response = await admin.messaging().send(payload);
    console.log('Successfully sent message:', response);
    return { success: true, messageId: response };
  } catch (error) {
    console.error('Error sending message:', error);
    throw new functions.https.HttpsError('internal', 'Failed to send notification', error);
  }
});
