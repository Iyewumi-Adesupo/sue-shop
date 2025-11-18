// src/components/cart.jsx
import React from "react";
import { useNavigate } from "react-router-dom";
import { loadStripe } from "@stripe/stripe-js"; // ✅ Stripe import

const stripePromise = loadStripe(import.meta.env.VITE_STRIPE_PUBLIC_KEY); 
// make sure you have VITE_STRIPE_PUBLIC_KEY in your .env file

function Cart({ cart, setCart }) {
  const navigate = useNavigate();
  
  // Remove item from cart
  const removeFromCart = (productId) => {
    setCart(cart.filter((item) => item.id !== productId));
  };

  const updateQuantity = (productId, newQty) => {
    if (newQty <= 0) return;
    setCart(
      cart.map((item) =>
        item.id === productId ? { ...item, quantity: newQty } : item
      )
    );
  };

  const total = cart.reduce((sum, item) => {
    const price = Number(item.price);
    return sum + (isNaN(price) ? 0 : price * item.quantity);
  }, 0);

  // ✅ Stripe Checkout Function (fixed: removed navigate("/checkout"))
  async function handleCheckout() {
    try {
      const response = await fetch("http://localhost:8000/api/create-checkout-session/", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          items: cart.map((item) => ({
            price_data: {
              currency: "gbp",
              product_data: { name: item.name },
              unit_amount: item.price * 100, // Stripe expects amounts in pence
            },
            quantity: item.quantity,
          })),
        }),
      });

      if (!response.ok) {
        throw new Error("Failed to create checkout session");
      }

      const data = await response.json();
      const stripe = await stripePromise;

      const result = await stripe.redirectToCheckout({
        sessionId: session.id,
      });

      if (result.error) {
        alert(result.error.message);
      }
    } catch (err) {
      console.error("Checkout error:", err);
      alert("Something went wrong with checkout.");
    }
  }

  if (!cart || cart.length === 0) {
    return (
      <div style={{ textAlign: "center", marginTop: "2rem" }}>
        <h3>🛒 Cart is empty</h3>
      </div>
    );
  }

  return (
    <div
      style={{
        marginTop: "3rem",
        maxWidth: "600px",
        marginLeft: "auto",
        marginRight: "auto",
        backgroundColor: "#ffffff",
        border: "1px solid #ddd",
        borderRadius: "12px",
        boxShadow: "0 4px 16px rgba(0,0,0,0.08)",
        padding: "2rem",
        fontFamily: "sans-serif",
      }}
    >
      <h3 style={{ textAlign: "center", marginBottom: "1.5rem" }}>
        🛒 Your Cart
      </h3>

      {cart.map((item) => {
        const price = Number(item.price);
        const lineTotal = price * item.quantity;

        return (
          <div
            key={item.id}
            style={{
              display: "flex",
              justifyContent: "space-between",
              alignItems: "center",
              marginBottom: "1rem",
              paddingBottom: "1rem",
              borderBottom: "1px solid #eee",
            }}
          >
            <div style={{ flex: 1 }}>
              <strong>{item.name}</strong> <br />
              <span>£{!isNaN(price) ? price.toFixed(2) : "N/A"} × </span>
              <input
                type="number"
                value={item.quantity}
                onChange={(e) =>
                  updateQuantity(item.id, parseInt(e.target.value, 10))
                }
                min="1"
                style={{
                  width: "50px",
                  padding: "0.3rem",
                  marginLeft: "0.5rem",
                  marginRight: "0.5rem",
                }}
              />
              = <strong>£{!isNaN(lineTotal) ? lineTotal.toFixed(2) : "N/A"}</strong>
            </div>

            <button
              onClick={() => removeFromCart(item.id)}
              style={{
                backgroundColor: "#e74c3c",
                color: "#fff",
                border: "none",
                borderRadius: "4px",
                padding: "0.4rem 0.8rem",
                cursor: "pointer",
              }}
            >
              Remove
            </button>
          </div>
        );
      })}

      <h3 style={{ textAlign: "right", marginTop: "1.5rem" }}>
        Total: <span style={{ color: "#2ecc71" }}>£{total.toFixed(2)}</span>
      </h3>

      {/* ✅ Stripe Checkout Button */}
      <div style={{ textAlign: "right" }}>
        <button
          onClick={handleCheckout}
          style={{
            marginTop: "1rem",
            padding: "0.8rem 1.5rem",
            backgroundColor: "#5c67f2",
            color: "white",
            border: "none",
            borderRadius: "4px",
            cursor: "pointer",
            fontWeight: "bold",
          }}
        >
          Proceed to Checkout
        </button>
      </div>
    </div>
  );
}

export default Cart;