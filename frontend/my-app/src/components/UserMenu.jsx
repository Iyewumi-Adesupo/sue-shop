import React, { useState } from "react";
import { useNavigate } from "react-router-dom";

function UserMenu() {
  const [showMenu, setShowMenu] = useState(false);
  const navigate = useNavigate();

  const toggleMenu = () => setShowMenu(!showMenu);

  return (
    <div style={{ position: "relative" }}>
      <span
        style={{ cursor: "pointer", fontSize: "1.5rem" }}
        onClick={toggleMenu}
      >
        👤
      </span>
      {showMenu && (
        <div
          style={{
            position: "absolute",
            right: 0,
            top: "2.5rem",
            backgroundColor: "#fff",
            border: "1px solid #ccc",
            borderRadius: "6px",
            padding: "1rem",
            zIndex: 1000,
          }}
        >
          <p onClick={() => navigate("/")}>🏠 Home</p>
          <p onClick={() => navigate("/products")}>👜 Products</p>
          <p onClick={() => navigate("/cart")}>🛒 Cart</p>
          <p onClick={() => navigate("/orders")}>📦 Orders</p>
          <p onClick={() => navigate("/login")}>🔐 Login</p>
          <p onClick={() => navigate("/register")}>📝 Register</p>
        </div>
      )}
    </div>
  );
}

export default UserMenu;