import pytest
from django.utils import timezone
from shop.models import Product, Order, OrderItem


@pytest.mark.django_db
def test_create_order_with_items():
    product = Product.objects.create(
        name="Test Product",
        slug="test-product",
        price=10.00,
    )
    order = Order.objects.create(status="pending", total=0)
    item = OrderItem.objects.create(
        order=order,
        product=product,
        quantity=2,
        unit_price=product.price,
    )
    order.total = item.quantity * item.unit_price
    order.save()

    assert order.total == 20.00
    assert order.items.count() == 1