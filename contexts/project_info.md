# Case Study: Shop — Multi-Branch Food Retail & Operations Platform

## 1. Executive Summary

Shop is a full-stack, enterprise-grade, multi-branch food retail and operations management platform. It is designed to manage every layer of a food business — from employee HR and inventory procurement, to kitchen display systems, customer loyalty, franchise royalties, and double-entry accounting — all connected via a real-time WebSocket layer.

The system is architected as a monorepo with three distinct applications:

| App | Technology | Role |
|---|---|---|
| `apps/api` | Node.js + Express + TypeScript + Prisma + PostgreSQL | Backend REST API |
| `apps/mobile` | Flutter (Dart) | Staff/Manager mobile app |
| `apps/user` | Flutter (Dart) | Customer-facing mobile app |

---

## 2. Business Domain

The platform is purpose-built for multi-branch food service businesses (restaurants, bakeries, quick-service chains, cloud kitchens). Its core value proposition is operational unification: one system governs every department that a branch manager, franchisee, or HQ operator would need to run day-to-day.

Key business actors:
- Branches — individual store locations, one of which may be the HQ
- Franchisees — branch owners under a royalty agreement
- Employees — staff assigned to departments, posts, shifts, and roles with granular permissions
- Customers (Users) — end consumers who place orders and earn loyalty points
- Suppliers — external procurement sources
- Delivery Partners — third-party or in-house delivery agents

---

## 3. System Architecture

### 3.1 Monorepo Layout

```
shop/
  contexts/          <- Architecture & coding standards (Markdown)
  apps/
    api/             <- TypeScript backend
    mobile/          <- Flutter staff app
    user/            <- Flutter customer app
```

### 3.2 Backend (apps/api)

| Layer | Technology |
|---|---|
| Runtime | Node.js (ESM) |
| Framework | Express 5.x |
| Language | TypeScript 6.x |
| ORM | Prisma 7.x (pg adapter) |
| Database | PostgreSQL |
| Auth | Firebase Admin + JWT (jsonwebtoken) |
| Real-time | Socket.IO 4.x |
| Media | Cloudinary |
| Validation | Zod 4.x |
| Logging | Winston |
| Security | Helmet, bcryptjs, CORS |
| Deployment | Vercel |

The API follows a strict layered architecture:

```
Controller -> Service -> Repository -> Prisma -> PostgreSQL
```

Middleware handles authentication, validation, error normalization, and request logging.

### 3.3 Mobile — Staff App (apps/mobile)

| Layer | Technology |
|---|---|
| Framework | Flutter / Dart SDK ^3.11.5 |
| State | flutter_bloc (Cubit pattern) |
| HTTP | Dio 5.x |
| Result | dartz (Either / TaskResult) |
| Storage | flutter_secure_storage |
| DI | GetIt |
| Auth | google_sign_in |
| UI scaling | flutter_screenutil |
| Loading | shimmer |
| Toasts | fluttertoast |
| Fonts | google_fonts (Outfit) |
| Hardware | print_bluetooth_thermal, esc_pos_utils_plus (receipt printing) |
| Permissions | permission_handler, geolocator, geocoding |

### 3.4 Mobile — Customer App (apps/user)

| Layer | Technology |
|---|---|
| Framework | Flutter / Dart SDK ^3.11.5 |
| State | flutter_bloc (Cubit pattern) |
| HTTP | Dio 5.x |
| Auth | google_sign_in |
| DI | GetIt |

The customer app contains 5 feature areas: auth, home, order, store, setting.

---

## 4. Domain Modules (7 Core Modules)

The entire system is organized into 7 business modules, each reflected identically in the API type definitions, the Prisma schema, and the mobile feature folders.

### Module 1: Core HR / Setup

Covers foundational business setup and human resources.

| Entity | Description |
|---|---|
| Branch | A physical store location. Can be HQ. Has status (ACTIVE / INACTIVE / SUSPENDED). Central pivot for all other entities. |
| Franchise | Extends a Branch with an owner name, royalty percentage, and agreement document. |
| User | A person (customer or staff) identified by phone number. Firebase UID or CUID. |
| UserLog | Immutable audit trail of all user actions with module, type, metadata, and reference links. |
| Address | Polymorphic address entity attached to Branches, Employees, Users, Suppliers, or Delivery Partners. |
| BankDetail | Polymorphic bank account entity supporting multiple entity types. |
| Department | Organisational unit within a branch (e.g. Kitchen, Front-of-House). |
| Post | A job title/designation within a Department (e.g. Chef, Cashier). |
| Shift | A named time window with start/end times scoped to a Branch. |
| Role | A permissions bundle (string array) assigned to employees. |
| Employee | Links a User to a Branch with a Department, Post, Shift, and Role assignment. Status: ACTIVE / ON_LEAVE / TERMINATED. |
| TimeLog | Clock-in/clock-out records per employee per branch with computed total hours. |
| CashRegister | Named till device with MAC address, expected vs. actual cash, and open/close status. |

