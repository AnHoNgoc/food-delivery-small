const { onCall, HttpsError } = require("firebase-functions/v2/https");
const admin = require("firebase-admin");

admin.initializeApp();

exports.sendPushNotification = onCall({ region: "us-central1" }, async (req) => {
    const { customerId, title, body, dataPayload } = req.data;

    if (!customerId || !title || !body) {
        throw new HttpsError("invalid-argument", "Missing parameters");
    }

    console.log("======== SEND PUSH =========");
    console.log("customerId:", customerId);

    const tokenQuery = await admin.firestore()
        .collection("tokens")
        .where("userId", "==", customerId)
        .orderBy("updatedAt", "desc")
        .limit(1)
        .get();

    console.log("matched tokens:", tokenQuery.size);

    if (tokenQuery.empty) {
        throw new HttpsError("not-found", "Receiver FCM token not found");
    }

    const fcmToken = tokenQuery.docs[0].id;

    if (!fcmToken) {
        throw new HttpsError("not-found", "FCM token is empty");
    }

    const message = {
        token: fcmToken,
        android: {
            priority: "high",
            notification: {
                channelId: "high_importance_channel",
                sound: "default",
                title: title,
                body: body,
            },
        },
        apns: {
            headers: {
                "apns-priority": "10",
                "apns-push-type": "alert"
            },
            payload: {
                aps: {
                    alert: {
                        title,
                        body
                    },
                    sound: "default",
                }
            }
        },
        data: Object.fromEntries(
            Object.entries(dataPayload || {}).map(([k, v]) => [k, String(v)])
        ),
    };

    await admin.messaging().send(message);
    return { success: true };
});


