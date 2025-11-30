

const Support = () => {
    return (
        <div className="min-h-screen bg-gray-50 px-6 py-12">
            <div className="max-w-4xl mx-auto bg-white shadow-md rounded-xl p-8">

                {/* Title */}
                <h1 className="text-4xl font-bold text-red-900 mb-8 text-center">
                    Food Delivery App Support
                </h1>

                {/* Introduction */}
                <section className="mb-6">
                    <p className="text-red-800 leading-relaxed">
                        Welcome to the Food Delivery App Support page. Here you can find guidance on how to use the app and get help if you encounter any issues.
                    </p>
                </section>

                {/* Account Registration & Login */}
                <section className="mb-6">
                    <h2 className="text-2xl font-semibold text-red-900 mb-3">1. Account Registration & Login</h2>
                    <p className="text-red-800 leading-relaxed mb-2">
                        To place orders and track deliveries, you need an account. You can register or login using your email:
                    </p>
                    <ul className="list-disc list-inside text-red-800 space-y-1">
                        <li>Open the app and tap "Sign Up" to create a new account using your email and password.</li>
                        <li>If you already have an account, tap "Login" and enter your registered email and password.</li>
                        <li>After logging in, you can save your delivery address, view order history, and use other features.</li>
                    </ul>
                </section>

                {/* Placing an Order */}
                <section className="mb-6">
                    <h2 className="text-2xl font-semibold text-red-900 mb-3">2. Placing an Order</h2>
                    <p className="text-red-800 leading-relaxed mb-2">To order food from your favorite restaurants:</p>
                    <ul className="list-disc list-inside text-red-800 space-y-1">
                        <li>Open the app and browse available restaurants.</li>
                        <li>Select the items you want to order and add them to your cart.</li>
                        <li>Go to checkout and enter your delivery address.</li>
                        <li>You can choose to pay online via PayPal or pay upon delivery (Cash on Delivery).</li>
                        <li>Confirm the order to place it.</li>
                    </ul>
                </section>

                {/* Tracking Your Order */}
                <section className="mb-6">
                    <h2 className="text-2xl font-semibold text-red-900 mb-3">3. Tracking Your Order</h2>
                    <p className="text-red-800 leading-relaxed mb-2">After placing an order, you can track its status in real-time:</p>
                    <ul className="list-disc list-inside text-red-800 space-y-1">
                        <li>Open the "Orders" tab in the app.</li>
                        <li>Select your current order to view its status and estimated delivery time.</li>
                        <li>Notifications will alert you when the delivery is on its way.</li>
                    </ul>
                </section>

                {/* FAQ */}
                <section className="mb-6">
                    <h2 className="text-2xl font-semibold text-red-900 mb-3">4. Frequently Asked Questions</h2>
                    <div className="text-red-800 leading-relaxed space-y-3">
                        <div>
                            <p><strong>Q: How do I place an order?</strong></p>
                            <p>
                                A: Browse restaurants, select your items, and enter your delivery address at checkout.
                                You can choose to pay online via PayPal or pay upon delivery (Cash on Delivery).
                            </p>
                        </div>
                        <div>
                            <p><strong>Q: Can I track my order?</strong></p>
                            <p>A: Yes, go to the "Orders" tab to see the status and estimated delivery time.</p>
                        </div>
                        <div>
                            <p><strong>Q: What if I encounter a problem with the app?</strong></p>
                            <p>A: You can contact us via the email below.</p>
                        </div>
                    </div>
                </section>

                {/* Contact Support */}
                <section>
                    <h2 className="text-2xl font-semibold text-red-900 mb-3">5. Contact Support</h2>
                    <p className="text-red-800 leading-relaxed">
                        If you have any questions, concerns, or feedback, please reach out to us at:{" "}
                        <a href="mailto:anhongoc1306@gmail.com" className="text-red-600 underline">
                            anhongoc1306@gmail.com
                        </a>
                    </p>
                </section>

            </div>
        </div>
    );
};

export default Support;