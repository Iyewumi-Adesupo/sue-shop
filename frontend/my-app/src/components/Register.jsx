// src/components/Register.jsx
import React, { useState } from "react";
import { registerUser } from "../api";

function Register() {
  const [username, setUsername] = useState("");
  const [password, setPassword] = useState("");
  const [message, setMessage] = useState("");

  const handleRegister = async (e) => {
    e.preventDefault();
    try {
      await registerUser({ username, password });
      setMessage("✅ Registration successful! You can now log in.");
      setUsername("");
      setPassword("");
    } catch (err) {
      console.error("Registration failed:", err);
      setMessage("❌ Registration failed. Try another username.");
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
      <h2>📝 Register</h2>
      <form
        onSubmit={handleRegister}
        style={{ display: "flex", flexDirection: "column", gap: "0.5rem" }}
      >
        <input
          type="text"
          id="reg-username"
          name="username"
          placeholder="Choose username"
          value={username}
          onChange={(e) => setUsername(e.target.value)}
          required
          style={{ padding: "0.5rem" }}
        />
        <input
          type="password"
          id="reg-password"
          name="password"
          placeholder="Choose password"
          value={password}
          onChange={(e) => setPassword(e.target.value)}
          required
          style={{ padding: "0.5rem" }}
        />
        <button
          type="submit"
          style={{
            padding: "0.5rem",
            backgroundColor: "#3498db",
            color: "white",
            border: "none",
            borderRadius: "4px",
            cursor: "pointer",
            fontWeight: "bold",
          }}
        >
          Register
        </button>
      </form>

      {message && (
        <p
          style={{
            marginTop: "0.5rem",
            color: message.startsWith("✅") ? "green" : "red",
          }}
        >
          {message}
        </p>
      )}
    </div>
  );
}

export default Register;