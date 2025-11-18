import React, { useState, useEffect } from "react";
import { BrowserRouter as Router, Routes, Route } from "react-router-dom";

import Home from "./components/Home";
import ProductsList from "./components/ProductsList";
import Cart from "./components/cart";
import Orders from "./components/Orders";
import CheckoutForm from "./components/CheckoutForm";
import ImageGallery from "./components/ImageGallery";
import Navbar from "./components/Navbar";
import AuthPage from "./components/AuthPage";
import Success from "./components/Success"; // ✅ Success page
import { AuthProvider } from "./components/AuthContext";

import useAuth from "./hooks/useAuth"; // ✅ already correct
import { ToastContainer } from "react-toastify";
import "react-toastify/dist/ReactToastify.css";

import { loadStripe } from "@stripe/stripe-js";
import { Elements } from "@stripe/react-stripe-js";

const stripePromise = loadStripe(import.meta.env.VITE_STRIPE_PUBLIC_KEY); // ✅ Load key from .env

function App() {
  const [cart, setCart] = useState(() => {
    try {
      const saved = localStorage.getItem("cart");
      return saved ? JSON.parse(saved) : [];
    } catch {
      return [];
    }
  });

  useEffect(() => {
    localStorage.setItem("cart", JSON.stringify(cart));
  }, [cart]);

  return (
    <AuthProvider>
      <Router>
        <Navbar /> {/* ✅ This is your main navigation bar */}

        <Routes>
          <Route path="/" element={<Home />} />
          <Route path="/home" element={<Home />} />
          <Route path="/login" element={<AuthPage />} />
          <Route path="/register" element={<AuthPage />} />
          <Route path="/products" element={<ProductsList cart={cart} setCart={setCart} />} />
          <Route path="/cart" element={<Cart cart={cart} setCart={setCart} />} />
          <Route path="/checkout" element={<CheckoutForm />} />
          <Route path="/orders" element={<Orders />} />
          <Route path="/images" element={<ImageGallery />} />
          <Route path="/success" element={<Success />} /> {/* ✅ Success page route */}
        </Routes>

        <ToastContainer position="top-right" autoClose={3000} />
      </Router>
    </AuthProvider>
  );
}

export default App;