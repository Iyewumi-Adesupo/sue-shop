// src/components/Navbar.jsx
import React, { useState } from "react";
import { Link, useNavigate } from "react-router-dom";
import UserMenu from "./UserMenu";
import useAuth from "../hooks/useAuth";
import "../styles/Navbar.css";
import { FaShoppingCart } from "react-icons/fa";

function Navbar() {
  const navigate = useNavigate();
  const { isAuthenticated, logout } = useAuth();
  const [searchTerm, setSearchTerm] = useState("");

  const handleSearch = (e) => {
    if (e.key === "Enter" && searchTerm.trim() !== "") {
      localStorage.setItem("search", searchTerm.trim());
      navigate("/products");
    }
  };

  return (
    <nav className="navbar">
      <Link to="/" className="logo">Sue Shop</Link>

      {/* 🔍 Search Input */}
      <input
        type="text"
        placeholder="Search products..."
        className="search"
        value={searchTerm}
        onChange={(e) => setSearchTerm(e.target.value)}
        onKeyDown={handleSearch}
      />

      {/* 🌐 Auth Links */}
      <div className="auth-links" style={{ display: "flex", gap: "1rem", alignItems: "center" }}>
        <Link to="/">Home</Link>
        <Link to="/products">Products</Link>
        <Link to="/orders">Orders</Link>
        <Link to="/cart" style={{ color: "#fff", textDecoration: "none" }}>
          Cart
        </Link>

        {!isAuthenticated ? (
          <>
            <Link to="/login"> Login</Link>
            <Link to="/register"> Register</Link>
          </>
        ) : (
          <span
            onClick={logout}
            style={{
              cursor: "pointer",
              color: "red",
              marginLeft: "2rem"
            }}
          >
            Logout
          </span>
        )}
      </div>

      {/* 👤 Optional dropdown menu */}
     {/* Icons removed to avoid duplication */}
    </nav>
  );
}

export default Navbar;