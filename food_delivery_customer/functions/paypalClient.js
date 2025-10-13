const functions = require('firebase-functions');
const paypal = require('@paypal/checkout-server-sdk');

// Khởi tạo môi trường sandbox
const environment = new paypal.core.SandboxEnvironment(
    functions.config().paypal.client_id,
    functions.config().paypal.client_secret
);

// Tạo 1 client PayPal duy nhất
const client = new paypal.core.PayPalHttpClient(environment);

// Tạo helper execute để dùng như trước
module.exports = {
    execute: (request) => client.execute(request)
};