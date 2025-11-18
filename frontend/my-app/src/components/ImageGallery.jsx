// src/components/ImageGallery.jsx
import React, { useState } from "react";

// ✅ List of your actual image files inside: public/images/
const imageFilenames = [
  "back-bag-laptop.jpg",
  "bag-1-brown.jpg",
  "bags.jpg",
  "bagssss.jpg",
  "denim-jacket-jeans-man.jpg",
  "denim-pant.jpg",
  "face-cap-2.jpg",
  "face-cap-3-white.jpg",
  "face-cap-4.jpg",
  "green-bag-darkgreen.jpg",
  "heels-1.jpg",
  "mule-shoes-1.jpg",
  "shoe-1.jpg",
  "shoe-2-nilke.jpg",
  "shoe-3-nike.jpg",
  "shoe-4-new-balance.jpg",
  "shoe-5-pink-converse.jpg",
  "shoe-7-nike-boots.jpg",
  "Shoes-Image-from-Unsplash.jpg",
  "trench-coat-1.jpg",
  "trench-coat-2.jpg",
  "trench-coat-3.jpg",
  "white-bag.jpg",
  "white-facecap-1.jpg",
];

function ImageGallery() {
  const [hovered, setHovered] = useState(null);

  return (
    <div style={{ padding: "2rem" }}>
      <h2>Image Gallery</h2>
      <div style={{ display: "flex", flexWrap: "wrap", gap: "1rem" }}>
        {imageFilenames.map((name, idx) => (
          <img
            key={idx}
            src={`/images/${name}`}
            alt={`img-${idx}`}
            onMouseEnter={() => setHovered(idx)}
            onMouseLeave={() => setHovered(null)}
            style={{
              width: "200px", // fixed width
              height: "200px", // fixed height
              objectFit: "cover", // prevents stretching
              borderRadius: "8px",
              boxShadow: "0 4px 8px rgba(0,0,0,0.1)",
              transition: "transform 0.3s",
              cursor: "pointer",
              transform: hovered === idx ? "scale(1.05)" : "scale(1)",
            }}
          />
        ))}
      </div>
    </div>
  );
}

export default ImageGallery;