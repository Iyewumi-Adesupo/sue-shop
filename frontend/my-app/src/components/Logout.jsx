// src/components/Logout.jsx
import React from "react";

function Logout() {
  const handleLogout = () => {
    localStorage.removeItem("access");
    localStorage.removeItem("refresh");
    localStorage.removeItem("cart"); // optional
    window.dispatchEvent(new Event("logout"));
    window.location.reload();
  };

  return (
    <div
      style={{
        border: "1px solid #ddd",
        padding: "1rem",
        borderRadius: "6px",
        backgroundColor: "#fafafa",
        boxShadow: "0 2px 4px rgba(0,0,0,0.05)",
        minWidth: "100px",
        textAlign: "center",
      }}
    >
      <button
        onClick={handleLogout}
        style={{
          padding: "0.5rem 1rem",
          backgroundColor: "#e74c3c",
          color: "white",
          border: "none",
          borderRadius: "4px",
          cursor: "pointer",
          fontWeight: "bold",
        }}
      >
        🚪 Logout
      </button>
    </div>
  );
}

export default Logout;