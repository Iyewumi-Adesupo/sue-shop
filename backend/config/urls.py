# config/urls.py
from django.contrib import admin
from django.urls import path, include
from shop.admin import admin_site   # if you’re using a custom admin site
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView

urlpatterns = [
    path("admin/", admin_site.urls),            # custom admin, or use admin.site.urls
    path("api/", include("shop.urls")),         # your app routes
    path("api/token/", TokenObtainPairView.as_view(), name="token_obtain_pair"),
    path("api/token/refresh/", TokenRefreshView.as_view(), name="token_refresh"),
]