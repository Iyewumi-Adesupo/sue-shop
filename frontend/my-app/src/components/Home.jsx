// src/components/Home.jsx
import React from "react";
import HeroCarousel from "./HeroCarousel";
import CategoryGrid from "./CategoryGrid";

function Home() {
  return (
    <div style={{ padding: "2rem", fontFamily: "sans-serif", textAlign: "center" }}>
      <h2>🛍️ Welcome to Sue Shop</h2>
      <p>Discover fashion, accessories, and more</p>

      {/* 🔄 Hero images carousel */}
      <div style={{ margin: "2rem 0" }}>
        <HeroCarousel />
      </div>

      {/* 🎯 Categories: Bags, Shoes, Clothing */}
      <div>
        <h3>Shop by Category</h3>
        <CategoryGrid />
      </div>
    </div>
  );
}

export default Home;