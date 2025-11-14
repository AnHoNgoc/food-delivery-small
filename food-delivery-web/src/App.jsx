import { BrowserRouter, Routes, Route } from "react-router-dom";
import Login from "./pages/Login";
import Register from "./pages/Register";
import ForgotPassword from "./pages/ForgotPassword";
import Dashboard from "./pages/Dashboard";
import Users from "./pages/Users";
import Orders from "./pages/Orders";
import ProtectedRoute from "./components/ProtectedRoute";
import Layout from "./components/Layout";
import { Toaster } from "react-hot-toast";
import Products from "./pages/Products";
import AddProduct from "./pages/AddProduct";
import ChangePassword from "./pages/ChangePassword";
import ProductDetail from "./pages/ProductDetail";

function App() {
  return (
    <BrowserRouter>
      <Toaster position="top-right" />

      <Routes>
        {/* Public pages */}
        <Route path="/" element={<Login />} />
        <Route path="/register" element={<Register />} />
        <Route path="/forgot-password" element={<ForgotPassword />} />

        {/* Protected pages với Layout */}
        <Route
          element={
            <ProtectedRoute>
              <Layout />
            </ProtectedRoute>
          }
        >
          <Route path="/dashboard" element={<Dashboard />} />
          <Route path="/products" element={<Products />} />
          <Route path="/add-product" element={<AddProduct />} />
          <Route path="/product/:id" element={<ProductDetail />} />
          <Route path="/orders" element={<Orders />} />
          <Route path="/users" element={<Users />} />
          <Route path="/change-password" element={<ChangePassword />} />
        </Route>
      </Routes>
    </BrowserRouter>
  );
}

export default App;

