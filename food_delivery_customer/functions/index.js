const functions = require('firebase-functions');
const express = require('express');
const cors = require('cors');
const paypalClient = require('./paypalClient');
const paypal = require('@paypal/checkout-server-sdk');

const app = express();
app.use(cors({ origin: true }));
app.use(express.json());


// POST /create-order
app.post('/create-order', async (req, res) => {
    const { totalAmount } = req.body;
    if (!totalAmount) return res.status(400).json({ message: 'Amount required' });

    // Lấy baseUrl động từ request
    const baseUrl = `${req.protocol}://${req.get('host')}`;

    const request = new paypal.orders.OrdersCreateRequest();
    request.prefer('return=representation');
    request.requestBody({
        intent: 'CAPTURE',
        purchase_units: [
            { amount: { currency_code: 'USD', value: totalAmount } }
        ],
        application_context: {
            return_url: `${baseUrl}/capture-order`,
            cancel_url: `${baseUrl}/cancel`
        }
    });

    try {
        const order = await paypalClient.execute(request);
        const approvalUrl = order.result.links.find(l => l.rel === 'approve').href;
        res.json({ id: order.result.id, approvalUrl });
    } catch (err) {
        console.error('Error creating order:', err);
        res.status(500).json({ message: 'Error creating PayPal order' });
    }
});

// GET /capture-order
app.get('/capture-order', async (req, res) => {
    const orderID = req.query.token;
    if (!orderID) return res.send('Order ID missing');

    const request = new paypal.orders.OrdersCaptureRequest(orderID);
    request.requestBody({});

    try {
        const capture = await paypalClient.execute(request);
        res.redirect(`myapp://payment-success?status=${capture.result.status}`);
    } catch (err) {
        console.error('Error capturing order:', err);
        res.redirect('myapp://payment-failed');
    }
});

// GET /cancel
app.get('/cancel', (req, res) => {
    res.redirect('myapp://payment-cancelled');
});

// Export function cho Firebase
exports.api = functions.https.onRequest(app);