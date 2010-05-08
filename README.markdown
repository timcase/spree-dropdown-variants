Spree Dropdown Variants
===============

This is a Spree extension that renders variants as dropdowns instead of the default radio buttons.

What it does 
---

1. On product/show renders an HTML select control for each option type assigned to the product.
2. Option values for the select include all option values for permutations of variants that exist.
   It will exclude option values if not variants for that value are in stock.  For example if you have 
   option values ('Small', 'Medium', 'Large'), but no variants with 'Medium' in stock, medium will not
   be rendered.
3. If a selection of option values is made for which that combination of option values either does not 
   exist as a variant or that variant is out of stock, a validation error on order is added.


Overrides to be aware of
-------------------

1. The view partial 'products/_cartform' is partially overridden through hook :inside_product_cart_form

Construction
-------------------
1. Tried to make it as minimally invasive as possible.
2. Tried to avoid overrides and only use extensions.
3. All helper, model, and controller extensions are RSpec'd.



