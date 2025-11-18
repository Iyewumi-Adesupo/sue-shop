// src/components/HeroCarousel.jsx
import React, { useState, useEffect } from "react";

const images = [
  "/images/shoe-1.jpg",
  "/images/shoe-3-nike.jpg",
  "/images/shoe-4-new-balance.jpg",
  "/images/shoe-5-pink-converse.jpg",
  "/images/shoe-7-nike-boots.jpg",
];

function HeroCarousel() {
  const [index, setIndex] = useState(0);

  useEffect(() => {
    const timer = setInterval(() => {
      setIndex((prevIndex) => (prevIndex + 1) % images.length);
    }, 3000);
    return () => clearInterval(timer);
  }, []);

  return (
    <div
      style={{
        width: "100%",
        maxWidth: "800px",
        margin: "0 auto",
        overflow: "hidden",
        borderRadius: "12px",
        boxShadow: "0 4px 12px rgba(0,0,0,0.15)",
      }}
    >
      <img
        src={images[index]}
        alt={`Slide ${index}`}
        style={{ width: "100%", height: "400px", objectFit: "cover" }}
      />
    </div>
  );
}

export default HeroCarousel;