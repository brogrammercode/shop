/*
 * Food Rating & Customer Reviews Schema
 * 
 * Resembles reviews section and rating summary details on:
 * - FoodPage (apps/user/lib/features/home/pages/food_page.dart)
 * 
 * Schema representation:
 * {
 *   "food_item_id": "String (Reference to the rated FoodItem)",
 *   "average_rating": "Double (Calculated average rating, e.g. 4.5)",
 *   "total_reviews_count": "Int (Total reviews submitted)",
 *   "rating_breakdown": {
 *     "5": "Int (Count of 5 star reviews)",
 *     "4": "Int (Count of 4 star reviews)",
 *     "3": "Int (Count of 3 star reviews)",
 *     "2": "Int (Count of 2 star reviews)",
 *     "1": "Int (Count of 1 star reviews)"
 *   },
 *   "reviews": [
 *     {
 *       "id": "String (Unique review identifier)",
 *       "user_name": "String (Reviewer name)",
 *       "avatar_url": "String (Reviewer avatar URL)",
 *       "rating": "Double (Stars given, 1.0 - 5.0)",
 *       "date": "String (Relative time string, e.g., '2 days ago')",
 *       "review_text": "String (Written customer review content)"
 *     }
 *   ]
 * }
 */

