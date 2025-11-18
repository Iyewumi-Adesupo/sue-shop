import React, { useState, useEffect } from "react";
import { useNavigate } from "react-router-dom";
import { loginUser, registerUser } from "../api";
import useAuth from "../hooks/useAuth"; // ✅ correct
import "../styles/PageBackground.css"; // ✅ keep styling

function AuthPage() {
  const [username, setUsername] = useState("");
  const [password, setPassword] = useState("");
  const [confirmPassword, setConfirmPassword] = useState("");
  const [error, setError] = useState("");
  const [mode, setMode] = useState("login"); // 🔁 login | register
  const { isAuthenticated } = useAuth();
  const navigate = useNavigate();

  // 🛑 Redirect if already logged in
  useEffect(() => {
    if (isAuthenticated) {
      navigate("/products");
    }
  }, [isAuthenticated, navigate]);

  async function handleSubmit(e) {
    e.preventDefault();
    setError("");

    if (mode === "register" && password !== confirmPassword) {
      setError("❌ Passwords do not match.");
      return;
    }

    try {
      if (mode === "login") {
        await loginUser({ username, password });
      } else {
        await registerUser({ username, password });
        await loginUser({ username, password }); // Auto-login after registration
      }

      window.dispatchEvent(new Event("loginSuccess"));
      navigate("/products");
    } catch (err) {
      console.error("Auth error:", err);
      setError("❌ Authentication failed. Check your credentials.");
    }
  }

  return (
    <div
      className="page-background"
      style={{ backgroundImage: 'url("/images/bag-1-brown.jpg")' }}
    >
      <div
        style={{
          backgroundColor: "white",
          padding: "2rem",
          borderRadius: "8px",
          maxWidth: "400px",
          width: "90%",
          boxShadow: "0 4px 12px rgba(0,0,0,0.1)",
          textAlign: "center",
        }}
      >
        <h2>{mode === "login" ? "Sign In" : "Register"}</h2>
        <p style={{ fontSize: "0.9rem", color: "#666" }}>
          🔒 Your data is protected.
        </p>

        <div
          style={{
            display: "flex",
            justifyContent: "space-around",
            margin: "1rem 0",
            fontSize: "0.8rem",
          }}
        >
          <div>
            <p style={{ fontWeight: "bold" }}>SUE CLUB</p>
            <p>15× FREE Shopping Vouchers</p>
          </div>
          <div>
            <p style={{ fontWeight: "bold" }}>FREE SHIPPING</p>
            <p>First Order</p>
          </div>
        </div>

        {error && <p style={{ color: "red", marginBottom: "1rem" }}>{error}</p>}

        {/* ✅ Username/Email */}
        <input
          type="text"
          id="username"
          name="username"
          placeholder="Mobile number or email address"
          value={username}
          onChange={(e) => setUsername(e.target.value)}
          style={{
            padding: "0.7rem",
            width: "100%",
            marginBottom: "1rem",
            border: "1px solid #ccc",
            borderRadius: "4px",
            fontSize: "1rem",
          }}
        />

        {/* ✅ Password */}
        <input
          type="password"
          id="password"
          name="password"
          placeholder="Password"
          value={password}
          onChange={(e) => setPassword(e.target.value)}
          style={{
            padding: "0.7rem",
            width: "100%",
            marginBottom: "1rem",
            border: "1px solid #ccc",
            borderRadius: "4px",
            fontSize: "1rem",
          }}
        />

        {/* ✅ Confirm Password for Register */}
        {mode === "register" && (
          <input
            type="password"
            id="confirmPassword"
            name="confirmPassword"
            placeholder="Confirm Password"
            value={confirmPassword}
            onChange={(e) => setConfirmPassword(e.target.value)}
            style={{
              padding: "0.7rem",
              width: "100%",
              marginBottom: "1rem",
              border: "1px solid #ccc",
              borderRadius: "4px",
              fontSize: "1rem",
            }}
          />
        )}

        {/* ✅ Submit button */}
        <button
          onClick={handleSubmit}
          style={{
            width: "100%",
            padding: "0.7rem",
            backgroundColor: "#333",
            color: "white",
            border: "none",
            borderRadius: "4px",
            fontWeight: "bold",
            fontSize: "1rem",
            marginBottom: "1rem",
          }}
        >
          {mode === "login" ? "CONTINUE" : "REGISTER"}
        </button>

        {/* 🔁 Switch between login/register */}
        <p style={{ fontSize: "0.85rem", color: "#444" }}>
          {mode === "login" ? "Don't have an account?" : "Already have an account?"}{" "}
          <span
            onClick={() => {
              setMode(mode === "login" ? "register" : "login");
              setError("");
            }}
            style={{
              color: "#007bff",
              cursor: "pointer",
              fontWeight: "bold",
            }}
          >
            {mode === "login" ? "Register here" : "Sign in"}
          </span>
        </p>

        {/* Social buttons remain the same */}
        <p style={{ margin: "1rem 0", color: "#888" }}>Or</p>

        <button
          style={{
            width: "100%",
            padding: "0.7rem",
            backgroundColor: "white",
            color: "#444",
            border: "1px solid #ccc",
            borderRadius: "4px",
            fontSize: "1rem",
            marginBottom: "0.5rem",
          }}
        >
          <span role="img" aria-label="Google">
            🌐
          </span>{" "}
          Continue with Google
        </button>

        <button
          style={{
            width: "100%",
            padding: "0.7rem",
            backgroundColor: "white",
            color: "#444",
            border: "1px solid #ccc",
            borderRadius: "4px",
            fontSize: "1rem",
            marginBottom: "1rem",
          }}
        >
          <span role="img" aria-label="Facebook">
            📘
          </span>{" "}
          Continue with Facebook
        </button>

        <p style={{ fontSize: "0.8rem", color: "#666" }}>🇬🇧 United Kingdom</p>

        <p style={{ fontSize: "0.7rem", color: "#aaa", marginTop: "1rem" }}>
          By continuing, you agree to our Privacy & Cookie Policy and Terms & Conditions.
        </p>
      </div>
    </div>
  );
}

export default AuthPage;