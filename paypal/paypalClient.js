require('dotenv').config();
const paypal = require('@paypal/checkout-server-sdk');

// Khởi tạo môi trường sandbox
const environment = new paypal.core.SandboxEnvironment(
    process.env.PAYPAL_CLIENT_ID,
    process.env.PAYPAL_CLIENT_SECRET
);

// Tạo 1 client PayPal duy nhất
const client = new paypal.core.PayPalHttpClient(environment);

module.exports = client;