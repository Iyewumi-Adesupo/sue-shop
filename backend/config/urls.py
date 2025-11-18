# config/urls.py

from django.contrib import admin
from django.urls import path, include
from shop.admin import admin_site  # Custom admin site
from django.conf import settings
from django.conf.urls.static import static

urlpatterns = [
    path("admin/", admin_site.urls),      # Admin panel (custom or default)
    path("api/", include("shop.urls")),   # All app-specific routes live here
]

# Serve media files in development mode
if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)