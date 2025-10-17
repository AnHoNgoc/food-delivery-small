const { onCall, HttpsError } = require("firebase-functions/v2/https");
const admin = require("firebase-admin");

admin.initializeApp();

exports.sendPushNotification = onCall({ region: "us-central1" }, async (req) => {
    const { customerId, title, body, dataPayload } = req.data;

    if (!customerId || !title || !body) {
        throw new HttpsError("invalid-argument", "Missing parameters");
    }

    const customerDoc = await admin.firestore().collection("users").doc(customerId).get();

    if (!customerDoc.exists) {
        throw new HttpsError("not-found", "Customer not found");
    }

    const fcmToken = customerDoc.data()?.fcmToken;

    if (!fcmToken) {
        throw new HttpsError("not-found", "Customer FCM token not found");
    }

    const message = {
        token: fcmToken,
        notification: { title, body },
        android: { priority: "high", notification: { channelId: "high_importance_channel", sound: "default" } },
        apns: { payload: { aps: { sound: "default" } } },
        data: Object.fromEntries(
            Object.entries(dataPayload || {}).map(([k, v]) => [k, String(v)])
        ),
    };

    await admin.messaging().send(message);
    return { success: true };
});