// src/components/Login.jsx
import React, { useState } from "react";
import { loginUser, saveTokens } from "../api";
import { toast } from "react-toastify"; // ✅ Import toast

function Login() {
  const [username, setUsername] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState("");

  const handleLogin = async (e) => {
    e.preventDefault();
    try {
      const data = await loginUser({ username, password });
      saveTokens(data);

      window.dispatchEvent(new Event("loginSuccess"));

      toast.success("✅ Login successful!"); // ✅ Show toast
      setError("");
      setUsername("");
      setPassword("");
    } catch (err) {
      console.error("Login failed:", err);
      toast.error("❌ Invalid username or password."); // ✅ Show error toast
    }
  };

  return (
    <div
      style={{
        border: "1px solid #ddd",
        padding: "1rem",
        borderRadius: "6px",
        backgroundColor: "#fafafa",
        boxShadow: "0 2px 4px rgba(0,0,0,0.05)",
        minWidth: "250px",
      }}
    >
      <h2>🔐 Login</h2>
      <form onSubmit={handleLogin} style={{ display: "flex", flexDirection: "column", gap: "0.5rem" }}>
        <input
          type="text"
          id="login-username"
          name="username"
          placeholder="Enter username"
          value={username}
          onChange={(e) => setUsername(e.target.value)}
          required
          style={{ padding: "0.5rem" }}
        />
        <input
          type="password"
          id="login-password"
          name="password"
          placeholder="Enter password"
          value={password}
          onChange={(e) => setPassword(e.target.value)}
          required
          style={{ padding: "0.5rem" }}
        />
        <button
          type="submit"
          style={{
            padding: "0.5rem",
            backgroundColor: "#2ecc71",
            color: "white",
            border: "none",
            borderRadius: "4px",
            cursor: "pointer",
            fontWeight: "bold",
          }}
        >
          Login
        </button>
      </form>
    </div>
  );
}

export default Login;