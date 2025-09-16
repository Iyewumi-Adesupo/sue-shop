from django.contrib import admin, messages
from django.urls import path
from django.template.response import TemplateResponse
from django.db.models import Sum
from .models import Product, Order, OrderItem


class OrderItemInline(admin.TabularInline):
    model = OrderItem
    readonly_fields = ("product", "unit_price", "quantity")
    extra = 0


class OrderAdmin(admin.ModelAdmin):
    list_display = ("id", "user", "total", "status", "created_at")
    inlines = [OrderItemInline]
    actions = ["refund_orders"]

    def refund_orders(self, request, queryset):
        """Admin action to refund selected orders"""
        refunded = 0
        for order in queryset:
            if order.status == "paid" and order.refund():
                refunded += 1
        self.message_user(
            request,
            f"Refunded {refunded} orders.",
            level=messages.SUCCESS
        )

    refund_orders.short_description = "Refund selected paid orders"


class MyAdminSite(admin.AdminSite):
    site_header = "Sue-Shop Admin"
    site_title = "Sue-Shop Dashboard"
    index_title = "Welcome to Sue-Shop"

    def get_urls(self):
        urls = super().get_urls()
        custom_urls = [
            path("dashboard/", self.admin_view(self.dashboard_view))
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


# Register models with custom admin site
admin_site = MyAdminSite(name="sue-shop_admin")
admin_site.register(Product)
admin_site.register(Order, OrderAdmin)