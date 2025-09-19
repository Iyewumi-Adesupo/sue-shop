from django.urls import path
from shop.views import OrderListView

urlpatterns = [
    path("", OrderListView.as_view(), name="order-list"),
]