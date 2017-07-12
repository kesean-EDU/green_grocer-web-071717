require 'pry'
def consolidate_cart(cart)
  new_cart = {}
  cart.each do |items|
    items.each do |item, details|
      new_cart[item] ||= details
      new_cart[item][:count] ||= 0
      new_cart[item][:count]+=1
    end
  end
  return new_cart
end

def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    item_name = coupon[:item]
    if cart[item_name] && cart[item_name][:count] >= coupon[:num]
      if cart["#{item_name} W/COUPON"]
        cart["#{item_name} W/COUPON"][:count] += 1
      else
        cart["#{item_name} W/COUPON"] = {count: 1, price: coupon[:cost]}
        cart["#{item_name} W/COUPON"][:clearance] = cart[item_name][:clearance]
      end
      cart[item_name][:count] -= coupon[:num]
    end
  end
  return cart
end

def apply_clearance(cart)
  cart.each do |item, fields|
    if fields[:clearance]
      clearance_price = fields[:price] * 0.80
      fields[:price] = clearance_price.round(2)
    end
  end
  cart
end

def checkout(cart, coupons)
  consolidated_cart = consolidate_cart(cart)
  coupon_cart = apply_coupons(consolidated_cart, coupons)
  final_cart = apply_clearance(coupon_cart)
  total = 0
  final_cart.each do |name, fields|
    total +=fields[:price] * fields[:count]
  end
  if total > 100
    total = total * 0.9
  end
  return total
end
