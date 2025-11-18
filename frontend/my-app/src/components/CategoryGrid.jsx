// src/components/CategoryGrid.jsx
import React from "react";
import { useNavigate } from "react-router-dom";

const categories = [
  { name: "Bags", image: "/images/bags.jpg" },
  { name: "Shoes", image: "/images/shoe-5-pink-converse.jpg" },
  { name: "Clothing", image: "/images/trench-coat-3.jpg" },
];

function CategoryGrid() {
  const navigate = useNavigate();

  return (
    <div
      style={{
        display: "flex",
        justifyContent: "center",
        gap: "2rem",
        flexWrap: "wrap",
        paddingTop: "2rem",
      }}
    >
      {categories.map((cat) => (
        <div
          key={cat.name}
          onClick={() =>
            navigate(`/products?category=${cat.name.toLowerCase()}`)
          }
          style={{
            width: "160px",
            cursor: "pointer",
            textAlign: "center",
            borderRadius: "8px",
            backgroundColor: "#fff",
            boxShadow: "0 2px 6px rgba(0,0,0,0.1)",
            padding: "1rem",
            transition: "transform 0.2s",
          }}
        >
          <img
            src={cat.image}
            alt={cat.name}
            style={{
              width: "100px",
              height: "100px",
              objectFit: "cover",
              borderRadius: "50%",
              marginBottom: "0.5rem",
            }}
          />
          <p style={{ fontWeight: "bold" }}>{cat.name}</p>
        </div>
      ))}
    </div>
  );
}

export default CategoryGrid;