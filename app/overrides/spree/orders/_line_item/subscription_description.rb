Deface::Override.new(virtual_path: "spree/orders/_line_item",
                     name: "adds_subscribable_to_product",
                     insert_bottom: "[data-hook='cart_item_description']",
                     partial: "spree/orders/subscription_description")