### Module 2: Catalog / Menu

The customer-facing menu layer (front-of-house).

| Entity | Description |
|---|---|
| MenuCategory | Named grouping of menu items with display order. |
| MenuItem | A sellable item with display name, price, image, and a link to an ItemVariant in inventory. |
| ModifierGroup | A group of add-ons/customisations with min/max selection rules. |
| Modifier | An individual add-on option with an optional inventory variant link and extra price. |
| ComboMeal | A fixed-price bundle of multiple MenuItems. |
| ComboItem | The join table linking ComboMeal to MenuItem with a quantity. |

Key design decision: MenuItem.variant_id bridges the Menu (front-of-house) to Inventory (back-of-house). Selling a menu item automatically knows which raw inventory variant is consumed.

### Module 3: Inventory / Supply Chain

The back-of-house stock and procurement system.

| Entity | Description |
|---|---|
| ItemCategory | Category for inventory items (not menu categories). |
| Item | A raw material, semi-finished good, finished product, asset, or packaging. |
| ItemType | Enum: RAW_MATERIAL, SEMI_FINISHED, FINISHED_GOOD, ASSET, PACKAGING. |
| UnitOfMeasure | Measurement codes (KG, GM, LTR, BOX, PCS). |
| UOMConversion | Conversion factor between two units of measure (e.g. 1 KG = 1000 GM). |
| ItemVariant | A specific SKU of an Item with a UOM, barcode, base cost, and minimum stock level. |
| Supplier | A vendor with contact info and tax number. |
| PurchaseOrder | An order placed with a supplier. Statuses: DRAFT, SENT, PARTIALLY_RECEIVED, RECEIVED, CANCELLED. |
| POItem | Line item on a Purchase Order with qty and unit/total price. |
| GoodsReceipt | Records actual receipt of goods against a PO. |
| VendorReturn | A return to supplier with reason, refund value, and approval workflow. |
| StockLedger | Double-entry-style immutable stock movement record with transaction type and running balance. |
| StockTransType | PURCHASE, SALE, PRODUCTION_IN, PRODUCTION_OUT, WASTAGE, TRANSFER_IN, TRANSFER_OUT, RETURN, ADJUSTMENT. |
| StockTransfer | Inter-branch inventory movement with dispatch/receive confirmation and driver info. |
| TransferItem | Line item on a StockTransfer. |

### Module 4: Manufacturing & Recipe

Production management for made-to-order or batch-produced items.

| Entity | Description |
|---|---|
| BillOfMaterial (BOM) | A recipe: one output ItemVariant produced from multiple input variants at a given yield quantity. |
| BOMItem | An ingredient line in a BOM with quantity required. |
| ProductionBatch | An execution of a BOM: planned qty, produced qty, expiry date, status tracking. |
| BatchStatus | PLANNED, IN_PROGRESS, COMPLETED, CANCELLED. |
| QCAudit | Quality control checkpoint on a batch: temperature, taste test, hygiene, packaging check. |
| WastageLog | Records ingredient or product wastage with reason, quantity, and responsible party. |

### Module 5: Order / POS / KDS

The point-of-sale and kitchen display system.

| Entity | Description |
|---|---|
| TableZone | A named area within a branch (e.g. Indoor, Outdoor, VIP). |
| Table | A physical table with zone, capacity, and status (AVAILABLE / OCCUPIED / CLEANING / RESERVED). |
| DeliveryPartner | An in-house or third-party delivery agent with commission percentage. |
| Order | The central transactional entity. Supports 5 order types. Tracks subtotal, tax, discount, and total. |
| OrderType | DINE_IN, TAKEAWAY, DELIVERY, AGGREGATOR, PRE_ORDER. |
| OrderStatus | OPEN, BILLED, PAID, CANCELLED, REFUNDED. |
| OrderItem | A line item on an order with qty, unit price, and total. |
| KitchenOrderTicket (KOT) | A ticket sent to a kitchen station. Statuses: PREPARING, READY, SERVED, CANCELLED. |
| KOTStation | HOT_FOOD, BAKERY, DRINKS, SWEETS_COUNTER, PACKAGING. |
| AdvancePayment | Partial or pre-payment on an order. Methods: CASH, CARD, ONLINE, WALLET, LOYALTY_POINTS. |

### Module 6: CRM / Complaints

Customer relationship management.

| Entity | Description |
|---|---|
| LoyaltyTrans | Points earned, redeemed, refunded, or bonused per user per order. |
| Coupon | Discount code with percentage off, minimum order value, max discount cap, and expiry. |
| Complaint | Customer complaint linked to a specific order. Statuses: OPEN, IN_PROGRESS, RESOLVED, REFUNDED. |

### Module 7: Finance / Accounting

Double-entry bookkeeping and asset management.

