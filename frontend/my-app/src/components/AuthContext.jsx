// src/context/AuthContext.jsx
import React, { createContext, useState, useEffect } from "react";

export const AuthContext = createContext();

export function AuthProvider({ children }) {
  const [isAuthenticated, setIsAuthenticated] = useState(
    !!localStorage.getItem("access") // or however you check auth
  );

  const login = () => setIsAuthenticated(true);

  const logout = () => {
    setIsAuthenticated(false);
    localStorage.removeItem("access");
    localStorage.removeItem("refresh"); // optional cleanup
  };

  useEffect(() => {
    // ✅ Check token on load
    const accessToken = localStorage.getItem("access");
    setIsAuthenticated(!!accessToken);

    // ✅ Listen for loginSuccess event
    const handler = () => {
      const newToken = localStorage.getItem("access");
      setIsAuthenticated(!!newToken);
    };

    window.addEventListener("loginSuccess", handler);
    return () => window.removeEventListener("loginSuccess", handler);
  }, []);

  return (
    <AuthContext.Provider value={{ isAuthenticated, login, logout }}>
      {children}
    </AuthContext.Provider>
  );
}