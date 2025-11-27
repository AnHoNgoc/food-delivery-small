import mainImage from '../../public/image.png'

export default function Home() {
    return (
        <div className="min-h-screen bg-green-50 flex flex-col items-center justify-center px-4 py-12">

            {/* Main Image */}
            <img
                src={mainImage}
                alt="Food Delivery App"
                className="w-96 md:w-[500px] mb-8 rounded-lg shadow-lg transition-transform duration-500 hover:scale-105"
            />

            {/* Title */}
            <h1 className="text-4xl md:text-5xl font-bold text-yellow-900 mb-4 text-center">
                Food Delivery App
            </h1>

            {/* Description */}
            <p className="text-center text-yellow-800 max-w-xl mb-12">
                Order your favorite meals from local restaurants and get them delivered fast and fresh. Browse menus, track your delivery, and enjoy delicious food at your doorstep.
            </p>

            {/* Features */}
            <div className="max-w-4xl w-full grid grid-cols-1 md:grid-cols-2 gap-6 text-yellow-900">
                {/* Feature 1 */}
                <div className="bg-white rounded-xl shadow-md p-6 hover:shadow-xl transition">
                    <h3 className="text-xl font-semibold mb-2">Single Restaurant</h3>
                    <p>Browse the menu and place orders from our single featured restaurant.</p>
                </div>

                {/* Feature 2 */}
                <div className="bg-white rounded-xl shadow-md p-6 hover:shadow-xl transition">
                    <h3 className="text-xl font-semibold mb-2">Real-Time Tracking</h3>
                    <p>Track your orders in real-time and receive notifications.</p>
                </div>

                {/* Feature 3 */}
                <div className="bg-white rounded-xl shadow-md p-6 hover:shadow-xl transition">
                    <h3 className="text-xl font-semibold mb-2">Secure Payments</h3>
                    <p>Safe payment options and view your order history anytime.</p>
                </div>

                {/* Feature 4 */}
                <div className="bg-white rounded-xl shadow-md p-6 hover:shadow-xl transition">
                    <h3 className="text-xl font-semibold mb-2">User-Friendly Interface</h3>
                    <p>Easy-to-use interface optimized for both mobile and desktop.</p>
                </div>

                {/* Feature 5 */}
                <div className="bg-white rounded-xl shadow-md p-6 hover:shadow-xl transition">
                    <h3 className="text-xl font-semibold mb-2">Special Offers</h3>
                    <p>Enjoy special discounts and promotions for loyal customers.</p>
                </div>

                {/* Feature 6 - New */}
                <div className="bg-white rounded-xl shadow-md p-6 hover:shadow-xl transition">
                    <h3 className="text-xl font-semibold mb-2">Fast Delivery</h3>
                    <p>Get your meals delivered quickly and fresh right to your door.</p>
                </div>
            </div>
        </div>
    );
}