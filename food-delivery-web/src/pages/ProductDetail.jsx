import { useEffect, useState } from "react";
import { useParams, useNavigate } from "react-router-dom";
import { getProductDetail, updateProduct, deleteProduct } from "../services/productService";
import toast from "react-hot-toast";
import { FaTrashAlt, FaPen } from "react-icons/fa";
import CustomModal from "../components/CustomModal";
import { getStorage, ref, uploadBytes, getDownloadURL } from "firebase/storage";
import { app } from "../firebase";

const categories = ["desserts", "drinks", "sides", "burgers", "salads"];

export default function ProductDetail() {

    const { id } = useParams();
    const navigate = useNavigate();

    const [product, setProduct] = useState(null);
    const [loading, setLoading] = useState(true);
    const [isEditing, setIsEditing] = useState(false);
    const [isSaving, setIsSaving] = useState(false);
    const [showDeleteModal, setShowDeleteModal] = useState(false);

    const [name, setName] = useState("");
    const [price, setPrice] = useState("");
    const [description, setDescription] = useState("");
    const [imageFile, setImageFile] = useState(null);
    const [imagePath, setImagePath] = useState("");
    const [category, setCategory] = useState(categories[0]);
    const [availableAddons, setAvailableAddons] = useState([]);
    const [addonName, setAddonName] = useState("");
    const [addonPrice, setAddonPrice] = useState("");

    useEffect(() => {
        const fetchProduct = async () => {
            try {
                const data = await getProductDetail(id);
                if (!data) {
                    toast.error("Product not found");
                    return;
                }
                setProduct(data);
                setName(data.name || "");
                setPrice(data.price || "");
                setDescription(data.description || "");
                setImagePath(data.imagePath || "");
                setCategory(data.category || categories[0]);
                setAvailableAddons(data.availableAddons || []);
            } catch (error) {
                console.error(error);
                toast.error("Failed to load product");
            } finally {
                setLoading(false);
            }
        };
        fetchProduct();
    }, [id]);

    const handleImageChange = (e) => {
        const file = e.target.files[0];
        if (file) {
            setImageFile(file);
            // Tạo preview ngay lập tức
            const previewUrl = URL.createObjectURL(file);
            setImagePath(previewUrl);
        }
    };

    const handleAddAddon = () => {
        if (!addonName || !addonPrice) return;
        setAvailableAddons((prev) => [...prev, { name: addonName, price: parseFloat(addonPrice) }]);
        setAddonName("");
        setAddonPrice("");
    };

    const handleRemoveAddon = (idx) => {
        setAvailableAddons((prev) => prev.filter((_, index) => index !== idx));
    };

    const uploadImage = async () => {
        if (!imageFile) return imagePath;

        try {
            const storage = getStorage(app);
            const storageRef = ref(storage, `products/${Date.now()}_${imageFile.name}`);

            await uploadBytes(storageRef, imageFile);
            const url = await getDownloadURL(storageRef);

            setImagePath(url);
            return url;

        } catch (error) {
            console.error("Upload image error:", error);
            toast.error("Failed to upload image");
            return null; // trả về null nếu upload thất bại
        }
    };

    const handleSave = async () => {
        setIsSaving(true);
        try {
            const uploadedImageUrl = await uploadImage();
            if (imageFile && !uploadedImageUrl) {
                throw new Error("Image upload failed");
            }
            const updatedProduct = {
                name,
                price: parseFloat(price),
                description,
                imagePath: uploadedImageUrl,
                category,
                availableAddons,
            };
            await updateProduct(id, updatedProduct);
            toast.success("Product updated!", { icon: "✅" });
            setProduct(updatedProduct);
            setIsEditing(false);
        } catch (error) {
            console.error(error);
            toast.error("Failed to update product");
        } finally {
            setIsSaving(false);
        }
    };

    const handleDelete = async () => {
        try {
            await deleteProduct(id);
            toast.success("Product deleted!", { icon: "🗑️" });
            navigate("/products");
        } catch (error) {
            console.error(error);
            toast.error("Failed to delete product");
        }
    };

    if (loading) return <p className="text-center mt-10">Loading...</p>;

    return (
        <div className="max-w-3xl mx-auto p-6 bg-white dark:bg-gray-800 rounded shadow-md relative">

            {/* Image */}
            <div className="mb-4 relative">
                {/* Edit/Delete icons */}
                <div className="absolute top-4 right-4 flex gap-4 z-10">
                    <FaPen
                        onClick={() => setIsEditing((prev) => !prev)}
                        className="text-yellow-400 hover:text-yellow-500 cursor-pointer transition"
                        size={20}
                    />
                    <FaTrashAlt
                        onClick={() => setShowDeleteModal(true)}
                        className="text-red-500 hover:text-red-600 cursor-pointer transition"
                        size={20}
                    />
                </div>

                {/* Image */}
                <img
                    src={imagePath}
                    alt={name}
                    className="w-full h-96 object-cover rounded mb-2"
                />

                {/* Input file + Remove button */}
                {isEditing && (
                    <div className="flex items-center gap-2 mt-2">
                        <input
                            type="file"
                            accept="image/*"
                            onChange={handleImageChange}
                            className="text-gray-700 dark:text-gray-200"
                        />
                        {imageFile && (
                            <button
                                type="button"
                                onClick={() => {
                                    setImageFile(null);
                                    setImagePath(product.imagePath);
                                }}
                                className="px-3 py-1 bg-red-500 text-white rounded hover:bg-red-600 transition"
                            >
                                Remove
                            </button>
                        )}
                    </div>
                )}
            </div>

            {/* Form fields */}
            <InputField label="Name" value={name} setValue={setName} disabled={!isEditing} />
            <InputField label="Price ($)" type="number" value={price} setValue={setPrice} disabled={!isEditing} />
            <TextareaField label="Description" value={description} setValue={setDescription} disabled={!isEditing} />
            <div className="flex flex-col mb-4">
                <label className="mb-1 font-medium text-gray-700 dark:text-gray-200">Category</label>
                <select value={category} onChange={(e) => setCategory(e.target.value)}
                    disabled={!isEditing}
                    className="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-blue-400 dark:bg-gray-700 dark:text-white">
                    {categories.map((cat) => <option key={cat} value={cat}>{cat}</option>)}
                </select>
            </div>

            {/* Addons */}
            <div className="border-t pt-4 mb-4">
                <h2 className="text-lg font-semibold mb-2 text-gray-800 dark:text-white">Available Addons</h2>
                {isEditing && (
                    <div className="flex flex-wrap gap-2 mb-2">
                        <input type="text" placeholder="Addon name" value={addonName} onChange={(e) => setAddonName(e.target.value)}
                            className="flex-1 px-3 py-2 border rounded-lg dark:bg-gray-700 dark:text-white" />
                        <input type="number" step="0.01" placeholder="Price" value={addonPrice} onChange={(e) => setAddonPrice(e.target.value)}
                            className="w-24 px-3 py-2 border rounded-lg dark:bg-gray-700 dark:text-white" />
                        <button type="button" onClick={handleAddAddon} className="px-4 py-2 bg-green-500 text-white rounded-lg hover:bg-green-600 transition">Add</button>
                    </div>
                )}
                <ul className="space-y-1">
                    {availableAddons.map((addon, idx) => (
                        <li key={idx} className="flex justify-between items-center bg-gray-100 dark:bg-gray-700 px-3 py-1 rounded-lg">
                            <span>{addon.name} - ${addon.price.toFixed(2)}</span>
                            {isEditing && (
                                <button type="button" onClick={() => handleRemoveAddon(idx)}
                                    className="text-red-500 hover:text-red-700 transition">Remove</button>
                            )}
                        </li>
                    ))}
                </ul>
            </div>

            {isEditing && (
                <button onClick={handleSave} disabled={isSaving}
                    className={`w-full px-6 py-3 rounded-lg font-medium transition ${isSaving ? "bg-blue-300 cursor-not-allowed" : "bg-blue-500 hover:bg-blue-600 text-white"}`}>
                    {isSaving ? "Saving..." : "Save Changes"}
                </button>
            )}

            {/* Delete Modal */}
            <CustomModal open={showDeleteModal} title="Delete Product?" confirmText="Delete" cancelText="Cancel"
                onConfirm={handleDelete} onClose={() => setShowDeleteModal(false)}>
                Are you sure you want to delete this product?
            </CustomModal>
        </div>
    );
}

// ---------- Input components ----------
function InputField({ label, value, setValue, type = "text", disabled = false }) {
    return (
        <div className="flex flex-col mb-4">
            <label className="mb-1 font-medium text-gray-700 dark:text-gray-200">{label}</label>
            <input type={type} value={value} onChange={(e) => setValue(e.target.value)}
                disabled={disabled}
                className={`w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-blue-400 dark:bg-gray-700 dark:text-white ${disabled ? "bg-gray-200 dark:bg-gray-600 cursor-not-allowed" : ""}`} />
        </div>
    );
}

function TextareaField({ label, value, setValue, rows = 3, disabled = false }) {
    return (
        <div className="flex flex-col mb-4">
            <label className="mb-1 font-medium text-gray-700 dark:text-gray-200">{label}</label>
            <textarea value={value} onChange={(e) => setValue(e.target.value)} rows={rows}
                disabled={disabled}
                className={`w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-blue-400 dark:bg-gray-700 dark:text-white ${disabled ? "bg-gray-200 dark:bg-gray-600 cursor-not-allowed" : ""}`} />
        </div>
    );
}