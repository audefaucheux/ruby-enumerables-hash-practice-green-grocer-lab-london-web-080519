def consolidate_cart(cart)
  new_hash = {}
  cart.each do |item|
    if new_hash[item.keys[0]]
      new_hash[item.keys[0]][:count] += 1
    else
      new_hash[item.keys[0]] = {
        count: 1,
        price: item.values[0][:price],
        clearance: item.values[0][:clearance]
      }
    end
  end
  new_hash
end

def apply_coupons(cart, coupons)
  new_cart = cart
  coupons.each do |coupon|
    if new_cart.keys.include? coupon[:item]
      new_name = "#{coupon[:item]} W/COUPON"
      if coupon[:num] <= new_cart[coupon[:item]][:count]
        if new_cart[new_name]
          new_cart[new_name][:count] += coupon[:num]
        else
          new_cart[new_name] = {
          count: coupon[:num],
          price: coupon[:cost]/coupon[:num],
          clearance: new_cart[coupon[:item]][:clearance]
        }
        end
        new_cart[coupon[:item]][:count] -= coupon[:num]
      else
          new_cart[new_name] = {
          count: new_cart[coupon[:item]][:count],
          price: coupon[:cost]/coupon[:num],
          clearance: new_cart[coupon[:item]][:clearance]
        }
        new_cart[coupon[:item]][:count] = 0
      end
    end
  end
  return new_cart
end

def apply_clearance(cart)
  cart.each do |key, value|
    if value[:clearance]
      value[:price] = (value[:price] * 0.80).round(2)
    end
  end
  cart
end

def checkout(cart, coupons)
 consolidated = consolidate_cart(cart)
 coupons_update = apply_coupons(consolidated, coupons)
 product_clearance = apply_clearance(coupons_update)

 total = 0

 consolidated.each do |key, value|
  total += value[:price] * value[:count]
 end

 if coupons
   coupons_update.each do |key, value|
   total += value[:price] * value[:count]
   end
 end

 return total
end
