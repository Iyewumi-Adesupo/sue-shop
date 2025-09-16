from django.urls import path, include
from shop.admin import admin_site

urlpatterns = [
    path("admin/", admin_site.urls),   #custom admin here
    path('api/', include('shop.urls')),    # app routes here
]