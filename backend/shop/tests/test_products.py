import pytest
from django.urls import reverse
from rest_framework.test import APIClient
from shop.models import Product

@pytest.mark.django_db
def test_list_products():
    Product.objects.create(name="Test", slug="test", price=9.99)
    client = APIClient()
    resp = client.get(reverse("product-list"))
    assert resp.status_code == 200
    assert len(resp.json()) >= 1