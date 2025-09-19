// src/api.jsx

const API_BASE = import.meta.env.VITE_API_BASE_URL || "http://localhost:8000/api";

// ------------------- PRODUCTS -------------------
export async function fetchProducts() {
  const response = await fetch(`${API_BASE}/products/`);
  if (!response.ok) {
    throw new Error(`Failed to fetch products: ${response.status}`);
  }
  return response.json();
}

// ------------------- TOKEN STORAGE -------------------
export function saveTokens({ access, refresh }) {
  localStorage.setItem("access", access);
  if (refresh) localStorage.setItem("refresh", refresh);
}

export function getAccessToken() {
  return localStorage.getItem("access");
}

export function getRefreshToken() {
  return localStorage.getItem("refresh");
}

export function clearTokens() {
  localStorage.removeItem("access");
  localStorage.removeItem("refresh");
}

// ------------------- AUTH -------------------
export async function loginUser({ username, password }) {
  const res = await fetch(`${API_BASE}/token/`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ username, password }),
  });

  if (!res.ok) throw new Error("Login failed");

  const data = await res.json(); // { access, refresh }
  saveTokens(data);
  return data;
}

export async function registerUser(data) {
  const res = await fetch(`${API_BASE}/auth/register/`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(data),
  });

  if (!res.ok) throw new Error("Registration failed");

  return res.json();
}

export async function refreshToken() {
  const refresh = getRefreshToken();
  if (!refresh) throw new Error("No refresh token available");

  const res = await fetch(`${API_BASE}/token/refresh/`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ refresh }),
  });

  if (!res.ok) {
    clearTokens();
    throw new Error("Token refresh failed");
  }

  const data = await res.json(); // { access }
  saveTokens({ access: data.access, refresh });
  return data.access;
}

// ------------------- FETCH WITH AUTH -------------------
async function authFetch(path, options = {}) {
  let token = getAccessToken();

  options.headers = {
    ...(options.headers || {}),
    Authorization: token ? `Bearer ${token}` : "",
  };

  let res = await fetch(`${API_BASE}${path}`, options);

  if (res.status === 401 && getRefreshToken()) {
    try {
      token = await refreshToken();
      options.headers.Authorization = `Bearer ${token}`;
      res = await fetch(`${API_BASE}${path}`, options); // retry
    } catch {
      clearTokens();
      throw new Error("Session expired, please log in again.");
    }
  }

  if (!res.ok) throw new Error(`Request failed: ${res.status}`);

  return res.json();
}

// ---------------- ORDERS ----------------
export async function fetchOrders() {
  const access = localStorage.getItem("access"); // ✅ same key
  if (!access) throw new Error("Not authenticated");

  const r = await fetch(`${API_BASE}/orders/`, {
    headers: {
      "Authorization": `Bearer ${access}`,
      "Content-Type": "application/json",
    },
  });

  if (r.status === 401) throw new Error("Please log in");
  if (!r.ok) throw new Error(`Orders failed: ${r.status}`);
  return r.json();
}

export async function placeOrder(productId, quantity = 1) {
  const access = localStorage.getItem("access");
  if (!access) throw new Error("Not authenticated");

  const r = await fetch(`${API_BASE}/orders/`, {
    method: "POST",
    headers: {
      "Authorization": `Bearer ${access}`,
      "Content-Type": "application/json",
    },
    // ✅ DRF OrderViewSet expects "product" (the ID) and "quantity"
    body: JSON.stringify({ product: productId, quantity: quantity }),
  });

  if (r.status === 401) throw new Error("Please log in");
  if (r.status === 405) throw new Error("Method Not Allowed – check backend OrderViewSet POST support");
  if (!r.ok) throw new Error(`Order failed: ${r.status}`);
  return r.json();
}