import pytest
from django.urls import reverse
from rest_framework.test import APIClient
from shop.models import Product

@pytest.mark.django_db
def test_list_products():
    Product.objects.create(name="Test", slug="test", price=9.99)
    client = APIClient()
    url = reverse("product-list")
    resp = client.get(url)

    assert resp.status_code == 200

    data = resp.json()
    # Handle pagination vs no pagination
    results = data["results"] if isinstance(data, dict) and "results" in data else data

    assert any(p["name"] == "Test" for p in results)