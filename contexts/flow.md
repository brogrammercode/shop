# Application User Flows

This document outlines the operational sequences for different user scenarios within the application.

## 1. New User Onboarding
1.  **Authentication**: User logs in using Google Authentication.
2.  **Business Discovery**: User is presented with a page to "Find Your Business" or "Create Your Business".
3.  **Business Creation**: 
    - User selects "Create Your Business".
    - User provides basic business details.
4.  **Branch Setup**: After business creation, the user is prompted to add the initial branch.
5.  **Backend Provisioning**:
    - System creates a **Role** named "Owner" with permission `["ALL"]`.
    - System creates an **Employee** record for the user, linked to the newly created branch and the "Owner" role.
6.  **Dashboard Access**:
    - User is redirected to the Dashboard.
    - Important context (Business, Branch, User, Employee docs, and Permissions) is saved to Local Storage for offline-ready access.

---

## 2. Joining an Existing Business
1.  **Authentication**: User logs in using Google Authentication.
2.  **Search**: User searches for a specific business as instructed.
3.  **Application**: User finds the correct business and submits a request to join.
4.  **Approval**: An authorized employee (e.g., Owner/Admin) within the business reviews and accepts the request.
5.  **Role Assignment**:
    - If no specific role is assigned during approval, the system creates/assigns a default "Employee" role within that branch.
6.  **Access**: User becomes an active member of the branch.

---

## 3. Returning Authenticated User
1.  **Login**: User opens the app; if a valid session token exists, auto-login is performed.
2.  **State Verification**: System verifies the user's business association and permissions.
3.  **Redirection**: Since the user is already associated with a business, the Business Dashboard is opened directly.
4.  **Feature Visibility**: The interface dynamically displays features and modules based on the user's assigned permissions.

---

## 4. Physical Shop Purchase (Over-the-Counter)
1.  **Initiation**: Employee opens the mobile app.
2.  **Inquiry**: Customer asks for product availability; Employee verifies in-app.
3.  **Selection**: Employee selects products/quantities in the UI.
4.  **Billing**: Employee generates a bill and presents the total amount to the customer.
5.  **Payment**: Customer pays using a static QR code displayed at the shop.
6.  **Printing**: Employee prints dual receipts using a Bluetooth Thermal Printer directly from the app.
7.  **Fulfillment**: 
    - Customer presents one receipt to the packing counter.
    - Packing staff retains one receipt for records and hands over the product.
    - Customer keeps the second copy.

---

## 5. Restaurant Table-QR Ordering
1.  **Discovery**: Customer sits at a table and scans a unique table QR code.
2.  **Menu Access**: A web interface opens showing the branch-specific menu.
3.  **Ordering**: Customer selects items and submits the order.
4.  **Production**: Cook/Staff receives the order; order status updates are reflected in real-time for the customer to track.
5.  **Persistence**: If the customer closes the browser, the session is recovered based on the table number.
6.  **Settlement**: Customer pays via integrated payment links (e.g., PhonePe/GPay QR).
7.  **Receipt**: A digital receipt is generated and sent via WhatsApp or other digital channels.

---

## 6. Delivery Flow
1.  **Ordering**: Customer places a delivery order via the web/mobile app, providing address and contact details.
2.  **Assignment**:
    - Branch staff accepts the order.
    - System or Staff assigns an available **Rider** to the delivery.
3.  **Dispatch**:
    - Once the order is "Ready", the Rider picks up the package and marks the status as "Out for Delivery".
    - Customer receives a notification with the Rider's details and tracking link.
4.  **Transit**: Rider uses the app to navigate to the customer's location; real-time status and location are tracked.
5.  **Handoff**: 
    - Rider arrives and verifies the customer (via OTP or contact).
    - Payment is collected/verified (COD or Prepaid).
6.  **Completion**: Rider marks the order as "Delivered" in the app, closing the lifecycle and triggering the final digital receipt.
