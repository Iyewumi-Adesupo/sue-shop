import React, { useEffect, useState } from "react";
import { useLocation } from "react-router-dom";
import Cart from "./cart";

function ProductsList() {
  const location = useLocation();
  const [products, setProducts] = useState([]);
  const [error, setError] = useState("");

  const [cart, setCart] = useState(() => {
    try {
      const saved = localStorage.getItem("cart");
      return saved ? JSON.parse(saved) : [];
    } catch {
      return [];
    }
  });

  useEffect(() => {
    localStorage.setItem("cart", JSON.stringify(cart));
  }, [cart]);

  // ✅ Replace your old fetchProducts() call with direct fetch + debugging
  useEffect(() => {
    const fetchProducts = async () => {
      try {
        const query = new URLSearchParams(location.search).get("search") || "";
        const response = await fetch(`${import.meta.env.VITE_API_BASE_URL}/products/?search=${query}`);
        if (!response.ok) throw new Error("Network response was not ok");

        const data = await response.json();
        console.log("✅ Fetched Products:", data); // ✅ Debug output

        setProducts(data);
        setError("");
      } catch (error) {
        console.error("❌ Failed to fetch products:", error);
        setError("❌ Failed to load products.");
      }
    };

    fetchProducts();
  }, [location.search]);

  const addToCart = (product) => {
    const existing = cart.find((item) => item.id === product.id);
    if (existing) {
      setCart(
        cart.map((item) =>
          item.id === product.id ? { ...item, quantity: item.quantity + 1 } : item
        )
      );
    } else {
      setCart([...cart, { ...product, quantity: 1 }]);
    }
  };

  return (
    <div style={{ padding: "2rem", fontFamily: "sans-serif" }}>
      <h2 style={{ textAlign: "center" }}>🛍️ Products</h2>

      {error && <p style={{ color: "red" }}>{error}</p>}

      {/* Product Grid */}
      <div
        style={{
          display: "grid",
          gridTemplateColumns: "repeat(auto-fit, minmax(250px, 1fr))",
          gap: "2rem",
          marginTop: "2rem",
        }}
      >
        {products.map((product) => {
          const price = Number(product.price); // ✅ force to number
          return (
            <div
              key={product.id}
              style={{
                border: "1px solid #eee",
                borderRadius: "10px",
                padding: "1rem",
                textAlign: "center",
                boxShadow: "0 4px 12px rgba(0,0,0,0.05)",
                background: "#fff",
              }}
            >
              <img
                src={`http://localhost:8000${product.image}`}
                alt={product.name}
                style={{
                  width: "100%",
                  height: "200px",
                  objectFit: "cover",
                  borderRadius: "6px",
                  marginBottom: "1rem",
                }}
              />
              <h3 style={{ margin: "0.5rem 0" }}>{product.name}</h3>
              <p style={{ fontWeight: "bold", marginBottom: "0.5rem" }}>
                £{!isNaN(price) ? price.toFixed(2) : "N/A"}
              </p>
              <button
                onClick={() => addToCart(product)}
                style={{
                  backgroundColor: "#2ecc71",
                  color: "#fff",
                  border: "none",
                  padding: "0.5rem 1rem",
                  borderRadius: "4px",
                  cursor: "pointer",
                }}
              >
                Add to Cart
              </button>
            </div>
          );
        })}
      </div>

      {/* Cart Section */}
      <div style={{ marginTop: "3rem" }}>
        <Cart cart={cart} setCart={setCart} />
      </div>
    </div>
  );
}

export default ProductsList;