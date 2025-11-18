import React from "react";

function ProductCard({ product }) {
  return (
    <div
      style={{
        width: "180px",
        background: "#fff",
        border: "1px solid #eee",
        borderRadius: "10px",
        padding: "1rem",
        boxShadow: "0 2px 5px rgba(0,0,0,0.1)",
        textAlign: "center",
      }}
    >
      <img
        src={product.image}
        alt={product.name}
        style={{
          width: "100%",
          height: "160px",
          objectFit: "cover",
          borderRadius: "6px",
        }}
      />
      <h4 style={{ fontSize: "1rem", margin: "0.5rem 0" }}>{product.name}</h4>
      <p style={{ fontWeight: "bold", color: "#333" }}>£{product.price}</p>
    </div>
  );
}

export default ProductCard;