# shop/tests/test_products.py
import pytest
from shop.models import Product

@pytest.mark.django_db
def test_product_creation():
    product = Product.objects.create(
        name="Nike Dunks",
        price=59.99,
        description="Just for testing",
        image="products/background-nikeshooes.jpg",
        active=True
    )
    assert product.name == "Nike Dunks"