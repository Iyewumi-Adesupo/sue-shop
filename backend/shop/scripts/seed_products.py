from shop.models import Product

def run():
    if Product.objects.exists():
        print('⚠️ Products already exist. Skipping.')
        return

    products = [
        {
            "name": "Adidas Running Shoes",
            "description": "Lightweight running shoes with mesh upper. Price: £89.99",
            "price": 89.99,
            "image": "products/adidas-sneakers.jpeg",
        },
        {
            "name": "Nike Dunks",
            "description": "Classy and comfortable shoes, unisex fit. Price: £59.99",
            "price": 59.99,
            "image": "products/background-nikeshooes.jpg",
        },
        {
            "name": "Leather Crocodile-skin Bag",
            "description": "Solid and original classy bag. Price: £39.99",
            "price": 39.99,
            "image": "products/bagssss.jpg",
        },
    ]

    for item in products:
        Product.objects.create(**item, active=True)

    print('✅ Sample products seeded successfully.')