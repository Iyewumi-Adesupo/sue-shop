# shop/tests/test_webhook_events.py
import pytest
from django.urls import reverse

@pytest.mark.django_db
def test_checkout_session_completed(client, mocker):
    mock_event = {
        "type": "checkout.session.completed",
        "data": {
            "object": {
                "id": "cs_test_webhook",
            }
        }
    }

    # Mock the Stripe method
    mock_construct = mocker.patch("stripe.Webhook.construct_event", return_value=mock_event)

    response = client.post(
        reverse("stripe-webhook"),  # or "/webhooks/stripe/"
        data="{}",  # Dummy body
        content_type="application/json",
        HTTP_STRIPE_SIGNATURE="fake_signature"
    )

    assert response.status_code == 200
    mock_construct.assert_called_once()