| Entity | Description |
|---|---|
| Account | A named chart-of-accounts entry. Types: ASSET, LIABILITY, EQUITY, REVENUE, EXPENSE. |
| LedgerEntry | A debit/credit entry against an account with reference type and ID for traceability. |
| FixedAsset | A branch-level capital asset with purchase value, depreciation percentage, and lifecycle status. |
| RoyaltyTrans | Calculated royalty amounts owed by a franchise branch. Statuses: PENDING, INVOICED, PAID. |

---

## 5. Real-Time Infrastructure

The backend boots a Socket.IO server alongside the Express HTTP server. This is used for:
- Live Kitchen Display System (KDS) updates — KOT status changes broadcast to kitchen screens in real time
- Real-time order status updates to POS terminals and customer-facing displays
- Cash register open/close events

---

## 6. Cross-Cutting Infrastructure

| Concern | Implementation |
|---|---|
| Auth | Firebase Admin verifies tokens; JWT is issued for session continuity |
| Config | Zod-validated core/config.ts — no raw process.env in feature code |
| DB Connection | Managed PostgreSQL via @prisma/adapter-pg; graceful connect/disconnect on SIGTERM/SIGINT |
| Error Handling | Centralised error.middleware.ts; feature code throws typed exceptions |
| Logging | Winston logger with structured output |
| Media Upload | Cloudinary via multer |
| Push Notifications | Firebase Messaging via infra/messaging/ |
| Security | Helmet headers, bcryptjs for password hashing, JWT for tokens |

---

## 7. Coding Standards & Architecture Rules

The contexts/ directory contains living architecture documents that all code must conform to.

### Zero-Comment Policy
All code is 100% comment-free. Self-documenting names replace all comments.

### Feature-Based Architecture
Every feature follows the same flat layout across both API and mobile:

API feature layout:
```
features/[feature]/
  [feature].type.ts
  [feature].repo.ts
  [feature].service.ts
  [feature].controller.ts
  [feature].route.ts
  [feature].constant.ts
```

Mobile feature layout:
```
features/[feature]/
  [entity].model.dart
  [feature].repo.dart
  [feature].cubit.dart
  [feature].state.dart
  [feature].page.dart
  [feature].constant.dart
```

### Strict Typing Throughout
- TypeScript interfaces for every API data shape
- Dart final immutable models with fromJson / toJson / copyWith
- dartz Either (TaskResult<T>, SyncResult<T>) for all async results

### Backend Field Parity
Mobile model fields mirror snake_case database column names exactly (user_id, branch_id, created_at, updated_at). No camelCase aliasing of backend fields.

### Centralized Constants
Nothing is hardcoded anywhere. Every string, endpoint path, error message, permission key, and status label lives in a dedicated constant file.

### Cubit Layer Rules
- Toast and snackbar triggers live inside Cubits — never in UI Pages
- No hardcoded strings in Cubits
- Third-party SDK calls (Google Sign-In, Firebase) live in Repositories, not Cubits
- No navigation from Cubits or Repositories

### Loading State Rules
- Button-level async: thin circular indicator inside the button itself
- Page or widget-level: shimmer placeholder exactly sized to the upcoming widget

---

## 8. Current Development State

| Area | Status |
|---|---|
| Database schema | Complete — all 7 modules fully defined (1,194 lines, ~50 tables) |
| API type definitions | Complete — all domains have .type.ts files |
| API route registration | Placeholder only — all routes commented out in src/routes/index.ts |
| API feature implementations | Not yet implemented — no repo/service/controller files present |
| Mobile staff app features | Folder skeletons present for all 7 modules |
| Customer app features | Folder skeletons present for auth, home, order, store, setting |
| Real-time (Socket.IO) | Manager initialized at server start |
| Firebase / Messaging | Infrastructure present |

The project is at a schema-complete, infrastructure-ready stage. The database is fully designed and the mobile feature skeletons exist. The next phase is implementing the API repositories, services, controllers, and routes feature-by-feature, followed by wiring the mobile repos and cubits to the live endpoints.

---

## 9. Tech Stack Summary

```
+-------------------------------------------------------+
|  Customer App (Flutter/Dart)   Staff App (Flutter/Dart)|
|        apps/user                    apps/mobile        |
|  Cubit | Dio | GetIt | dartz | google_sign_in          |
+-------------------------+-----------------------------+
                          | REST + WebSocket
+-------------------------v-----------------------------+
|              API (Node.js / Express 5)                |
|                    apps/api                           |
|  TypeScript 6 | Prisma 7 | Socket.IO | Firebase Admin |
|  Zod | JWT | Helmet | Winston | Cloudinary            |
+-------------------------+-----------------------------+
                          |
+-------------------------v-----------------------------+
|                   PostgreSQL                          |
|     7 Modules | ~50 tables | Prisma ORM               |
+-------------------------------------------------------+
```
