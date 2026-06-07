/*
 * Food Item Schema
 * 
 * Resembles main food items, pairing items, and detailed views shown in:
 * - HomePage (apps/user/lib/features/home/pages/home_page.dart)
 * - SearchPage / SearchResult (apps/user/lib/features/home/pages/search_page.dart)
 * - FoodPage (apps/user/lib/features/home/pages/food_page.dart)
 * - CartPage (apps/user/lib/features/order/pages/cart_page.dart)
 * 
 * Schema representation:
 * {
 *   "id": "String (Unique identifier)",
 *   "name": "String (Display name, e.g. Sohan Papdi, Paneer Pizza)",
 *   "price": "Double (Base price)",
 *   "image_url": "String (Main image URL)",
 *   "extra_images": "List<String> (Additional slide-show image URLs)",
 *   "rating": "Double (Average rating value)",
 *   "rating_count": "String (Formatted count string, e.g. By 800+)",
 *   "tags": "List<String> (Filters/labels like 'Near & Fast', 'Best Seller')",
 *   "offers": "List<String> (Direct discount info applied to this item)",
 *   "is_veg": "Boolean (Vegetarian status)",
 *   "delivery_time": "String (Estimated delivery range, e.g., '30-35 mins')",
 *   "distance": "String (Distance from user, e.g., '5.5 km away')",
 *   "category_id": "String (Reference back to FoodCategory)",
 *   "size_info": "String (Default portion size description, e.g. '2 Pieces')"
 * }
 */

