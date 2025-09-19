
// src/components/ProductsList.jsx
import React, { useEffect, useState } from "react";
import { fetchProducts } from "../api";
import Cart from "./cart"; // ✅ Correct import

function ProductsList() {
  const [products, setProducts] = useState([]);
  const [error, setError] = useState("");

  // ✅ Load cart from localStorage safely
  const [cart, setCart] = useState(() => {
    try {
      const saved = localStorage.getItem("cart");
      return saved ? JSON.parse(saved) : [];
    } catch {
      return [];
    }
  });

  // Save cart to localStorage whenever it changes
  useEffect(() => {
    localStorage.setItem("cart", JSON.stringify(cart));
  }, [cart]);

  // Fetch products
  useEffect(() => {
    fetchProducts()
      .then(setProducts)
      .catch((err) => {
        console.error("Failed to load products:", err);
        setError("Could not load products.");
      });
  }, []);

  if (error) return <p style={{ color: "red" }}>{error}</p>;
  if (!products.length) return <p>Loading products...</p>;

  // ✅ Add to cart instead of submitting order
  const addToCart = (product) => {
    const existing = cart.find((item) => item.id === product.id);
    if (existing) {
      setCart(
        cart.map((item) =>
          item.id === product.id
            ? { ...item, quantity: item.quantity + 1 }
            : item
        )
      );
    } else {
      setCart([...cart, { ...product, quantity: 1 }]);
    }
  };

  return (
    <div>
      <h2>🛍️ Products</h2>
      {error && <p style={{ color: "red" }}>{error}</p>}
      <ul>
        {products.map((p) => (
          <li key={p.id}>
            {p.name} - £{p.price}
            <button onClick={() => addToCart(p)}>Order Now</button>
          </li>
        ))}
      </ul>

      {/* ✅ Show cart below products */}
      <Cart cart={cart} setCart={setCart} />
    </div>
  );
}

export default ProductsList;