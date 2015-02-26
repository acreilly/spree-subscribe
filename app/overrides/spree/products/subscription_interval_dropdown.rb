Deface::Override.new(virtual_path: "spree/products/_cart_form",
                     name: "adds_subscription_interval_dropdown",
                     insert_before: ".add-to-cart",
                     partial: "spree/products/subscription_interval_dropdown")