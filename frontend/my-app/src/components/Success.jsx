import React, { useEffect } from "react";

const Success = () => {
  useEffect(() => {
    // ✅ Clear the cart when payment succeeds
    localStorage.removeItem("cart");
  }, []);

  return (
    <div style={{ textAlign: "center", padding: "3rem" }}>
      <h1>✅ Payment Successful!</h1>
      <p>Thank you for your order. You’ll receive a confirmation email shortly.</p>
    </div>
  );
};

export default Success;