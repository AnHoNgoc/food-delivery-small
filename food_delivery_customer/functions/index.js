const functions = require("firebase-functions");
const admin = require("firebase-admin");
const axios = require("axios");
const cors = require("cors")({ origin: true });

admin.initializeApp();

const PAYPAL_CLIENT_ID = functions.config().paypal.client_id;
const PAYPAL_CLIENT_SECRET = functions.config().paypal.client_secret;
const PAYPAL_API = "https://api-m.sandbox.paypal.com";

/**
 * 
 * Get PayPal access token
 */

async function getAccessToken() {
    try {
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
            data: "grant_type=client_credentials",
        });

        return response.data.access_token;
    } catch (err) {
        console.error("PayPal Auth Error:", err.response?.data || err.message);
        throw new Error("Failed to get PayPal access token");
    }
}

/**
 * Create order endpoint
 */
exports.createOrder = functions.https.onRequest(async (req, res) => {
    return cors(req, res, async () => {
        if (req.method !== "POST") {
            return res.status(405).send("Method Not Allowed");
        }

        try {
            const accessToken = await getAccessToken();
            const { amount, currency } = req.body;

            const orderResponse = await axios.post(
                `${PAYPAL_API}/v2/checkout/orders`,
                {
                    intent: "CAPTURE",
                    purchase_units: [
                        {
                            amount: {
                                currency_code: currency || "USD",
                                value: amount || "0.00",
                            },
                        },
                    ],
                    application_context: {
                        brand_name: "MyApp",
                        landing_page: "LOGIN",
                        user_action: "PAY_NOW",
                        return_url: "myapp://checkout-success",
                        cancel_url: "myapp://checkout-cancel",
                    },
                },
                {
                    headers: {
                        "Content-Type": "application/json",
                        Authorization: `Bearer ${accessToken}`,
                    },
                }
            );

            // 🔹 Lấy link "approve" để người dùng mở PayPal
            const approvalUrl = orderResponse.data.links.find(
                (link) => link.rel === "approve"
            )?.href;

            res.status(200).json({
                orderId: orderResponse.data.id,
                approvalUrl, // 👈 cái này mới là link bạn cần
            });
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

        if (req.method !== "POST") {
            return res.status(405).send("Method Not Allowed");
        }


        try {
            const { orderId } = req.body;

            if (!orderId) {
                return res.status(400).json({ error: "Missing orderId" });
            }

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
