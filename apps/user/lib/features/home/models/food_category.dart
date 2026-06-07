/*
 * Food Category Schema
 * 
 * Resembles the category navigation and listing structures used in:
 * - HomePage (apps/user/lib/features/home/pages/home_page.dart)
 * 
 * Schema representation:
 * {
 *   "id": "String (Unique identifier)",
 *   "name": "String (Display name, e.g. Sweets, Pizza, Cake)",
 *   "image_url": "String (URL to category thumbnail icon)",
 *   "is_special_card": "Boolean (Custom badge/styling for special entries)",
 *   "subtitle": "String? (Optional sub-label like 'Meals under ₹250')",
 *   "is_active": "Boolean (Filtering state)",
 *   "display_order": "Int (Sorting priority)"
 * }
 */
