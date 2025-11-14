import { useState, useEffect } from "react";
import { useNavigate } from "react-router-dom";
import { getProducts } from "../services/productService";
import { FaPlus } from "react-icons/fa";
import ReactPaginate from "react-paginate";

const categories = ["desserts", "drinks", "sides", "burgers", "salads"];
const PRODUCTS_PER_PAGE = 12;

export default function Products() {
    const [products, setProducts] = useState([]);
    const [selectedCategory, setSelectedCategory] = useState(null);
    const [loading, setLoading] = useState(true);
    const [currentPage, setCurrentPage] = useState(0);
    const navigate = useNavigate();

    useEffect(() => {
        const fetchProducts = async () => {
            try {
                const data = await getProducts();
                setProducts(data);
            } catch (err) {
                console.error("Failed to fetch products:", err);
            } finally {
                setLoading(false);
            }
        };
        fetchProducts();
    }, []);

    const handleAddProduct = () => {
        navigate("/add-product");
    };

    // Lọc sản phẩm theo category
    const filteredProducts = selectedCategory
        ? products.filter((p) => p.category === selectedCategory)
        : products;

    // Phân trang
    const pageCount = Math.ceil(filteredProducts.length / PRODUCTS_PER_PAGE);
    const offset = currentPage * PRODUCTS_PER_PAGE;
    const currentProducts = filteredProducts.slice(offset, offset + PRODUCTS_PER_PAGE);

    const handlePageClick = ({ selected }) => {
        setCurrentPage(selected);
    };

    if (loading) {
        return (
            <div className="flex justify-center items-center h-64">
                <div className="w-12 h-12 border-4 border-blue-500 border-dashed rounded-full animate-spin"></div>
            </div>
        );
    }

    return (
        <div className="flex flex-col min-h-screen dark:bg-gray-800">
            <div className="max-w-7xl mx-auto w-full p-6">
                {/* Header + Categories */}
                <div className="flex justify-between items-center mb-6">
                    <h1 className="text-2xl font-bold text-gray-800 dark:text-white">
                        Categories
                    </h1>
                    <div
                        role="button"
                        tabIndex={0}
                        className="flex items-center gap-2 text-white bg-green-500 hover:bg-green-600 px-4 py-2 rounded cursor-pointer transition"
                        onClick={handleAddProduct}
                        onKeyDown={(e) => e.key === "Enter" && handleAddProduct()}
                        aria-label="Add Product"
                    >
                        <span>Add Product</span>
                        <FaPlus size={14} />
                    </div>
                </div>
                <div className="flex flex-wrap gap-2 mb-4">
                    <button
                        onClick={() => setSelectedCategory(null)}
                        className="px-4 py-2 rounded-full bg-gray-300 dark:bg-gray-500 text-gray-800 dark:text-white"
                    >
                        All
                    </button>
                    {categories.map((cat) => (
                        <button
                            key={cat}
                            onClick={() => setSelectedCategory(cat)}
                            className={`px-4 py-2 rounded-full font-medium ${selectedCategory === cat
                                    ? "bg-blue-600 text-white"
                                    : "bg-gray-200 dark:bg-gray-600 text-gray-800 dark:text-white"
                                }`}
                        >
                            {cat}
                        </button>
                    ))}
                </div>

                {/* Products List */}
                <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4">
                    {currentProducts.map((product) => (
                        <div
                            key={product.id}
                            className="bg-white dark:bg-gray-700 rounded-lg shadow p-4 flex flex-col cursor-pointer"
                            onClick={() => navigate(`/product/${product.id}`)}
                        >
                            <img
                                src={product.imagePath}
                                alt={product.name}
                                className="w-full h-60 object-cover rounded mb-2"
                            />
                            <h3 className="font-semibold text-gray-800 dark:text-white">
                                {product.name}
                            </h3>
                            <p className="text-gray-600 dark:text-gray-300">{product.description}</p>
                            <p className="mt-2 font-bold text-gray-800 dark:text-white">
                                ${product.price}
                            </p>
                            {product.availableAddons && product.availableAddons.length > 0 && (
                                <div className="mt-2">
                                    <h4 className="font-medium text-gray-700 dark:text-gray-200">
                                        Add-ons:
                                    </h4>
                                    <ul className="text-gray-600 dark:text-gray-300 text-sm">
                                        {product.availableAddons.map((addon, index) => (
                                            <li key={index}>
                                                {addon.name} (+${addon.price})
                                            </li>
                                        ))}
                                    </ul>
                                </div>
                            )}
                        </div>
                    ))}
                </div>

                {/* Pagination */}
                {pageCount > 1 && (
                    <div className="flex justify-center mt-6">
                        <ReactPaginate
                            previousLabel={"<"} nextLabel={">"} breakLabel={"..."}
                            pageCount={pageCount} marginPagesDisplayed={2} pageRangeDisplayed={3}
                            onPageChange={handlePageClick}
                            containerClassName={"flex space-x-2"}
                            pageClassName={
                                "px-3 py-1 bg-white dark:bg-gray-700 rounded hover:bg-indigo-500 hover:text-white cursor-pointer text-gray-800 dark:text-gray-200"
                            }
                            activeClassName={"font-bold text-black"}
                            previousClassName={
                                "px-3 py-1 bg-white dark:bg-gray-700 rounded hover:bg-indigo-500 hover:text-white cursor-pointer text-gray-800 dark:text-gray-200"
                            }
                            nextClassName={
                                "px-3 py-1 bg-white dark:bg-gray-700 rounded hover:bg-indigo-500 hover:text-white cursor-pointer text-gray-800 dark:text-gray-200"
                            }
                            disabledClassName={"opacity-50 cursor-not-allowed"}
                        />
                    </div>
                )}
            </div>
        </div>
    );
}