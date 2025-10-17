const functions = require("firebase-functions");
const admin = require("firebase-admin");
const axios = require("axios");
const cors = require("cors")({ origin: true });
require("dotenv").config();

admin.initializeApp();

const PAYPAL_CLIENT_ID = process.env.PAYPAL_CLIENT_ID;
const PAYPAL_CLIENT_SECRET = process.env.PAYPAL_CLIENT_SECRET;
const PAYPAL_API = process.env.PAYPAL_API;

/**
 * Get PayPal access token
 */
async function getAccessToken() {
    const response = await axios({
        url: `${PAYPAL_API}/v1/oauth2/token`,
        method: "post",
        headers: {
            Accept: "application/json",
            "Accept-Language": "en_US",
            "Content-Type": "application/x-www-form-urlencoded",
        },
        auth: {
            username: PAYPAL_CLIENT_ID,
            password: PAYPAL_CLIENT_SECRET,
        },
        params: {
            grant_type: "client_credentials",
        },
    });
    return response.data.access_token;
}

/**
 * Create order endpoint
 */
exports.createOrder = functions.https.onRequest(async (req, res) => {
    return cors(req, res, async () => {
        try {
            const accessToken = await getAccessToken();
            const { amount, currency } = req.body; // ex: { amount: "10.00", currency: "USD" }

            const order = await axios.post(
                `${PAYPAL_API}/v2/checkout/orders`,
                {
                    intent: "CAPTURE",
                    purchase_units: [
                        {
                            amount: {
                                currency_code: currency || "USD",
                                value: amount || "10.00",
                            },
                        },
                    ],
                },
                {
                    headers: {
                        "Content-Type": "application/json",
                        Authorization: `Bearer ${accessToken}`,
                    },
                }
            );

            res.status(200).json(order.data);
        } catch (err) {
            console.error("PayPal Create Order Error:", err.message);
            res.status(500).json({ error: err.message });
        }
    });
});

/**
 * Capture order endpoint
 */
exports.captureOrder = functions.https.onRequest(async (req, res) => {
    return cors(req, res, async () => {
        try {
            const { orderId } = req.body;
            const accessToken = await getAccessToken();

            const capture = await axios.post(
                `${PAYPAL_API}/v2/checkout/orders/${orderId}/capture`,
                {},
                {
                    headers: {
                        "Content-Type": "application/json",
                        Authorization: `Bearer ${accessToken}`,
                    },
                }
            );

            res.status(200).json(capture.data);
        } catch (err) {
            console.error("PayPal Capture Error:", err.message);
            res.status(500).json({ error: err.message });
        }
    });
});