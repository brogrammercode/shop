/*
 * Order Placement & History Schema
 * 
 * Resembles the placed order details, active tracking, and invoice state:
 * - CartPage (apps/user/lib/features/order/pages/cart_page.dart - post check-out)
 * - PaymentPage (apps/user/lib/features/order/pages/payment_page.dart)
 * 
 * Schema representation:
 * {
 *   "order_id": "String (Formatted transaction ID, e.g. #ZMT-9812491)",
 *   "timestamp": "String (ISO 8601 DateTime of placement)",
 *   "cart_snapshot": "Object (Full snapshot of Cart Schema at checkout)",
 *   "bill_snapshot": "Object (Full snapshot of Bill Schema at checkout)",
 *   "order_status": "String (PLACED | PREPARING | OUT_FOR_DELIVERY | DELIVERED | CANCELLED)",
 *   "payment_status": "String (PENDING | SUCCESS | FAILED)",
 *   "estimated_delivery_time": "String (ISO 8601 DateTime or relative time)",
 *   "delivery_rider": {
 *     "name": "String (Rider name)",
 *     "phone_number": "String (Rider contact number)",
 *     "avatar_url": "String (Rider profile photo URL)"
 *   }
 * }
 */

