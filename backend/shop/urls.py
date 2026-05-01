# shop/urls.py
from django.urls import path, include
from .views import stripe_webhook
from rest_framework.routers import DefaultRouter
from rest_framework_simplejwt.views import (
    TokenObtainPairView,
    TokenRefreshView,
)
from . import views
from .views import create_checkout_session
from shop.views import ProductListAPIView, RegisterView, OrderViewSet

router = DefaultRouter()
router.register("orders", OrderViewSet, basename="order")

urlpatterns = [
    # Stripe endpoints
    path("create-checkout-session/", views.create_checkout_session, name="checkout_session"),
    path("get-publishable-key/", views.get_publishable_key, name="get_publishable_key"),
    path("webhook/stripe/", stripe_webhook, name="stripe-webhook"),

    # API endpoints
    path("products/", ProductListAPIView.as_view(), name="product-list"),
    path("auth/register/", RegisterView.as_view(), name="register"),

    # JWT authentication
    path("token/", TokenObtainPairView.as_view(), name="token_obtain_pair"),
    path("token/refresh/", TokenRefreshView.as_view(), name="token_refresh"),

    # DRF router (for OrderViewSet)
    path("", include(router.urls)),
]