import { db } from "../firebase";
import { collection, getDocs, getDoc, addDoc, updateDoc, doc, deleteDoc, getCountFromServer } from "firebase/firestore";

// Collection "foods"
const productsCollection = collection(db, "foods");

// Lấy tất cả products
export const getProducts = async () => {
    try {
        const snapshot = await getDocs(productsCollection);
        return snapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));
    } catch (error) {
        console.error("Error getting products:", error);
        return [];
    }
};

// Lấy chi tiết product theo id
export const getProductDetail = async (id) => {
    try {
        const productDoc = doc(productsCollection, id);
        const snapshot = await getDoc(productDoc);
        if (snapshot.exists()) {
            return snapshot.data();
        } else {
            console.warn("No product found with id:", id);
            return null;
        }
    } catch (error) {
        console.error("Error getting product detail:", error);
        return null;
    }
};

// Thêm product mới
export const addProductLocal = async (data) => {
    try {
        const docRef = await addDoc(productsCollection, data);
        return docRef.id;
    } catch (error) {
        console.error("Error adding product:", error);
        return null;
    }
};

// Cập nhật product theo id
export const updateProduct = async (id, data) => {
    try {
        const productDoc = doc(productsCollection, id);
        await updateDoc(productDoc, data);
    } catch (error) {
        console.error("Error updating product:", error);
        throw error; // thêm throw để handle ở hàm gọi
    }
};

// Xóa product theo id
export const deleteProduct = async (id) => {
    try {
        const productDoc = doc(productsCollection, id);
        await deleteDoc(productDoc);
    } catch (error) {
        console.error("Error deleting product:", error);
        throw error; // thêm throw để handle ở hàm gọi
    }
};

export const countProducts = async () => {
    try {
        const snapshot = await getCountFromServer(productsCollection);
        return snapshot.data().count;
    } catch (error) {
        console.error("Error counting products:", error);
        return 0;
    }
};