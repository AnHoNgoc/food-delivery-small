import { useEffect, useState } from "react";
import { countOrdersByStatus } from "../services/orderService";
import { countProducts } from "../services/productService";
import { countUsers } from "../services/userService";
import { BarChart, Bar, XAxis, YAxis, Tooltip, CartesianGrid, ResponsiveContainer } from "recharts";

export default function Dashboard() {
    
    const [totalProducts, setTotalProducts] = useState(0);
    const [totalUsers, setTotalUsers] = useState(0);
    const [totalOrders, setTotalOrders] = useState(0);
    const [orderStats, setOrderStats] = useState([]);

    const statuses = ["pending", "confirmed", "delivering", "completed", "cancelled"];

    useEffect(() => {
        const fetchStats = async () => {
            try {
                const [products, users, orders] = await Promise.all([
                    countProducts(),
                    countUsers(),
                    countOrdersByStatus()
                ]);

                setTotalProducts(products);
                setTotalUsers(users);
                setTotalOrders(orders);

                // Lấy số lượng theo từng status
                const statusCounts = await Promise.all(
                    statuses.map(async status => {
                        const count = await countOrdersByStatus(status);
                        return { status, count };
                    })
                );
                setOrderStats(statusCounts);
            } catch (error) {
                console.error("Error fetching dashboard stats:", error);
            }
        };

        fetchStats();
    }, []);

    return (
        <div className="flex flex-col min-h-screen dark:bg-gray-800">
            <div className="max-w-7xl mx-auto w-full p-6">
                <h1 className="text-2xl font-bold mb-6 text-gray-800 dark:text-white">
                    Dashboard Overview
                </h1>

                {/* Stats Cards */}
                <div className="grid grid-cols-1 md:grid-cols-3 gap-4 mb-6">
                    <div className="p-4 bg-white dark:bg-gray-700 rounded-lg shadow">
                        Total Products: {totalProducts}
                    </div>
                    <div className="p-4 bg-white dark:bg-gray-700 rounded-lg shadow">
                        Total Orders: {totalOrders}
                    </div>
                    <div className="p-4 bg-white dark:bg-gray-700 rounded-lg shadow">
                        Total Users: {totalUsers}
                    </div>
                </div>

                {/* Biểu đồ Orders theo Status */}
                <div className="p-4 bg-white dark:bg-gray-700 rounded-lg shadow">
                    <h2 className="text-xl font-semibold mb-4 text-gray-800 dark:text-white">
                        Orders by Status
                    </h2>
                    <ResponsiveContainer width="100%" height={300}>
                        <BarChart data={orderStats}>
                            <CartesianGrid strokeDasharray="3 3" />
                            <XAxis dataKey="status" />
                            <YAxis />
                            <Tooltip />
                            <Bar dataKey="count" fill="#8884d8" />
                        </BarChart>
                    </ResponsiveContainer>
                </div>
            </div>
        </div>
    );
}