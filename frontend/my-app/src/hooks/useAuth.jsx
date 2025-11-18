// src/hooks/useAuth.jsx

import { useContext } from "react";
import { AuthContext } from "../components/AuthContext";

export default function useAuth() {
  return useContext(AuthContext);
}

// useEffect(() => {
//   async function checkToken() {
//     if (getAccessToken()) {
//       setIsAuthenticated(true);
//     } else if (getRefreshToken()) {
//       try {
//         const newAccess = await refreshToken();
//         setToken(newAccess);
//         setIsAuthenticated(true);
//       } catch (err) {
//         console.error("Token refresh failed:", err);
//         clearTokens();
//         setIsAuthenticated(false);
//       }
//     } else {
//       setIsAuthenticated(false); // 🔑 force false if no tokens at all
//     }
//   }

//   checkToken();

//   // ✅ Listen for login success
//   const handler = () => {
//     const newToken = getAccessToken();
//     setToken(newToken);
//     setIsAuthenticated(!!newToken);
//   };

//   window.addEventListener("loginSuccess", handler);
//   return () => window.removeEventListener("loginSuccess", handler);
// }, []);