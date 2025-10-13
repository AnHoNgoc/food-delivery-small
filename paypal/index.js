const express = require('express');
const cors = require('cors');
const paypalClient = require('./paypalClient');
const paypal = require('@paypal/checkout-server-sdk');

const app = express();
app.use(cors({ origin: true }));
app.use(express.json());

// --- ROUTES ---
// Tạo order PayPal
app.post('/create-order', async (req, res) => {
    const { totalAmount } = req.body;
    if (!totalAmount) return res.status(400).json({ message: 'Amount required' });

    const request = new paypal.orders.OrdersCreateRequest();
    request.prefer('return=representation');
    request.requestBody({
        intent: 'CAPTURE',
        purchase_units: [
            {
                amount: { currency_code: 'USD', value: totalAmount }
            }
        ],
        application_context: {
            // Dùng port 5000 khi test local
            return_url: 'http://localhost:5000/capture-order',
            cancel_url: 'http://localhost:5000/cancel'
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

// Capture order
app.get('/capture-order', async (req, res) => {
    const orderID = req.query.token;
    if (!orderID) return res.send('Order ID missing');

    const request = new paypal.orders.OrdersCaptureRequest(orderID);
    request.requestBody({});

    try {
        const capture = await paypalClient.execute(request);
        res.json({
            message: "Payment captured successfully",
            status: capture.result.status,
            orderID: orderID,
        });
    } catch (err) {
        console.error('Error capturing order:', err);
        res.status(500).json({ message: 'Error capturing order', error: err.toString() });
    }
});

// Cancel
app.get('/cancel', (req, res) => {
    res.send('Payment cancelled');
});

// --- Chạy local ---
const PORT = 5000;
app.listen(PORT, () => console.log(`Server running at http://localhost:${PORT}`));