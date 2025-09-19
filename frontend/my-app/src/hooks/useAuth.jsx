// src/hooks/useAuth.js
import { useEffect, useState } from "react";
import { getAccessToken, getRefreshToken, refreshToken, clearTokens } from "../api";

export function useAuth() {
  const [token, setToken] = useState(getAccessToken());
  const [isAuthenticated, setIsAuthenticated] = useState(!!token);

  // Try to refresh token on mount if access is missing/expired
  useEffect(() => {
    async function checkToken() {
      if (!getAccessToken() && getRefreshToken()) {
        try {
          const newAccess = await refreshToken();
          setToken(newAccess);
          setIsAuthenticated(true);
        } catch (err) {
          console.error("Token refresh failed:", err);
          clearTokens();
          setIsAuthenticated(false);
        }
      }
    }
    checkToken();
  }, []);

  // Logout function
  function logout() {
    clearTokens();
    setToken(null);
    setIsAuthenticated(false);
  }

  return { token, isAuthenticated, logout };
}