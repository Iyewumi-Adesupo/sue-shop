// src/components/Orders.jsx
import React, { useEffect, useState } from "react";
import { fetchOrders } from "../api";
import Login from "./Login";

function Orders() {
  const [orders, setOrders] = useState([]);
  const [error, setError] = useState(null);
  const [loggedIn, setLoggedIn] = useState(false); // ✅ start false

  async function loadOrders() {
    try {
      const data = await fetchOrders(); // ✅ should support guest orders
      setOrders(data);
      setError(null);
      setLoggedIn(true); // ✅ show orders list
    } catch (err) {
      console.error("Error fetching orders:", err);
      setOrders([]);
      setError("⚠️ Could not fetch your orders. You can still order as a guest.");
      setLoggedIn(false); // ✅ allow showing guest prompt or login
    }
  }

  useEffect(() => {
    loadOrders();

    // ✅ Refresh if user logs in later
    const handler = () => loadOrders();
    window.addEventListener("loginSuccess", handler);
    return () => window.removeEventListener("loginSuccess", handler);
  }, []);

  return (
    <div style={{ padding: "2rem" }}>
      <h2>📦 Your Orders</h2>

      {!loggedIn ? (
        <>
          {error && <p style={{ color: "orange", marginBottom: "1rem" }}>{error}</p>}

          <Login />

          <p style={{ fontSize: "0.85rem", color: "#555", marginTop: "1rem" }}>
            👤 Don't worry, you can still browse and place orders as a guest — but viewing order history requires login.
          </p>
        </>
      ) : (
        <>
          {orders.length === 0 ? (
            <p style={{ fontSize: "0.95rem", color: "#444" }}>
              🛒 You have no previous orders. Visit the <strong>Products</strong> page to start shopping.
            </p>
          ) : (
            <ul>
              {orders.map((order) => (
                <li key={order.id}>
                  🧾 Order #{order.id} — Status: {order.status} — Total: £{order.total}
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