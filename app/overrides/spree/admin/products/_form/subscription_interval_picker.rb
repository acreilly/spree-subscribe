Deface::Override.new(virtual_path: "spree/admin/products/_form",
                     name: "adds_subscription_interval_picker_to_product",
                     insert_before: "[data-hook='admin_product_form_meta']",
                     partial: "spree/admin/shared/subscription_interval_picker")