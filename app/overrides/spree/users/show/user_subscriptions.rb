Deface::Override.new(virtual_path: "spree/users/show",
                     name: "add user subscriptions",
                     insert_after: "[data-hook='account_my_orders'], #account_my_orders[data-hook]",
                     partial: "spree/users/user_subscriptions")