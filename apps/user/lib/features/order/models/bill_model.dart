/*
 * Order Bill / Invoice Summary Schema
 * 
 * Resembles the detailed price breakdown shown in:
 * - CartPage (apps/user/lib/features/order/pages/cart_page.dart)
 * - PaymentPage (apps/user/lib/features/order/pages/payment_page.dart)
 * 
 * Schema representation:
 * {
 *   "items_subtotal": "Double (Sum of cart items' base prices * quantity)",
 *   "addons_subtotal": "Double (Sum of selected add-ons/sub-items total)",
 *   "platform_fee": "Double (Flat platform fee charges, e.g. ₹6.0)",
 *   "gst_and_restaurant_charges": "Double (Calculated tax & packaging fees)",
 *   "delivery_partner_fee": "Double (Fee based on distance, e.g. ₹35.0)",
 *   "coupon_discount": "Double (Reduction amount applied by promo code)",
 *   "donation_amount": "Double (Optional charity contribution, e.g., ₹2.0)",
 *   "grand_total": "Double (Final payable amount: subtotals + fees - discounts + donation)"
 * }
 */
