import { db } from "../firebase";
import { collection, getDocs, addDoc, updateDoc, doc, getCountFromServer } from "firebase/firestore";
import { functions, httpsCallable } from "../firebase";
const usersCollection = collection(db, "users");

export const getUsers = async () => {
    try {
        const snapshot = await getDocs(usersCollection);
        return snapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));
    } catch (error) {
        console.error("Error getting users:", error);
        return [];
    }
};

export const addUser = async (data) => {
    try {
        const docRef = await addDoc(usersCollection, data);
        return docRef.id;
    } catch (error) {
        console.error("Error adding user:", error);
        return null;
    }
};

export const updateUser = async (id, data) => {
    try {
        const userDoc = doc(db, "users", id);
        await updateDoc(userDoc, data);
    } catch (error) {
        console.error("Error updating user:", error);
    }
};

export const deleteUserFull = async (uid) => {
    try {

        const deleteUser = httpsCallable(functions, "deleteUser");
        const result = await deleteUser({ uid });
        return result.data;
    } catch (error) {
        console.error("Failed to delete user via Cloud Function:", error);
        return null;
    }
};

export const countUsers = async () => {
    try {
        const snapshot = await getCountFromServer(usersCollection);
        return snapshot.data().count;
    } catch (error) {
        console.error("Error counting users:", error);
        return 0;
    }
};