// src/components/Orders.jsx
import React, { useEffect, useState } from "react";
import { fetchOrders } from "../api";
import Login from "./Login";

function Orders() {
  const [orders, setOrders] = useState([]);
  const [error, setError] = useState(null);
  const [loggedIn, setLoggedIn] = useState(false); // ✅ always start logged out

  async function loadOrders() {
    try {
      const data = await fetchOrders();
      setOrders(data);
      setError(null);
      setLoggedIn(true); // ✅ only switch to logged in if orders load
    } catch (err) {
      console.error("Error fetching orders:", err);
      setOrders([]);
      setError("❌ Please log in");
      setLoggedIn(false); // ✅ force login form
    }
  }

  useEffect(() => {
    // Try loading orders on mount
    loadOrders();

    // Refresh orders after successful login
    const handler = () => {
      loadOrders();
    };
    window.addEventListener("loginSuccess", handler);
    return () => window.removeEventListener("loginSuccess", handler);
  }, []);

  return (
    <div>
      <h2>🧾 Your Orders</h2>

      {!loggedIn ? (
        <>
          {error && <p style={{ color: "red" }}>{error}</p>}
          <Login /> {/* ✅ login box always appears here */}
        </>
      ) : (
        <>
          {orders.length === 0 ? (
            <p>No orders yet.</p>
          ) : (
            <ul>
              {orders.map((order) => (
                <li key={order.id}>
                  Order #{order.id} — Status: {order.status} — Total: £{order.total}
                </li>
              ))}
            </ul>
          )}
        </>
      )}
    </div>
  );
}

export default Orders;