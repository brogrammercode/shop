/*
 * Cart State / Item List Schema
 * 
 * Resembles the active shopping cart structure shown in:
 * - CartPage (apps/user/lib/features/order/pages/cart_page.dart)
 * 
 * Schema representation:
 * {
 *   "cart_id": "String (Unique ID for user's active cart)",
 *   "items": [
 *     {
 *       "id": "String (Unique identifier of main FoodItem)",
 *       "name": "String (Food name)",
 *       "price": "Double (Base unit price)",
 *       "image_url": "String (Thumbnail image URL)",
 *       "size_info": "String (Selected portion size/description)",
 *       "is_veg": "Boolean (Veg flag)",
 *       "quantity": "Int (Order quantity of this main item)",
 *       "sub_items": [
 *         {
 *           "id": "String (Unique add-on ID)",
 *           "name": "String (Add-on name)",
 *           "price": "Double (Add-on unit price)",
 *           "quantity": "Int (Add-on quantity for this item)"
 *         }
 *       ]
 *     }
 *   ],
 *   "active_address": {
 *     "title": "String (Label, e.g. Home, Work)",
 *     "full_address": "String (Complete street address)",
 *     "distance_in_meters": "Double (Distance from franchise hub)",
 *     "phone_number": "String (Contact phone number)",
 *     "delivers_to": "Boolean (Whether address is inside deliverable range)"
 *   },
 *   "selected_payment_method": {
 *     "id": "String (Identifier, e.g. paytm, gpay)",
 *     "name": "String (Method name)",
 *     "icon_type": "String (Asset/icon identifier)"
 *   },
 *   "is_gold_applied": "Boolean (Whether Zomato/Franchise Gold discount is active)",
 *   "jio_saavn_added": "Boolean (JioSaavn promotional subscription add-on)"
 * }
 */
