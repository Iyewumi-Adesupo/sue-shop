// src/components/Cart.jsx
import React from "react";

function Cart({ cart = [], setCart }) {
  const removeFromCart = (id) => {
    setCart(cart.filter((item) => item.id !== id));
  };

  const updateQuantity = (id, quantity) => {
    if (quantity < 1) return;
    setCart(
      cart.map((item) =>
        item.id === id ? { ...item, quantity: parseInt(quantity) } : item
      )
    );
  };

  const total = cart.reduce(
    (sum, item) => sum + item.price * item.quantity,
    0
  );

  return (
    <div
      style={{
        marginTop: "2em",
        border: "1px solid #ddd",
        padding: "1rem",
        borderRadius: "6px",
        backgroundColor: "#fafafa",
        boxShadow: "0 2px 4px rgba(0,0,0,0.05)"
      }}
    >
      <h2>🛒 Cart</h2>

      {cart.length === 0 ? (
        <p>Your cart is empty.</p>
      ) : (
        <>
          <ul style={{ listStyle: "none", paddingLeft: 0 }}>
            {cart.map((item) => (
              <li key={item.id} style={{ marginBottom: "1rem" }}>
                {item.name} - £{item.price} ×{" "}
                <input
                  type="number"
                  min="1"
                  value={item.quantity}
                  onChange={(e) => updateQuantity(item.id, e.target.value)}
                  style={{
                    width: "60px",
                    padding: "0.3rem",
                    fontSize: "1rem",
                    marginLeft: "0.5rem"
                  }}
                />{" "}
                = £{item.price * item.quantity}
                <button
                  onClick={() => removeFromCart(item.id)}
                  style={{
                    marginLeft: "1rem",
                    padding: "0.3rem 0.6rem",
                    backgroundColor: "#e74c3c",
                    color: "white",
                    border: "none",
                    borderRadius: "4px",
                    cursor: "pointer"
                  }}
                >
                  ❌ Remove
                </button>
              </li>
            ))}
          </ul>

          <h3>Total: £{total}</h3>
        </>
      )}
    </div>
  );
}

export default Cart;