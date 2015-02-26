Deface::Override.new(virtual_path: "spree/admin/variants/_form",
                     name: "adds_subscription_price_to_product",
                     insert_after: "[data-hook='cost_price']",
                     partial: "spree/admin/shared/subscription_price_field")