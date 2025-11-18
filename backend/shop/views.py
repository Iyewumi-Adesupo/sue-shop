import os
import json
import stripe
from django.http import HttpResponse, JsonResponse
from django.views.decorators.csrf import csrf_exempt
from django.conf import settings
from rest_framework.generics import ListAPIView
from rest_framework import permissions, viewsets, generics
from django.contrib.auth import get_user_model
from .models import Product, Order
from .serializers import ProductSerializer, OrderSerializer, RegisterSerializer

# ---------------------------
# STRIPE CONFIGURATION
# ---------------------------
stripe.api_key = os.getenv("STRIPE_SECRET_KEY")

# Safely import the SignatureVerificationError for all Stripe SDK versions
try:
    from stripe.error import SignatureVerificationError
except ImportError:
    try:
        # Fallback for SDKs using internal _error module
        from stripe._error import SignatureVerificationError
    except ImportError:
        SignatureVerificationError = Exception  # last resort

User = get_user_model()


# ---------------------------
# STRIPE WEBHOOK HANDLER
# ---------------------------
@csrf_exempt
def stripe_webhook(request):
    payload = request.body
    sig_header = request.META.get("HTTP_STRIPE_SIGNATURE")
    endpoint_secret = os.getenv("STRIPE_WEBHOOK_SECRET")

    try:
        event = stripe.Webhook.construct_event(payload, sig_header, endpoint_secret)
    except ValueError:
        # Invalid payload
        return HttpResponse(status=400)
    except SignatureVerificationError:
        # Invalid signature
        return HttpResponse(status=400)

    # ✅ Handle supported event types
    event_type = event.get("type")

    if event_type == "checkout.session.completed":
        handle_checkout_session(event["data"]["object"])
    elif event_type == "charge.refunded":
        handle_refund(event["data"]["object"])
    elif event_type == "checkout.session.expired":
        handle_expired_session(event["data"]["object"])

    return HttpResponse("Webhook received", status=200)


def handle_checkout_session(session):
    """Handle successful checkout session event."""
    session_id = session.get("id")
    try:
        order = Order.objects.get(stripe_checkout_session_id=session_id)
        order.status = "paid"
        order.save()
        print(f"✅ Payment succeeded for {session_id}")
        print("💾 Order status updated for:", session_id)
    except Order.DoesNotExist:
        print(f"⚠️ Order not found for session {session_id}")


def handle_refund(charge):
    """Handle refund event."""
    session_id = charge.get("payment_intent")
    try:
        order = Order.objects.get(stripe_checkout_session_id=session_id)
        order.status = "refunded"
        order.save()
        print(f"💸 Refund processed for {session_id}")
    except Order.DoesNotExist:
        print(f"⚠️ No order found for refund {session_id}")


def handle_expired_session(session):
    """Handle expired checkout session."""
    session_id = session.get("id")
    try:
        order = Order.objects.get(stripe_checkout_session_id=session_id)
        if order.status == "pending":
            order.status = "cancelled"
            order.save()
            print(f"⏰ Session expired for {session_id}")
    except Order.DoesNotExist:
        print(f"⚠️ No order found for expired session {session_id}")


# ---------------------------
# STRIPE PUBLIC KEY ENDPOINT
# ---------------------------
def get_publishable_key(request):
    return JsonResponse({'publicKey': settings.STRIPE_PUBLISHABLE_KEY})


# ---------------------------
# CREATE CHECKOUT SESSION
# ---------------------------
# ---------------------------
# CREATE CHECKOUT SESSION
# ---------------------------
@csrf_exempt
def create_checkout_session(request):
    try:
        session = stripe.checkout.Session.create(
            payment_method_types=['card'],
            mode='payment',
            line_items=[
                {
                    'price_data': {
                        'currency': 'gbp',
                        'product_data': {
                            'name': 'Sue Shop Purchase',
                        },
                        'unit_amount': 8999,  # £89.99 in pence
                    },
                    'quantity': 1,
                },
            ],
            success_url="http://localhost:5173/success",
            cancel_url="http://localhost:5173/cancel",
        )

        return JsonResponse({'clientSecret': session.client_secret})
    except Exception as e:
        return JsonResponse({'error': str(e)}, status=500)


# ---------------------------
# REST API VIEWS
# ---------------------------
class ProductListAPIView(ListAPIView):
    queryset = Product.objects.filter(active=True)
    serializer_class = ProductSerializer

    def get_queryset(self):
        queryset = Product.objects.filter(active=True)
        search_query = self.request.query_params.get('search', '')
        if search_query:
            queryset = queryset.filter(name__icontains=search_query)
        return queryset


class RegisterView(generics.CreateAPIView):
    queryset = User.objects.all()
    serializer_class = RegisterSerializer
    permission_classes = [permissions.AllowAny]


class OrderListView(generics.ListAPIView):
    serializer_class = OrderSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        return Order.objects.filter(user=self.request.user)


# ---------------------------
# CRUD FOR ORDERS
# ---------------------------
class OrderViewSet(viewsets.ModelViewSet):
    serializer_class = OrderSerializer
    permission_classes = [permissions.IsAuthenticated]
    http_method_names = ['get', 'post', 'head', 'options']

    def get_queryset(self):
        return Order.objects.filter(user=self.request.user)

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)