import { useState } from "react";
import { getStorage, ref, uploadBytes, getDownloadURL } from "firebase/storage";
import { useNavigate } from "react-router-dom";
import { app } from "../firebase";
import { addProductLocal } from "../services/productService";
import toast from "react-hot-toast";

const categories = ["desserts", "drinks", "sides", "burgers", "salads"];

export default function AddProduct() {

    const [name, setName] = useState("");
    const [price, setPrice] = useState("");
    const [description, setDescription] = useState("");
    const [imageFile, setImageFile] = useState(null);
    const [imagePath, setImagePath] = useState("");
    const [category, setCategory] = useState(categories[0]);
    const [availableAddons, setAvailableAddons] = useState([]);
    const navigate = useNavigate();

    const [addonName, setAddonName] = useState("");
    const [addonPrice, setAddonPrice] = useState("");
    const [isLoading, setIsLoading] = useState(false);

    const handleAddAddon = () => {
        if (!addonName || !addonPrice) return;
        setAvailableAddons([
            ...availableAddons,
            { name: addonName, price: parseFloat(addonPrice) },
        ]);
        setAddonName("");
        setAddonPrice("");
    };

    const handleRemoveAddon = (index) => {
        const newAddons = [...availableAddons];
        newAddons.splice(index, 1);
        setAvailableAddons(newAddons);
    };

    const handleImageChange = (e) => {
        if (e.target.files[0]) {
            setImageFile(e.target.files[0]);
        }
    };

    const uploadImage = async () => {
        if (!imageFile) return null;

        try {
            const storage = getStorage(app);
            const storageRef = ref(storage, `products/${Date.now()}_${imageFile.name}`);

            await uploadBytes(storageRef, imageFile);
            const url = await getDownloadURL(storageRef);

            setImagePath(url);
            return url;
        } catch (error) {
            console.error("Upload error:", error);
            toast.error("Something went wrong while uploading image!", {
                style: { background: "#EF4444", color: "#fff" },
            });
            return null;
        }
    }

    const handleSubmit = async (e) => {
        e.preventDefault();
        setIsLoading(true);
        try {
            const uploadedImageUrl = await uploadImage();

            const product = {
                name,
                price: parseFloat(price),
                description,
                imagePath: uploadedImageUrl || imagePath,
                category,
                availableAddons,
            };

            const productId = await addProductLocal(product);

            if (productId) {
                toast.success("Add Product Successfully!", {
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
                navigate("/products");

                // Reset form
                setName("");
                setPrice("");
                setDescription("");
                setImagePath("");
                setCategory(categories[0]);
                setAvailableAddons([]);
            } else {
                toast.error("Failed to add product.", {
                    style: { background: "#EF4444", color: "#fff" },
                });
            }
        } catch (error) {
            console.error("Submit error:", error);
            toast.error("Something went wrong!", {
                style: { background: "#EF4444", color: "#fff" },
            });
        } finally {
            setIsLoading(false); // Kết thúc loading
        }
    };

    return (
        <div className="max-w-3xl mx-auto p-6 bg-white dark:bg-gray-800 rounded shadow-md">
            <h1 className="text-2xl font-bold mb-6 text-gray-800 dark:text-white">
                Add Product
            </h1>

            <form onSubmit={handleSubmit} className="space-y-5">
                {/* Name */}
                <div className="flex flex-col">
                    <label className="mb-1 text-gray-700 dark:text-gray-200 font-medium">Name</label>
                    <input
                        type="text"
                        value={name}
                        onChange={(e) => setName(e.target.value)}
                        placeholder="Enter product name"
                        className="w-full px-4 py-2 border border-gray-300 rounded-lg shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-400 dark:bg-gray-700 dark:border-gray-600 dark:text-white"
                        required
                    />
                </div>

                {/* Price */}
                <div className="flex flex-col">
                    <label className="mb-1 text-gray-700 dark:text-gray-200 font-medium">Price ($)</label>
                    <input
                        type="number"
                        step="0.01"
                        value={price}
                        onChange={(e) => setPrice(e.target.value)}
                        placeholder="0.00"
                        className="w-full px-4 py-2 border border-gray-300 rounded-lg shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-400 dark:bg-gray-700 dark:border-gray-600 dark:text-white"
                        required
                    />
                </div>

                {/* Description */}
                <div className="flex flex-col">
                    <label className="mb-1 text-gray-700 dark:text-gray-200 font-medium">Description</label>
                    <textarea
                        value={description}
                        onChange={(e) => setDescription(e.target.value)}
                        placeholder="Enter product description"
                        rows={3}
                        className="w-full px-4 py-2 border border-gray-300 rounded-lg shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-400 dark:bg-gray-700 dark:border-gray-600 dark:text-white"
                    />
                </div>

                {/* Image */}
                <div className="flex flex-col">
                    <label className="mb-1 text-gray-700 dark:text-gray-200 font-medium">Image</label>
                    <input
                        type="file"
                        accept="image/*"
                        onChange={handleImageChange}
                        className="text-gray-700 dark:text-gray-200"
                    />
                    {imageFile && (
                        <p className="text-sm mt-1 text-gray-500 dark:text-gray-300">{imageFile.name}</p>
                    )}
                </div>

                {/* Category */}
                <div className="flex flex-col">
                    <label className="mb-1 text-gray-700 dark:text-gray-200 font-medium">Category</label>
                    <select
                        value={category}
                        onChange={(e) => setCategory(e.target.value)}
                        className="w-full px-4 py-2 border border-gray-300 rounded-lg shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-400 dark:bg-gray-700 dark:border-gray-600 dark:text-white"
                    >
                        {categories.map((cat) => (
                            <option key={cat} value={cat}>
                                {cat.charAt(0).toUpperCase() + cat.slice(1)}
                            </option>
                        ))}
                    </select>
                </div>

                {/* Addons */}
                <div className="border-t pt-4">
                    <h2 className="text-lg font-semibold mb-2 text-gray-800 dark:text-white">Available Addons</h2>
                    <div className="flex gap-2 mb-2">
                        <input
                            type="text"
                            placeholder="Addon name"
                            value={addonName}
                            onChange={(e) => setAddonName(e.target.value)}
                            className="flex-1 px-3 py-2 border rounded-lg dark:bg-gray-700 dark:text-white"
                        />
                        <input
                            type="number"
                            step="0.01"
                            placeholder="Price"
                            value={addonPrice}
                            onChange={(e) => setAddonPrice(e.target.value)}
                            className="w-24 px-3 py-2 border rounded-lg dark:bg-gray-700 dark:text-white"
                        />
                        <button
                            type="button"
                            onClick={handleAddAddon}
                            className="px-4 py-2 bg-green-500 text-white rounded-lg hover:bg-green-600 transition"
                        >
                            Add
                        </button>
                    </div>
                    <ul className="space-y-1">
                        {availableAddons.map((addon, idx) => (
                            <li key={idx} className="flex justify-between items-center bg-gray-100 dark:bg-gray-700 px-3 py-1 rounded-lg">
                                <span>{addon.name} - ${addon.price.toFixed(2)}</span>
                                <button
                                    type="button"
                                    onClick={() => handleRemoveAddon(idx)}
                                    className="text-red-500 hover:text-red-700"
                                >
                                    Remove
                                </button>
                            </li>
                        ))}
                    </ul>
                </div>

                {/* Submit */}
                <button
                    type="submit"
                    disabled={isLoading}
                    className={`w-full px-6 py-3 rounded-lg font-medium transition ${isLoading
                        ? "bg-blue-300 cursor-not-allowed text-white"
                        : "bg-blue-500 hover:bg-blue-600 text-white"
                        }`}
                >
                    {isLoading ? "Adding..." : "Add Product"}
                </button>
            </form>
        </div>
    );
}