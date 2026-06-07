/*
 * Food Discount & Promotional Offers Schema
 * 
 * Resembles banners and coupon/discount tags shown in:
 * - HomePage (apps/user/lib/features/home/pages/home_page.dart)
 * - FoodPage (apps/user/lib/features/home/pages/food_page.dart)
 * - CartPage (apps/user/lib/features/order/pages/cart_page.dart)
 * 
 * Schema representation:
 * {
 *   "id": "String (Unique coupon/promo code)",
 *   "title": "String (Main promo text, e.g. GOLD FLASH SALE)",
 *   "subtitle": "String (Discount detail, e.g. ₹1 for 3 months)",
 *   "button_text": "String (Action label, e.g. Renew Gold now →)",
 *   "image_url": "String (Promo background/banner image URL)",
 *   "discount_type": "String (PERCENTAGE | FLAT_AMOUNT | FREE_DELIVERY)",
 *   "value": "Double (Discount value / multiplier)",
 *   "min_cart_amount": "Double (Minimum bill requirement to apply)",
 *   "max_discount_limit": "Double? (Upper cap on percentage discount value)",
 *   "expiry_date": "String (ISO 8601 DateTime)"
 * }
 */
