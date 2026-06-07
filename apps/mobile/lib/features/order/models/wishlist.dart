/*
 * Wishlist / Bookmarked Items Schema
 * 
 * Resembles bookmarked/favorited foods/items user wishes to access quickly:
 * - HomePage / Bookmarks (referencing features/home and features/order)
 * 
 * Schema representation:
 * {
 *   "user_id": "String (Owner reference)",
 *   "bookmarked_items": [
 *     {
 *       "food_item_id": "String (Reference ID of bookmarked FoodItem)",
 *       "added_at": "String (ISO 8601 DateTime)",
 *       "notes": "String? (Optional custom personal note about the item)"
 *     }
 *   ]
 * }
 */

