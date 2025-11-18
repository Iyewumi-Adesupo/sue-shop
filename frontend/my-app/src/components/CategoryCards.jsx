// src/components/CategoryCards.jsx
import React from "react";
import { useNavigate } from "react-router-dom";
import "../styles/CategoryCards.css";

function CategoryCards() {
  const navigate = useNavigate();

  const categories = [
    { name: "Bags", image: "/images/bag-1-brown.jpg" },
    { name: "Shoes", image: "/images/mule-shoes-1.jpg" },
    { name: "Clothing", image: "/images/trench-coat-2.jpg" },
  ];

  return (
    <div className="category-grid">
      {categories.map((cat) => (
        <div
          key={cat.name}
          className="category-card"
          onClick={() => navigate(`/products?category=${cat.name.toLowerCase()}`)}
        >
          <img src={cat.image} alt={cat.name} />
          <div className="category-label">{cat.name}</div>
        </div>
      ))}
    </div>
  );
}

export default CategoryCards;