// src/App.jsx
import React from "react";
import Register from "./components/Register";
import Login from "./components/Login";
import ProductsList from "./components/ProductsList";
import Cart from "./components/cart";
import Logout from "./components/Logout";

// ✅ import Toastify stuff
import { ToastContainer } from "react-toastify";
import "react-toastify/dist/ReactToastify.css";

function App() {
  return (
    <div style={{ padding: "2rem", fontFamily: "sans-serif" }}>
      <h1>Welcome to Sue Shop 🛍️</h1>

      {/* ✅ Login, Register, Logout */}
      <div
        style={{
          display: "flex",
          justifyContent: "flex-end",
          gap: "1rem",
          marginBottom: "1rem",
        }}
      >
        <Register />
        <Login />
        <Logout />
      </div>

      {/* ✅ Products + Cart in same row */}
      <div
        style={{
          display: "flex",
          flexWrap: "wrap",
          gap: "2rem",
          marginTop: "2rem",
        }}
      >
        {/* Products */}
        <div style={{ flex: 1, minWidth: "300px" }}>
          <ProductsList />
        </div>

        {/* Cart */}
        <div style={{ flex: 1, minWidth: "300px" }}>
          <Cart />
        </div>
      </div>

      {/* ✅ Toast container for notifications */}
      <ToastContainer position="top-right" autoClose={3000} />
    </div>
  );
}

export default App;