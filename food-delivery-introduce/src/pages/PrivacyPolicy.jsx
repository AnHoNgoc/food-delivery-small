export default function PrivacyPolicy() {
    return (
        <div className="min-h-screen bg-gray-50 px-6 py-12">
            <div className="max-w-4xl mx-auto bg-white shadow-md rounded-xl p-8">

                {/* Title */}
                <h1 className="text-4xl font-bold text-red-900 mb-8 text-center">
                    Privacy Policy
                </h1>

                {/* Introduction */}
                <section className="mb-6">
                    <p className="text-red-800 leading-relaxed">
                        Welcome to our Food Delivery App. Your privacy is very important to us. This Privacy Policy explains
                        how we collect, use, and protect your information when you use our app. By using the app, you
                        agree to the terms outlined in this policy.
                    </p>
                </section>

                {/* Data Collection */}
                <section className="mb-6">
                    <h2 className="text-2xl font-semibold text-red-900 mb-3">1. Data Collection</h2>
                    <p className="text-red-800 leading-relaxed mb-2">
                        We collect information necessary to provide our services. This may include:
                    </p>
                    <ul className="list-disc list-inside text-red-800 space-y-1">
                        <li>Account information (name, email, phone number)</li>
                        <li>Delivery addresses and contact details</li>
                        <li>Order history and preferences</li>
                        <li>Payment information for processing transactions</li>
                    </ul>
                </section>

                {/* Use of Data */}
                <section className="mb-6">
                    <h2 className="text-2xl font-semibold text-red-900 mb-3">2. How We Use Your Data</h2>
                    <p className="text-red-800 leading-relaxed">
                        The data collected is used for:
                    </p>
                    <ul className="list-disc list-inside text-red-800 space-y-1">
                        <li>Processing and delivering your orders efficiently</li>
                        <li>Improving app performance and user experience</li>
                        <li>Sending updates, promotions, and personalized offers</li>
                        <li>Ensuring security and preventing fraudulent activities</li>
                    </ul>
                </section>
                {/* Third-Party Services */}
                <section className="mb-6">
                    <h2 className="text-2xl font-semibold text-red-900 mb-3">3. Third-Party Services</h2>
                    <p className="text-red-800 leading-relaxed">
                        Our app may use third-party services for payment processing, delivery logistics, or analytics.
                        Please note that payments via PayPal are currently in test mode, and no real charges will be made.
                        Users can also choose to pay upon delivery (Cash on Delivery).
                        These third-party services may collect information as described in their own privacy policies. Examples include:
                    </p>
                    <ul className="list-disc list-inside text-red-800 space-y-1">
                        <li>PayPal (used in test mode for online payment)</li>
                        <li>Cash on Delivery option for payment upon receiving your order</li>
                        <li>Delivery partners and courier services</li>
                        <li>Analytics tools to monitor app performance</li>
                    </ul>
                </section>

                {/* Data Security */}
                <section className="mb-6">
                    <h2 className="text-2xl font-semibold text-red-900 mb-3">4. Data Security</h2>
                    <p className="text-red-800 leading-relaxed">
                        We implement industry-standard measures to protect your information from unauthorized access or misuse.
                        However, no system is completely secure. Please take precautions to keep your account credentials safe.
                    </p>
                </section>

                {/* User Rights */}
                <section className="mb-6">
                    <h2 className="text-2xl font-semibold text-red-900 mb-3">5. Your Rights</h2>
                    <p className="text-red-800 leading-relaxed">
                        You have the right to:
                    </p>
                    <ul className="list-disc list-inside text-red-800 space-y-1">
                        <li>Request information about the data we collect</li>
                        <li>Request correction or deletion of your data</li>
                        <li>Opt-out of promotional communications</li>
                    </ul>
                </section>

                {/* Contact */}
                <section>
                    <h2 className="text-2xl font-semibold text-red-900 mb-3">6. Contact Us</h2>
                    <p className="text-red-800 leading-relaxed">
                        If you have any questions or concerns regarding this Privacy Policy, please contact us at:
                        <a href="mailto:anhongoc1306@gmail.com" className="text-red-600 underline ml-1">
                            anhongoc1306@gmail.com
                        </a>
                    </p>
                </section>

            </div>
        </div>
    );
}