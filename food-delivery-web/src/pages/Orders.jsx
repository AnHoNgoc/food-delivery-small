import React, { useEffect, useState } from "react";
import ReactPaginate from "react-paginate";
import { getOrders, updateOrderStatus, deleteOrder } from "../services/orderService";
import CustomModal from "../components/CustomModal";
import { functions, httpsCallable } from "../firebase";
import { toast } from "react-hot-toast";
import { FaTrashAlt } from "react-icons/fa";

const statuses = ["pending", "confirmed", "delivering", "completed"];
const ORDERS_PER_PAGE = 10;

export default function Orders() {
    const [orders, setOrders] = useState([]);
    const [loading, setLoading] = useState(true);
    const [currentPage, setCurrentPage] = useState(0);

    const [statusModalOpen, setStatusModalOpen] = useState(false);
    const [selectedOrder, setSelectedOrder] = useState(null);
    const [selectedStatus, setSelectedStatus] = useState("");

    const [deleteModalOpen, setDeleteModalOpen] = useState(false);
    const [orderToDelete, setOrderToDelete] = useState(null);

    useEffect(() => {
        fetchOrders();
    }, []);

    const fetchOrders = async () => {
        setLoading(true);
        try {
            const data = await getOrders();
            setOrders(data);
        } catch (err) {
            console.error(err);
        } finally {
            setLoading(false);
        }
    };

    const handleStatusClick = (order, status) => {
        // Nếu đang bấm cancel, luôn cho phép
        if (status === "cancelled") {
            setSelectedOrder(order);
            setSelectedStatus(status);
            setStatusModalOpen(true);
            return;
        }

        // Các status tuyến tính
        const currentIndex = statuses.indexOf(order.status);
        const targetIndex = statuses.indexOf(status);

        // Nếu target status đã active hoặc bằng current thì không làm gì
        if (currentIndex >= targetIndex) return;

        setSelectedOrder(order);
        setSelectedStatus(status);
        setStatusModalOpen(true);
    };

    const handleConfirmStatus = async () => {
        if (!selectedOrder || !selectedStatus) return;

        try {
            // 1️⃣ Cập nhật trạng thái trong DB
            await updateOrderStatus(selectedOrder.id, selectedStatus);

            // 2️⃣ Fetch lại đơn hàng
            await fetchOrders();

            // 3️⃣ Thông báo thành công
            toast.success(`Order status updated to "${selectedStatus}"!`, {
                icon: "✅",
                style: {
                    background: "#10B981",
                    color: "#fff",
                    padding: "16px 24px",
                    borderRadius: "0.5rem",
                    fontWeight: "600",
                    boxShadow: "0 4px 14px rgba(0,0,0,0.1)",
                    fontSize: "16px",
                },
                position: "top-right",
                duration: 3000,
            });

            // 4️⃣ Gửi push notification, nhưng nếu fail thì chỉ log, không throw
            try {
                const sendPushNotification = httpsCallable(functions, "sendPushNotification");

                console.log("Id of user", selectedOrder.userId);

                await sendPushNotification({
                    customerId: selectedOrder.userId,
                    title: `Order ${selectedStatus}`,
                    body: `Your order #${selectedOrder.id} is now ${selectedStatus}`,
                    dataPayload: { orderId: selectedOrder.id, status: selectedStatus },
                });
            } catch (pushErr) {
                console.error("Push notification failed:", pushErr);
                toast.error("Push notification failed.", {
                    icon: "⚠️",
                    style: {
                        background: "#FBBF24",
                        color: "#000",
                        padding: "16px 24px",
                        borderRadius: "0.5rem",
                        fontWeight: "600",
                        boxShadow: "0 4px 14px rgba(0,0,0,0.1)",
                        fontSize: "16px",
                    },
                    position: "top-right",
                    duration: 3000,
                });
            }

        } catch (err) {
            console.error("Failed to update order:", err);
            toast.error("Failed to update order status.", {
                icon: "❌",
                style: {
                    background: "#EF4444",
                    color: "#fff",
                    padding: "16px 24px",
                    borderRadius: "0.5rem",
                    fontWeight: "600",
                    boxShadow: "0 4px 14px rgba(0,0,0,0.1)",
                    fontSize: "16px",
                },
                position: "top-right",
                duration: 3000,
            });
        } finally {
            setStatusModalOpen(false);
            setSelectedOrder(null);
            setSelectedStatus("");
        }
    };
    // ====== Delete Order ======
    const handleDeleteClick = (order) => {
        setOrderToDelete(order);
        setDeleteModalOpen(true);
    };

    const confirmDelete = async () => {
        if (!orderToDelete) return;

        try {
            await deleteOrder(orderToDelete.id);

            toast.success("Order deleted successfully!", {
                icon: "🗑️",
                style: {
                    background: "#EF4444",
                    color: "#fff",
                    padding: "16px 24px",
                    borderRadius: "0.5rem",
                    fontWeight: "600",
                    boxShadow: "0 4px 14px rgba(0,0,0,0.1)",
                    fontSize: "16px",
                },
                position: "top-right",
                duration: 3000,
            });

            await fetchOrders();
        } catch (err) {
            console.error("Failed to delete order:", err);
            toast.error("Failed to delete order!", {
                icon: "❌",
                style: {
                    background: "#DC2626",
                    color: "#fff",
                    padding: "16px 24px",
                    borderRadius: "0.5rem",
                    fontWeight: "600",
                    boxShadow: "0 4px 14px rgba(0,0,0,0.1)",
                    fontSize: "16px",
                },
                position: "top-right",
                duration: 3000,
            });
        } finally {
            setDeleteModalOpen(false);
            setOrderToDelete(null);
        }
    };

    const pageCount = Math.ceil(orders.length / ORDERS_PER_PAGE);
    const startIndex = currentPage * ORDERS_PER_PAGE;
    const currentOrders = orders.slice(startIndex, startIndex + ORDERS_PER_PAGE);
    const handlePageClick = (selectedItem) => setCurrentPage(selectedItem.selected);

    if (loading) {
        return (
            <div className="flex justify-center items-center h-64">
                <div className="w-12 h-12 border-4 border-blue-500 border-dashed rounded-full animate-spin"></div>
            </div>
        );
    }

    return (
        <div className="flex flex-col min-h-screen dark:bg-gray-800 p-6 max-w-7xl mx-auto">
            <h1 className="text-2xl font-bold mb-6 text-gray-800 dark:text-white">Orders List</h1>

            {currentOrders.map((order) => (
                <div key={order.id} className="mb-12">
                    <div className="bg-white dark:bg-gray-700 rounded-lg shadow p-4 mb-6 w-full md:w-1/2">
                        <div className="flex items-center justify-between">
                            <p className="text-gray-900 dark:text-white font-semibold">ID: {order.id}</p>
                            <div className="flex gap-3">
                                <button
                                    onClick={() => handleDeleteClick(order)}
                                    className="text-red-500 hover:text-red-600 transition-colors"
                                    title="Delete Order"
                                >
                                    <FaTrashAlt size={16} />
                                </button>
                            </div>
                        </div>
                        <p className="text-gray-600 dark:text-gray-300">Delivery Address: {order.deliveryAddress}</p>
                        <p className="text-gray-600 dark:text-gray-300">Order Date: {new Date(order.createdAt).toLocaleString()}</p>
                        <p className="text-gray-600 dark:text-gray-300">Total Price: ${order.totalPrice.toFixed(2)}</p>
                        <p className="mt-2 font-medium text-gray-700 dark:text-gray-200">Items:</p>
                        <ul className="list-disc list-inside text-gray-600 dark:text-gray-300">
                            {order.items.map((item, idx) => <li key={idx}>{item.food.name}</li>)}
                        </ul>
                        <p className="mt-2 flex items-center justify-between">
                            <span>
                                Current Status:{" "}
                                <span
                                    className={`font-bold ml-2 ${order.status === "cancelled"
                                        ? "text-red-500"
                                        : "text-blue-500"
                                        }`}
                                >
                                    {order.status.charAt(0).toUpperCase() + order.status.slice(1)}
                                </span>
                            </span>

                            {/* ❌ Nút hủy (chỉ hiển thị khi chưa bị cancelled) */}
                            {order.status !== "cancelled" && (
                                <button
                                    onClick={() => handleStatusClick(order, "cancelled")}
                                    className="ml-4 text-red-500 hover:text-red-700 transition"
                                    title="Cancel Order"
                                >
                                    <svg
                                        xmlns="http://www.w3.org/2000/svg"
                                        fill="none"
                                        viewBox="0 0 24 24"
                                        strokeWidth="2"
                                        stroke="currentColor"
                                        className="w-5 h-5"
                                    >
                                        <path
                                            strokeLinecap="round"
                                            strokeLinejoin="round"
                                            d="M6 18L18 6M6 6l12 12"
                                        />
                                    </svg>
                                </button>
                            )}
                        </p>
                    </div>

                    {/* Timeline */}
                    {order.status !== "cancelled" && (
                        <div className="w-full md:w-1/2 mt-4 flex flex-col relative">
                            <div className="flex items-center">
                                {statuses.map((status, idx) => {
                                    const isActive = statuses.indexOf(order.status) >= idx;
                                    return (
                                        <React.Fragment key={status}>
                                            <button
                                                onClick={() => idx !== statuses.indexOf(order.status) && handleStatusClick(order, status)}
                                                className={`w-6 h-6 rounded-full flex items-center justify-center border-2 shadow-md transition-colors
                                                ${isActive ? "bg-green-500 border-green-500" : "bg-gray-300 border-gray-300"}`}
                                            >
                                                {isActive && (
                                                    <svg className="w-4 h-4 text-white" fill="none" stroke="currentColor" strokeWidth="2" viewBox="0 0 24 24">
                                                        <path strokeLinecap="round" strokeLinejoin="round" d="M5 13l4 4L19 7" />
                                                    </svg>
                                                )}
                                            </button>
                                            {idx < statuses.length - 1 && (
                                                <div className="flex-1 h-1 bg-gray-300 relative mx-1">
                                                    {idx < statuses.indexOf(order.status) && <div className="absolute top-0 left-0 h-1 bg-green-500 w-full rounded"></div>}
                                                </div>
                                            )}
                                        </React.Fragment>
                                    );
                                })}
                            </div>

                            <div className="flex justify-between mt-2 px-1">
                                {statuses.map((status, idx) => {
                                    const isActive = statuses.indexOf(order.status) >= idx;
                                    return (
                                        <div key={status} className="text-xs text-center" style={{ width: "64px" }}>
                                            <span className={`${isActive ? "font-bold text-green-500" : "text-gray-500"}`}>
                                                {status.charAt(0).toUpperCase() + status.slice(1)}
                                            </span>
                                        </div>
                                    );
                                })}
                            </div>
                        </div>
                    )}
                </div>
            ))}

            {/* Pagination */}
            {pageCount > 1 && (
                <div className="flex justify-center mt-6">
                    <ReactPaginate
                        previousLabel={"<"} nextLabel={">"} breakLabel={"..."}
                        pageCount={pageCount} marginPagesDisplayed={2} pageRangeDisplayed={3}
                        onPageChange={handlePageClick}
                        containerClassName={"flex space-x-2"}
                        pageClassName={"px-3 py-1 bg-white dark:bg-gray-700 rounded hover:bg-indigo-500 hover:text-white cursor-pointer text-gray-800 dark:text-gray-200"}
                        activeClassName={"font-bold text-black"}
                        previousClassName={"px-3 py-1 bg-white dark:bg-gray-700 rounded hover:bg-indigo-500 hover:text-white cursor-pointer text-gray-800 dark:text-gray-200"}
                        nextClassName={"px-3 py-1 bg-white dark:bg-gray-700 rounded hover:bg-indigo-500 hover:text-white cursor-pointer text-gray-800 dark:text-gray-200"}
                        disabledClassName={"opacity-50 cursor-not-allowed"}
                    />
                </div>
            )}

            {/* Status Modal */}
            <CustomModal
                open={statusModalOpen}
                title="Confirm Status Update"
                confirmText="Update"
                cancelText="Cancel"
                onConfirm={handleConfirmStatus}
                onClose={() => setStatusModalOpen(false)}
            >
                Are you sure you want to update order #{selectedOrder?.id} to status "{selectedStatus}"?
            </CustomModal>

            {/* Delete Modal */}
            <CustomModal
                open={deleteModalOpen}
                title="Confirm Delete"
                confirmText="Delete"
                cancelText="Cancel"
                onConfirm={confirmDelete}
                onClose={() => setDeleteModalOpen(false)}
            >
                Are you sure you want to delete order #{orderToDelete?.id}?
            </CustomModal>
        </div>
    );
}