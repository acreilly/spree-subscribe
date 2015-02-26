Deface::Override.new(virtual_path: "spree/admin/products/_form",
                     name: "adds_subscribable_to_product",
                     insert_bottom: "[data-hook='admin_product_form_right']",
                     partial: "spree/admin/shared/subscribable_checkbox")