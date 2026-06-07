/*
 * Food Item Add-On / Sub-Item Schema
 * 
 * Resembles customization items (e.g., drinks, extra toppings) shown in:
 * - FoodPage (apps/user/lib/features/home/pages/food_page.dart)
 * - CartPage (apps/user/lib/features/order/pages/cart_page.dart)
 * 
 * Schema representation:
 * {
 *   "id": "String (Unique identifier)",
 *   "name": "String (Display name, e.g. Mint Chutney, Coca-Cola)",
 *   "price": "Double (Price for a single quantity of this add-on)",
 *   "image_url": "String (URL to add-on thumbnail)",
 *   "is_veg": "Boolean (Vegetarian status)",
 *   "is_available": "Boolean (Stock availability)",
 *   "max_quantity_allowed": "Int (Limit per item)"
 * }
 */

