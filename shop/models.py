from django.db import models
from django.contrib.auth import get_user_model
from django.utils import timezone
from django.conf import settings
import stripe

User = get_user_model()


class Product(models.Model):
    name = models.CharField(max_length=255)
    slug = models.SlugField(unique=True)
    description = models.TextField(blank=True)
    price = models.DecimalField(max_digits=10, decimal_places=2)
    stripe_price_id = models.CharField(max_length=255, blank=True, null=True)  # link to Stripe price (optional)
    active = models.BooleanField(default=True)
    created_at = models.DateTimeField(default=timezone.now)

    def __str__(self):
        return self.name


class Order(models.Model):
    STATUS_CHOICES = [
        ("pending", "Pending"),
        ("paid", "Paid"),
        ("shipped", "Shipped"),
        ("cancelled", "Cancelled"),
        ("refunded", "Refunded"),
    ]

    user = models.ForeignKey(User, on_delete=models.SET_NULL, null=True, blank=True)
    total = models.DecimalField(max_digits=10, decimal_places=2, default=0)
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default="pending")
    stripe_checkout_session_id = models.CharField(max_length=255, blank=True, null=True)
    created_at = models.DateTimeField(default=timezone.now)

    def __str__(self):
        return f"Order #{self.id}"

    def refund(self):
        """Trigger a refund in Stripe"""
        stripe.api_key = settings.STRIPE_SECRET_KEY
        if self.stripe_checkout_session_id:
            try:
                session = stripe.checkout.Session.retrieve(self.stripe_checkout_session_id)
                payment_intent = session.payment_intent
                stripe.Refund.create(payment_intent=payment_intent)
                self.status = "refunded"
                self.save()
                return True
            except Exception as e:
                print(f"Refund failed: {e}")
        return False


class OrderItem(models.Model):
    order = models.ForeignKey(Order, on_delete=models.CASCADE, related_name="items")
    product = models.ForeignKey(Product, on_delete=models.PROTECT)
    unit_price = models.DecimalField(max_digits=10, decimal_places=2)
    quantity = models.PositiveIntegerField(default=1)

    def __str__(self):
        return f"{self.quantity} × {self.product.name}"

    def get_total_price(self):
        return self.unit_price * self.quantity