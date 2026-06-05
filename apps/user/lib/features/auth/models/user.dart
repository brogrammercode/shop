/*
 * User / Authentication Schema
 * 
 * Resembles the data structures used in:
 * - LoginPage (apps/user/lib/features/auth/pages/login_page.dart)
 * 
 * Schema representation:
 * {
 *   "id": "String (UUID/Unique User Identifier)",
 *   "name": "String (User's display name)",
 *   "phone_number": "String (Formatted phone number, e.g. +91 62042 45184)",
 *   "avatar_url": "String (URL to user profile image)",
 *   "email": "String? (Optional email address)",
 *   "is_logged_in": "Boolean (Auth state)",
 *   "remember_me": "Boolean (Whether session is persisted)",
 *   "created_at": "String (ISO 8601 DateTime)",
 *   "login_slides": [
 *     {
 *       "title": "String (Slide header text)",
 *       "logo_text": "String (Slide badge/logo text, e.g. zomato or %)",
 *       "image_url": "String (URL to background image)",
 *       "is_special_deals": "Boolean (Whether to show percentage badge)"
 *     }
 *   ]
 * }
 */
