class DropdownVariantsHooks < Spree::ThemeSupport::HookListener
  replace  :inside_product_cart_form, 'products/dropdown_variants'
end
