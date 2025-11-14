import { db } from "../firebase";
import {
    collection,
    getDocs,
    addDoc,
    updateDoc,
    doc,
    deleteDoc,
    query,
    orderBy,
    where,
    getCountFromServer
} from "firebase/firestore";

// Tham chiếu tới collection "orders"
const ordersCollection = collection(db, "orders");

// Lấy tất cả đơn hàng
export const getOrders = async () => {
    try {
        // Tạo query: sắp xếp theo createdAt giảm dần (mới nhất trước)
        const q = query(ordersCollection, orderBy("createdAt", "desc"));
        const snapshot = await getDocs(q);
        return snapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));
    } catch (error) {
        console.error("Error getting orders:", error);
        return [];
    }
};
// Thêm một đơn hàng mới
export const addOrder = async (data) => {
    try {
        const docRef = await addDoc(ordersCollection, data);
        return docRef.id;
    } catch (error) {
        console.error("Error adding order:", error);
        return null;
    }
};

export const updateOrderStatus = async (id, status) => {
    try {
        const orderDoc = doc(db, "orders", id);
        await updateDoc(orderDoc, { status });
        return true;
    } catch (error) {
        console.error("Error updating order status:", error);
        return false;
    }
};


// Xóa đơn hàng theo id
export const deleteOrder = async (id) => {
    try {
        const orderDoc = doc(db, "orders", id);
        await deleteDoc(orderDoc);
    } catch (error) {
        console.error("Error deleting order:", error);
    }
};

export const countOrdersByStatus = async (status = null) => {
    try {
        let q;
        if (status) {
            q = query(collection(db, "orders"), where("status", "==", status));
        } else {
            q = collection(db, "orders");
        }

        const snapshot = await getCountFromServer(q);
        return snapshot.data().count;
    } catch (error) {
        console.error("Error counting orders:", error);
        return 0;
    }
};