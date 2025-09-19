from rest_framework import serializers
from django.contrib.auth import get_user_model
from .models import Product, Order, OrderItem

User = get_user_model()


class ProductSerializer(serializers.ModelSerializer):
    class Meta:
        model = Product
        fields = ["id", "name", "slug", "description", "price", "stripe_price_id", "active"]


class OrderItemSerializer(serializers.ModelSerializer):
    product = ProductSerializer(read_only=True)
    class Meta:
        model = OrderItem
        fields = ["product", "unit_price", "quantity", "get_total_price"]


# shop/serializers.py
from rest_framework import serializers
from .models import Order, OrderItem, Product

class OrderSerializer(serializers.ModelSerializer):
    product = serializers.PrimaryKeyRelatedField(
        queryset=Product.objects.all(), write_only=True
    )
    quantity = serializers.IntegerField(write_only=True, min_value=1)

    class Meta:
        model = Order
        fields = ["id", "status", "total", "created_at", "product", "quantity"]

    def create(self, validated_data):
        user = self.context["request"].user
        product = validated_data.pop("product")
        quantity = validated_data.pop("quantity")

        # create order
        order = Order.objects.create(user=user, total=product.price * quantity)

        # create order item
        OrderItem.objects.create(
            order=order, product=product, unit_price=product.price, quantity=quantity
        )

        return order

class RegisterSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True)
    class Meta:
        model = User
        fields = ["id", "username", "email", "password"]

    def create(self, validated_data):
        user = User.objects.create_user(
            username=validated_data["username"],
            email=validated_data.get("email"),
            password=validated_data["password"]
        )
        return user