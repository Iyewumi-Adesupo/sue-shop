# shop/urls.py
from django.urls import path, include
from rest_framework.routers import DefaultRouter
from rest_framework_simplejwt.views import (
    TokenObtainPairView,
    TokenRefreshView,
)
from .views import ProductListView, RegisterView, OrderViewSet

router = DefaultRouter()
router.register(r"orders", OrderViewSet, basename="order")

urlpatterns = [
    path("products/", ProductListView.as_view(), name="product-list"),
    path("auth/register/", RegisterView.as_view(), name="register"),

    # ✅ Add JWT login + refresh endpoints
    path("token/", TokenObtainPairView.as_view(), name="token_obtain_pair"),
    path("token/refresh/", TokenRefreshView.as_view(), name="token_refresh"),

    # ✅ Keep DRF router mounted
    path("", include(router.urls)),
]