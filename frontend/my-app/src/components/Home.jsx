import React from "react";

function Home() {
  return (
    <div style={{ padding: "2rem", fontFamily: "sans-serif", textAlign: "center" }}>
      <h2>🛍️ Welcome to Sue Shop</h2>
      <p>Please register or log in to start shopping!</p>

      <div
        style={{
          display: "flex",
          gap: "2rem",
          flexWrap: "wrap",
          justifyContent: "center",
          marginTop: "2rem",
        }}
      >
        {/* Image 1 */}
        <div style={{ textAlign: "center" }}>
          <img
            src="/images/back-bag-laptop.jpg"
            alt="Laptop Bag"
            width="200"
            style={{ borderRadius: "10px" }}
          />
          <p style={{ marginTop: "0.5rem", fontStyle: "italic" }}>
            Stylish Laptop Bag 💼
          </p>
        </div>

        {/* Image 2 */}
        <div style={{ textAlign: "center" }}>
          <img
            src="/images/bag-1-brown.jpg"
            alt="Brown Bag"
            width="200"
            style={{ borderRadius: "10px" }}
          />
          <p style={{ marginTop: "0.5rem", fontStyle: "italic" }}>
            Elegant Brown Bag 👜
          </p>
        </div>

        {/* Image 3 */}
        <div style={{ textAlign: "center" }}>
          <img
            src="/images/bag-crocodile-skin-green.jpg"
            alt="Crocodile Skin Green Bag"
            width="200"
            style={{ borderRadius: "10px" }}
          />
          <p style={{ marginTop: "0.5rem", fontStyle: "italic" }}>
            Crocodile Skin Bag 🐊
          </p>
        </div>
      </div>
    </div>
  );
}

export default Home;