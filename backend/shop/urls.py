from django.urls import path
from .views import (
    ProductListView, CreateCheckoutSessionView,
    success, cancel, stripe_webhook
)

urlpatterns = [
    path("", ProductListView.as_view(), name="product_list"),
    path("buy/<int:product_id>/", CreateCheckoutSessionView.as_view(), name="buy"),
    path("success/", success, name="success"),
    path("cancel/", cancel, name="cancel"),
    path("webhook/", stripe_webhook, name="stripe-webhook"),
]