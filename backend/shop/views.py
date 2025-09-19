import stripe
from django.http import HttpResponse
from django.views.decorators.csrf import csrf_exempt
from django.conf import settings

from rest_framework import generics, permissions, viewsets
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import AllowAny, IsAuthenticated
from django.contrib.auth import get_user_model
from .models import Product, Order
from .serializers import ProductSerializer, OrderSerializer, RegisterSerializer

User = get_user_model()
stripe.api_key = settings.STRIPE_SECRET_KEY


# ---------------------------
# REST API VIEWS
# ---------------------------

# Product List
class ProductListView(generics.ListAPIView):
    queryset = Product.objects.filter(active=True)
    serializer_class = ProductSerializer


# Register (user signup)
class RegisterView(generics.CreateAPIView):
    queryset = User.objects.all()
    serializer_class = RegisterSerializer
    permission_classes = [permissions.AllowAny]


# Orders List (only for authenticated users)
class OrderListView(generics.ListAPIView):
    serializer_class = OrderSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        return Order.objects.filter(user=self.request.user)


# ---------------------------
# STRIPE WEBHOOK HANDLER
# ---------------------------

@csrf_exempt
def stripe_webhook(request):
    payload = request.body
    sig_header = request.META.get("HTTP_STRIPE_SIGNATURE")
    endpoint_secret = settings.STRIPE_WEBHOOK_SECRET

    try:
        event = stripe.Webhook.construct_event(payload, sig_header, endpoint_secret)
    except ValueError:
        return HttpResponse(status=400)
    except stripe.error.SignatureVerificationError:
        return HttpResponse(status=400)

    # --- Events to handle ---
    if event["type"] == "checkout.session.completed":
        session = event["data"]["object"]
        handle_checkout_session(session)

    elif event["type"] == "charge.refunded":
        charge = event["data"]["object"]
        handle_refund(charge)

    elif event["type"] == "checkout.session.expired":
        session = event["data"]["object"]
        handle_expired_session(session)

    return HttpResponse(status=200)


def handle_checkout_session(session):
    """Mark order as paid when checkout succeeds"""
    session_id = session.get("id")
    try:
        order = Order.objects.get(stripe_checkout_session_id=session_id)
        order.status = "paid"
        order.save()
    except Order.DoesNotExist:
        pass


def handle_refund(charge):
    """Mark order as refunded if a refund occurs"""
    session_id = charge.get("payment_intent")
    try:
        order = Order.objects.get(stripe_checkout_session_id=session_id)
        order.status = "refunded"
        order.save()
    except Order.DoesNotExist:
        pass


def handle_expired_session(session):
    """Mark order as cancelled if checkout session expired without payment"""
    session_id = session.get("id")
    try:
        order = Order.objects.get(stripe_checkout_session_id=session_id)
        if order.status == "pending":
            order.status = "cancelled"
            order.save()
    except Order.DoesNotExist:
        pass


# ---------------------------
# NEW: FULL CRUD FOR ORDERS
# ---------------------------
class OrderViewSet(viewsets.ModelViewSet):
    serializer_class = OrderSerializer
    permission_classes = [permissions.IsAuthenticated]
    http_method_names = ['get', 'post', 'head', 'options']

    def get_queryset(self):
        return Order.objects.filter(user=self.request.user)

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)