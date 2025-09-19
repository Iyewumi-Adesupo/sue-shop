from django.contrib import admin, messages
from django.db.models import Sum
from django.template.response import TemplateResponse
from django.urls import path
from .models import Product, Order, OrderItem


@admin.register(Product)
class ProductAdmin(admin.ModelAdmin):
    list_display = ("id", "name", "price", "active")
    search_fields = ("name", "slug")


@admin.register(Order)
class OrderAdmin(admin.ModelAdmin):
    list_display = ("id", "user", "total", "status", "created_at")
    list_filter = ("status", "created_at")
    actions = ["refund_orders"]

    def refund_orders(self, request, queryset):
        refunded = 0
        for order in queryset:
            if order.status == "paid":
                order.status = "refunded"
                order.save()
                refunded += 1
        self.message_user(request, f"Refunded {refunded} orders.", level=messages.SUCCESS)

    refund_orders.short_description = "Refund selected paid orders"


@admin.register(OrderItem)
class OrderItemAdmin(admin.ModelAdmin):
    list_display = ("id", "order", "product", "unit_price", "quantity")


# ---- Custom Admin Site ----
class MyAdminSite(admin.AdminSite):
    site_header = "Sue_Shop Admin"
    site_title = "Sue_Shop Dashboard"
    index_title = "Welcome to SueShop"

    def get_urls(self):
        urls = super().get_urls()
        custom_urls = [
            path("dashboard/", self.admin_view(self.dashboard_view)),
        ]
        return custom_urls + urls

    def dashboard_view(self, request):
        total_orders = Order.objects.count()
        total_revenue = Order.objects.aggregate(Sum("total"))["total__sum"] or 0
        total_products = Product.objects.count()
        recent_orders = Order.objects.order_by("-created_at")[:5]

        context = dict(
            self.each_context(request),
            total_orders=total_orders,
            total_revenue=total_revenue,
            total_products=total_products,
            recent_orders=recent_orders,
        )
        return TemplateResponse(request, "admin/dashboard.html", context)


# Use custom admin site
admin_site = MyAdminSite(name="sue_shop_admin")

# Register models with custom admin site
admin_site.register(Product, ProductAdmin)
admin_site.register(Order, OrderAdmin)
admin_site.register(OrderItem, OrderItemAdmin)