import React from "react";
import { useStripe, useElements, CardElement } from "@stripe/react-stripe-js";

function CheckoutForm() {
  const stripe = useStripe();
  const elements = useElements();

  const handleSubmit = async (e) => {
    e.preventDefault();

    if (!stripe || !elements) {
      alert("Stripe.js is not loaded yet.");
      return;
    }

    try {
      const response = await fetch("http://localhost:8000/api/create-checkout-session/", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          items: [
            {
              price: "price_1SHUANRvUqAwLFTfS9MFvgp7", // Replace if needed
              quantity: 1,
            },
          ],
        }),
      });

      const data = await response.json();
      const clientSecret = data.clientSecret;

      const cardElement = elements.getElement(CardElement);

      const { error: stripeError, paymentIntent } = await stripe.confirmCardPayment(clientSecret, {
        payment_method: {
          card: cardElement,
        },
      });

      if (stripeError) {
        console.error("Stripe error:", stripeError);
        alert("Payment failed. Try again.");
      } else if (paymentIntent.status === "succeeded") {
        alert("✅ Payment succeeded!");
      } else {
        alert(`Payment status: ${paymentIntent.status}`);
      }
    } catch (err) {
      console.error("Checkout error:", err);
      alert("Something went wrong. Try again later.");
    }
  };

  return (
    <form onSubmit={handleSubmit} style={{ maxWidth: "400px", margin: "2rem auto" }}>
      <h2>Secure Checkout</h2>
      <label htmlFor="card-element" style={{ display: "block", marginBottom: "0.5rem" }}>
        Card Details
      </label>
      <CardElement id="card-element" />
      <button
        type="submit"
        disabled={!stripe}
        style={{
          marginTop: "1rem",
          backgroundColor: "#28a745",
          color: "white",
          padding: "0.5rem 1.5rem",
          border: "none",
          borderRadius: "5px",
          cursor: "pointer",
        }}
      >
        Pay Now
      </button>
    </form>
  );
}

export default CheckoutForm;