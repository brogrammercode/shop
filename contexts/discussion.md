# Comprehensive System Blueprint: Models, Types, and Real-World Use Cases

_(Sweet Shop, Bakery, Restaurant & Fast Food ERP)_

This document outlines the entire lifecycle of a large-scale F&B business. It details exactly how every database model interacts during real-world use cases, followed by a complete chart of all proposed database models, their fields, and data types.

---

## PART 1: Real-World Use Cases & Model Involvement

To understand the system, let's walk through the lifecycle of the business step-by-step.

### Use Case 1: Investing in the Business (Buying Machinery)

**Scenario:** You purchase a $10,000 Industrial Oven from "Kitchen Equip Co."

- **Model Involvement:**
  - **`Supplier`**: You create/select the vendor "Kitchen Equip Co".
  - **`PurchaseInvoice`**: You record the $10,000 bill from the supplier.
  - **`FixedAsset`**: You register the "Industrial Oven" into the system to track its depreciation over time.
  - **`LedgerEntry` & `Account`**: The system creates a double-entry accounting record. It debits your "Machinery & Equipment" (Asset Account) by $10,000 and credits your "Accounts Payable" (Liability Account) by $10,000.

### Use Case 2: Sourcing Raw Materials

**Scenario:** You order 100 Kg of Sugar and 50 Kg of Cashews.

- **Model Involvement:**
  - **`Item` & `ItemVariant`**: The system recognizes "Sugar" and "Cashews" as `RAW_MATERIAL` items.
  - **`PurchaseOrder (PO)` & `PurchaseOrderItem`**: You draft a PO for the exact quantities and send it to your supplier.
  - **`GoodsReceiptNote (GRN)`**: When the truck arrives, you log the receipt of the goods.
  - **`StockLedger`**: The moment the GRN is approved, the ledger automatically injects +100 Kg of Sugar and +50 Kg of Cashews into your `Warehouse`.
  - **`PurchaseInvoice` & `LedgerEntry`**: The financial liability to the vendor is logged.

### Use Case 3: Manufacturing (The Sweet Shop/Bakery Production)

**Scenario:** The kitchen needs to prepare 10 Kg of Kaju Katli (Cashew Fudge).

- **Model Involvement:**
  - **`BillOfMaterial (BOM)` & `BOMItem`**: The system pulls the master recipe. It knows that to yield 10 Kg of Kaju Katli, it needs 8 Kg of Cashews and 3 Kg of Sugar.
  - **`ProductionBatch`**: The kitchen starts Batch #B-1001.
  - **`StockLedger` (Consumption)**: The system automatically logs a deduction of -8 Kg of Cashews and -3 Kg of Sugar from inventory.
  - **`StockLedger` (Yield)**: Once the batch is marked `COMPLETED`, the system injects +10 Kg of "Kaju Katli" (`FINISHED_GOOD`) into the display counter inventory.

### Use Case 4: Front-of-House Sales & Order Execution

**Scenario:** A customer sits at Table 4 and orders a 500g Box of Kaju Katli and a Combo Meal (Burger + Coke).

- **Model Involvement:**
  - **`Table` & `TableZone`**: The waiter opens a ticket on Table 4 in the "Main Dining" zone.
  - **`Order` & `OrderItem`**: The order is logged.
  - **`MenuCategory` & `MenuItem`**: The POS queries the menu to get the current price of the 500g Box and the Combo.
  - **`ComboMeal` & `ComboItem`**: The system breaks down the combo into its individual components (1 Burger, 1 Coke) for inventory tracking.
  - **`KitchenOrderTicket (KOT)`**: Two KOTs are generated. The Sweets KOT routes to the front counter. The Burger/Fries KOT routes to the Hot Kitchen printer.
  - **`Customer` & `LoyaltyTransaction`**: The customer pays the bill, earning 50 loyalty points.
  - **`StockLedger` (Sales Deduction)**: The system deducts -500g of Kaju Katli, -1 Burger Patty, -1 Burger Bun, and -1 Coke Can.
  - **`LedgerEntry`**: Revenue is credited, Cash/Bank is debited.

### Use Case 5: End of Day Wastage

**Scenario:** 5 loaves of bread expired and must be thrown away.

- **Model Involvement:**
  - **`WastageLog`**: The manager logs 5 loaves of bread under the reason "EXPIRED".
  - **`StockLedger`**: The inventory is reduced by -5 loaves.
  - **`LedgerEntry`**: The financial system logs a "Wastage Expense", reducing your calculated net profit for the day.

---

## PART 2: Comprehensive Database Schema Charts

Below is the required schema detailing the models, their fields, and strict data types needed to support the above use cases.

### 1. Inventory & Production Domain

| Model               | Field Name          | Data Type     | Description / Relations                                          |
| ------------------- | ------------------- | ------------- | ---------------------------------------------------------------- |
| **Item**            | `id`                | String (UUID) | Primary Key                                                      |
|                     | `name`              | String        | e.g., "Sugar", "Kaju Katli", "Oven"                              |
|                     | `item_type`         | Enum          | `RAW_MATERIAL`, `SEMI_FINISHED`, `FINISHED_GOOD`, `ASSET`        |
|                     | `category_id`       | String        | FK to `ItemCategory`                                             |
|                     | `shelf_life_days`   | Int           | Expiry tracking                                                  |
| **UnitOfMeasure**   | `id`                | String (UUID) | Primary Key                                                      |
|                     | `code`              | String        | e.g., "KG", "GM", "BOX", "PCS"                                   |
| **UOMConversion**   | `id`                | String (UUID) | Primary Key                                                      |
|                     | `from_uom_id`       | String        | FK to `UnitOfMeasure` (e.g., BOX)                                |
|                     | `to_uom_id`         | String        | FK to `UnitOfMeasure` (e.g., GM)                                 |
|                     | `factor`            | Float         | Multiplier (e.g., 500)                                           |
| **ItemVariant**     | `id`                | String (UUID) | Primary Key                                                      |
|                     | `item_id`           | String        | FK to `Item`                                                     |
|                     | `sku`               | String        | Unique identifier                                                |
|                     | `uom_id`            | String        | Default stocked UOM                                              |
|                     | `base_cost`         | Float         | Weighted average cost of goods                                   |
| **BillOfMaterial**  | `id`                | String (UUID) | Primary Key                                                      |
|                     | `output_variant_id` | String        | FK to `ItemVariant` (The finished product)                       |
|                     | `yield_quantity`    | Float         | e.g., 10 (Kg)                                                    |
| **BOMItem**         | `id`                | String (UUID) | Primary Key                                                      |
|                     | `bom_id`            | String        | FK to `BillOfMaterial`                                           |
|                     | `input_variant_id`  | String        | FK to `ItemVariant` (The ingredient)                             |
|                     | `quantity`          | Float         | Amount needed                                                    |
| **ProductionBatch** | `id`                | String (UUID) | Primary Key                                                      |
|                     | `bom_id`            | String        | FK to `BillOfMaterial`                                           |
|                     | `status`            | Enum          | `PLANNED`, `IN_PROGRESS`, `COMPLETED`                            |
|                     | `produced_qty`      | Float         | Actual yield achieved                                            |
| **StockLedger**     | `id`                | String (UUID) | Primary Key                                                      |
|                     | `variant_id`        | String        | FK to `ItemVariant`                                              |
|                     | `branch_id`         | String        | FK to `Branch`                                                   |
|                     | `transaction_type`  | Enum          | `PURCHASE`, `SALE`, `PRODUCTION_IN`, `PRODUCTION_OUT`, `WASTAGE` |
|                     | `quantity_change`   | Float         | Positive (inward) or Negative (outward)                          |
|                     | `running_balance`   | Float         | Stock level after this transaction                               |

### 2. Supply Chain & Purchasing Domain

| Model             | Field Name      | Data Type     | Description / Relations     |
| ----------------- | --------------- | ------------- | --------------------------- |
| **Supplier**      | `id`            | String (UUID) | Primary Key                 |
|                   | `name`          | String        | Vendor Name                 |
|                   | `tax_number`    | String        | e.g., GSTIN                 |
| **PurchaseOrder** | `id`            | String (UUID) | Primary Key                 |
|                   | `supplier_id`   | String        | FK to `Supplier`            |
|                   | `status`        | Enum          | `DRAFT`, `SENT`, `RECEIVED` |
|                   | `total_amount`  | Float         | Total expected PO value     |
| **PO_Item**       | `id`            | String (UUID) | Primary Key                 |
|                   | `po_id`         | String        | FK to `PurchaseOrder`       |
|                   | `variant_id`    | String        | FK to `ItemVariant`         |
|                   | `qty_ordered`   | Float         | Quantity requested          |
| **GoodsReceipt**  | `id`            | String (UUID) | Primary Key                 |
|                   | `po_id`         | String        | FK to `PurchaseOrder`       |
|                   | `received_date` | DateTime      | When goods hit the floor    |

### 3. Financials & Investments Domain

| Model           | Field Name         | Data Type     | Description / Relations                              |
| --------------- | ------------------ | ------------- | ---------------------------------------------------- |
| **Account**     | `id`               | String (UUID) | Primary Key                                          |
|                 | `name`             | String        | e.g., "Cash", "Machinery"                            |
|                 | `account_type`     | Enum          | `ASSET`, `LIABILITY`, `EQUITY`, `REVENUE`, `EXPENSE` |
| **LedgerEntry** | `id`               | String (UUID) | Primary Key                                          |
|                 | `account_id`       | String        | FK to `Account`                                      |
|                 | `debit`            | Float         | Debit amount                                         |
|                 | `credit`           | Float         | Credit amount                                        |
|                 | `reference_type`   | String        | e.g., "Invoice", "Order"                             |
|                 | `reference_id`     | String        | ID of the source document                            |
| **FixedAsset**  | `id`               | String (UUID) | Primary Key                                          |
|                 | `name`             | String        | e.g., "Oven Model X"                                 |
|                 | `purchase_value`   | Float         | Initial investment cost                              |
|                 | `depreciation_pct` | Float         | Yearly depreciation rate                             |

### 4. Sales & Menu Catalog Domain

| Model             | Field Name      | Data Type     | Description / Relations                                  |
| ----------------- | --------------- | ------------- | -------------------------------------------------------- |
| **MenuItem**      | `id`            | String (UUID) | Primary Key                                              |
|                   | `variant_id`    | String        | FK to `ItemVariant` (Connects menu to inventory)         |
|                   | `display_name`  | String        | Customer facing name                                     |
|                   | `selling_price` | Float         | POS Price                                                |
| **ModifierGroup** | `id`            | String (UUID) | Primary Key                                              |
|                   | `name`          | String        | e.g., "Crust Types", "Extra Toppings"                    |
|                   | `min_select`    | Int           | e.g., 1 (Mandatory selection)                            |
|                   | `max_select`    | Int           | e.g., 3                                                  |
| **Modifier**      | `id`            | String (UUID) | Primary Key                                              |
|                   | `group_id`      | String        | FK to `ModifierGroup`                                    |
|                   | `variant_id`    | String        | FK to `ItemVariant` (If it consumes stock, e.g., Cheese) |
|                   | `extra_price`   | Float         | Add-on cost                                              |
| **ComboMeal**     | `id`            | String (UUID) | Primary Key                                              |
|                   | `name`          | String        | e.g., "Burger Meal"                                      |
|                   | `fixed_price`   | Float         | Overrides individual item prices                         |
| **ComboItem**     | `id`            | String (UUID) | Primary Key                                              |
|                   | `combo_id`      | String        | FK to `ComboMeal`                                        |
|                   | `menu_item_id`  | String        | FK to `MenuItem`                                         |

### 5. Order Execution & KDS Domain

| Model         | Field Name     | Data Type     | Description / Relations                          |
| ------------- | -------------- | ------------- | ------------------------------------------------ |
| **Table**     | `id`           | String (UUID) | Primary Key                                      |
|               | `table_number` | String        | e.g., "T-04"                                     |
|               | `capacity`     | Int           | Max seating                                      |
|               | `status`       | Enum          | `AVAILABLE`, `OCCUPIED`, `CLEANING`              |
| **Order**     | `id`           | String (UUID) | Primary Key                                      |
|               | `table_id`     | String        | FK to `Table` (Nullable for Takeaway)            |
|               | `status`       | Enum          | `OPEN`, `BILLED`, `PAID`, `CANCELLED`            |
|               | `total_amount` | Float         | Grand Total                                      |
| **OrderItem** | `id`           | String (UUID) | Primary Key                                      |
|               | `order_id`     | String        | FK to `Order`                                    |
|               | `menu_item_id` | String        | FK to `MenuItem`                                 |
|               | `qty`          | Float         | Can be decimal for weight (e.g., 0.5 Kg)         |
|               | `price`        | Float         | Sold at price                                    |
| **KOT**       | `id`           | String (UUID) | Primary Key (Kitchen Order Ticket)               |
|               | `order_id`     | String        | FK to `Order`                                    |
|               | `station`      | Enum          | `HOT_FOOD`, `BAKERY`, `DRINKS`, `SWEETS_COUNTER` |
|               | `status`       | Enum          | `PREPARING`, `READY`, `SERVED`                   |

### 6. CRM & Loyalty Domain

| Model            | Field Name       | Data Type     | Description / Relations                  |
| ---------------- | ---------------- | ------------- | ---------------------------------------- |
| **Customer**     | `id`             | String (UUID) | Primary Key                              |
|                  | `phone`          | String        | Unique identifier for loyalty            |
|                  | `name`           | String        | Customer Name                            |
|                  | `points_balance` | Int           | Current available loyalty points         |
| **LoyaltyTrans** | `id`             | String (UUID) | Primary Key                              |
|                  | `customer_id`    | String        | FK to `Customer`                         |
|                  | `order_id`       | String        | FK to `Order`                            |
|                  | `points`         | Int           | Positive (earned) or Negative (redeemed) |
| **Coupon**       | `id`             | String (UUID) | Primary Key                              |
|                  | `code`           | String        | e.g., "SUMMER20"                         |
|                  | `discount_pct`   | Float         | e.g., 20.0                               |
|                  | `min_order_val`  | Float         | e.g., 500.0                              |

---

## EXTRA : Advanced Operations, Edge Cases & Squeezed F&B Features

### Use Case 6: Third-Party Delivery Aggregator (Swiggy / Zomato / UberEats)

**Scenario:** A customer orders a pizza via Zomato. Zomato takes a 20% commission on the sale.

- **Model Involvement:**
  - **`DeliveryPartner`**: The system identifies the order source as Zomato.
  - **`Order` & `OrderItem`**: The order is injected directly into the POS system via API, bypassing the cashier.
  - **`KOT`**: The ticket prints automatically in the kitchen so chefs can start preparing immediately.
  - **`LedgerEntry`**: The financial system records the revenue, but also automatically calculates and logs the 20% commission fee to Zomato as an "Aggregator Expense" so your profit margins remain accurate.

### Use Case 7: End-of-Day (EOD) Till Reconciliation & Cash Management

**Scenario:** The cashier closes their shift at 10 PM and counts the cash in the drawer.

- **Model Involvement:**
  - **`Shift` & `Employee`**: The cashier initiates a "Shift Close" action.
  - **`CashRegister`**: The system expects $500 in the drawer based on the day's cash sales.
  - **`LedgerEntry`**: The cashier counts $490 and enters the actual amount. The system logs a $10 "Cash Shortage Expense" to keep the accounting perfectly balanced.

### Use Case 8: Inter-Branch Stock Transfer (Hub & Spoke Model)

**Scenario:** The Central Kitchen bakes 500 cupcakes and sends 100 to Branch A and 100 to Branch B.

- **Model Involvement:**
  - **`StockTransfer` & `StockTransferItem`**: The Central Kitchen manager creates a transfer document for 200 cupcakes.
  - **`StockLedger` (Central)**: -200 cupcakes are immediately deducted from the Central Kitchen's inventory.
  - **`StockLedger` (Branch)**: Once the delivery truck arrives at Branch A, the manager accepts the transfer, injecting +100 cupcakes into their specific branch inventory.

### Use Case 9: Custom Celebration Cake Pre-Order & Advance Payment

**Scenario:** A customer pre-orders a 3-tier wedding cake for next month and pays a 50% deposit upfront.

- **Model Involvement:**
  - **`Order`**: An order is created with a future `fulfillment_date`.
  - **`AdvancePayment`**: The 50% deposit is recorded.
  - **`LedgerEntry`**: The deposit is marked as "Unearned Revenue" (a liability) because you haven't delivered the cake yet. (Crucial for GAAP accounting).
  - **`ProductionBatch`**: A reminder/task is scheduled for the bakery to manufacture the cake exactly 1 day before the fulfillment date.

### Use Case 10: Franchise Royalty & Brand Management

**Scenario:** A franchisee opens a new sweet shop branch and owes a 5% royalty on all net sales to headquarters.

- **Model Involvement:**
  - **`Franchise`**: The new branch is tagged under a specific franchise agreement.
  - **`Order`**: Sales happen normally over the month.
  - **`RoyaltyTransaction`**: At month-end, the system calculates 5% of net sales and generates a royalty invoice automatically.
  - **`LedgerEntry`**: Logs the franchise revenue for HQ and the royalty expense for the franchisee.

### Use Case 11: Food Safety & Quality Control (QC)

**Scenario:** The health inspector requires daily temperature logs for cold storage and batch tasting notes for sweets.

- **Model Involvement:**
  - **`QCAudit`**: An employee logs the 9:00 AM fridge temperature (e.g., 4°C).
  - **`ProductionBatch`**: The head chef tastes Batch #B-1001 of Kaju Katli and logs a QC status of "APPROVED" or "REJECTED (Too sweet)". This prevents rejected batches from entering the `StockLedger` as saleable goods.

### Use Case 12: Purchase Returns (RTV - Return to Vendor)

**Scenario:** 50 Kg of the sugar delivered by the vendor is wet and needs to be sent back.

- **Model Involvement:**
  - **`VendorReturn` (RTV)**: A return document is created linked to the original `PurchaseOrder`.
  - **`StockLedger`**: Deducts -50 Kg of sugar from the warehouse to ensure it's not used in production.
  - **`LedgerEntry`**: Creates a Debit Note, reducing the Accounts Payable (you no longer owe the supplier for the wet sugar).

### Use Case 13: Customer Complaints & Resolution

**Scenario:** A customer complains that their order of 250g sweets was stale.

- **Model Involvement:**
  - **`CustomerComplaint`**: A ticket is opened and linked directly to the `Order` ID and the specific `ProductionBatch` that the sweets came from.
  - **`Customer` & `LoyaltyTrans`**: The manager resolves the issue by issuing an apology and injecting 500 apology loyalty points into the customer's wallet to retain their business.

### Use Case 14: Employee Timeclock & Payroll Processing

**Scenario:** A delivery rider and a line cook clock in for the day, and wages are calculated.

- **Model Involvement:**
  - **`Employee`**: The profiles of the staff.
  - **`TimeLog`**: The system records exactly when they clocked in and out (e.g., 8:00 AM to 4:00 PM).
  - **`LedgerEntry`**: Based on their hourly rate, the total wage is calculated and logged as an Accrued Payroll Expense.

---

## NEW SCHEMA (The Complete Prisma Blueprint)

Below is the completely rewritten Prisma schema required to bring all the above modules and use cases to life. The schema is built to be highly **Branch-oriented** (for massive hub-and-spoke franchise setups) and **Menu-oriented** (for complex F&B POS requirements). Every entity is heavily enriched with metadata (`created_at`, `created_by`, `status`, etc.) and tied strictly to `branch_id`.

```prisma
// ==========================================
// MODULE 1: CORE / AUTH / HR / SETUP
// ==========================================

model Branch {
  id             String         @id @default(cuid())
  name           String
  code           String         @unique
  address        String
  is_hq          Boolean        @default(false)
  status         BranchStatus   @default(ACTIVE)

  created_at     DateTime       @default(now())
  updated_at     DateTime       @updatedAt
  created_by     String?
  updated_by     String?
  is_deleted     Boolean        @default(false)

  // System Hub Relations
  franchise      Franchise?
  employees      Employee[]
  shifts         Shift[]
  time_logs      TimeLog[]
  cash_registers CashRegister[]

  menu_categories MenuCategory[]
  menu_items      MenuItem[]
  modifiers       Modifier[]
  combo_meals     ComboMeal[]

  items           Item[]
  suppliers       Supplier[]
  purchase_orders PurchaseOrder[]
  stock_ledgers   StockLedger[]
  stock_out       StockTransfer[] @relation("TransferOut")
  stock_in        StockTransfer[] @relation("TransferIn")

  bom             BillOfMaterial[]
  production      ProductionBatch[]

  table_zones     TableZone[]
  orders          Order[]
  customers       Customer[]
  accounts        Account[]
}

enum BranchStatus {
  ACTIVE
  INACTIVE
  SUSPENDED
}

model Franchise {
  id             String         @id @default(cuid())
  branch_id      String         @unique
  owner_name     String
  royalty_pct    Float          @default(5.0)
  agreement_doc  String?

  created_at     DateTime       @default(now())
  updated_at     DateTime       @updatedAt
  is_deleted     Boolean        @default(false)

  branch         Branch         @relation(fields: [branch_id], references: [id])
  royalties      RoyaltyTrans[]
}

model Employee {
  id             String         @id @default(cuid())
  branch_id      String
  name           String
  phone          String         @unique
  email          String?        @unique
  role           EmployeeRole
  hourly_rate    Float?
  status         EmployeeStatus @default(ACTIVE)

  created_at     DateTime       @default(now())
  updated_at     DateTime       @updatedAt
  is_deleted     Boolean        @default(false)

  branch         Branch         @relation(fields: [branch_id], references: [id])
  shifts         Shift[]
  time_logs      TimeLog[]
  orders_handled Order[]
}

enum EmployeeRole {
  MANAGER
  CASHIER
  CHEF
  RIDER
  ADMIN
}

enum EmployeeStatus {
  ACTIVE
  ON_LEAVE
  TERMINATED
}

model Shift {
  id             String         @id @default(cuid())
  branch_id      String
  employee_id    String
  start_time     DateTime
  end_time       DateTime?
  status         ShiftStatus    @default(ACTIVE)
  notes          String?

  created_at     DateTime       @default(now())

  branch         Branch         @relation(fields: [branch_id], references: [id])
  employee       Employee       @relation(fields: [employee_id], references: [id])
}

enum ShiftStatus {
  ACTIVE
  CLOSED
}

model TimeLog {
  id             String         @id @default(cuid())
  branch_id      String
  employee_id    String
  clock_in       DateTime
  clock_out      DateTime?
  total_hours    Float?

  created_at     DateTime       @default(now())

  branch         Branch         @relation(fields: [branch_id], references: [id])
  employee       Employee       @relation(fields: [employee_id], references: [id])
}

model CashRegister {
  id             String         @id @default(cuid())
  branch_id      String
  register_name  String
  mac_address    String?
  expected_cash  Float          @default(0)
  actual_cash    Float?
  status         RegisterStatus @default(OPEN)

  created_at     DateTime       @default(now())
  updated_at     DateTime       @updatedAt
  opened_by      String?
  closed_by      String?

  branch         Branch         @relation(fields: [branch_id], references: [id])
}

enum RegisterStatus {
  OPEN
  CLOSED
}

// ==========================================
// MODULE 2: MENU / CATALOG (POS Front-End)
// ==========================================

model MenuCategory {
  id             String         @id @default(cuid())
  branch_id      String
  name           String
  description    String?
  display_order  Int            @default(0)
  status         EntityStatus   @default(ACTIVE)

  created_at     DateTime       @default(now())
  updated_at     DateTime       @updatedAt
  is_deleted     Boolean        @default(false)

  branch         Branch         @relation(fields: [branch_id], references: [id])
  items          MenuItem[]
}

enum EntityStatus {
  ACTIVE
  INACTIVE
}

model MenuItem {
  id             String         @id @default(cuid())
  branch_id      String
  category_id    String
  variant_id     String         // Links to Inventory
  display_name   String
  description    String?
  selling_price  Float
  image_url      String?
  status         EntityStatus   @default(ACTIVE)

  created_at     DateTime       @default(now())
  updated_at     DateTime       @updatedAt
  created_by     String?
  is_deleted     Boolean        @default(false)

  branch         Branch         @relation(fields: [branch_id], references: [id])
  category       MenuCategory   @relation(fields: [category_id], references: [id])
  variant        ItemVariant    @relation(fields: [variant_id], references: [id])

  order_items    OrderItem[]
  combo_items    ComboItem[]
}

model ModifierGroup {
  id             String         @id @default(cuid())
  branch_id      String
  name           String
  min_select     Int            @default(0)
  max_select     Int            @default(1)
  status         EntityStatus   @default(ACTIVE)

  created_at     DateTime       @default(now())
  updated_at     DateTime       @updatedAt
  is_deleted     Boolean        @default(false)

  modifiers      Modifier[]
}

model Modifier {
  id             String         @id @default(cuid())
  branch_id      String
  group_id       String
  variant_id     String?        // Links to Inventory (e.g. Cheese)
  name           String
  extra_price    Float          @default(0)
  status         EntityStatus   @default(ACTIVE)

  created_at     DateTime       @default(now())
  updated_at     DateTime       @updatedAt
  is_deleted     Boolean        @default(false)

  branch         Branch         @relation(fields: [branch_id], references: [id])
  group          ModifierGroup  @relation(fields: [group_id], references: [id])
  variant        ItemVariant?   @relation(fields: [variant_id], references: [id])
}

model ComboMeal {
  id             String         @id @default(cuid())
  branch_id      String
  name           String
  fixed_price    Float
  image_url      String?
  status         EntityStatus   @default(ACTIVE)

  created_at     DateTime       @default(now())
  updated_at     DateTime       @updatedAt
  is_deleted     Boolean        @default(false)

  branch         Branch         @relation(fields: [branch_id], references: [id])
  items          ComboItem[]
}

model ComboItem {
  id             String         @id @default(cuid())
  combo_id       String
  menu_item_id   String
  qty_included   Float          @default(1)

  created_at     DateTime       @default(now())

  combo          ComboMeal      @relation(fields: [combo_id], references: [id])
  menu_item      MenuItem       @relation(fields: [menu_item_id], references: [id])
}

// ==========================================
// MODULE 3: INVENTORY / SUPPLY CHAIN (Back-End)
// ==========================================

model ItemCategory {
  id             String         @id @default(cuid())
  branch_id      String
  name           String
  description    String?

  created_at     DateTime       @default(now())
  updated_at     DateTime       @updatedAt
  is_deleted     Boolean        @default(false)

  items          Item[]
}

model Item {
  id             String         @id @default(cuid())
  branch_id      String
  category_id    String
  name           String
  item_type      ItemType
  shelf_life_days Int?
  status         EntityStatus   @default(ACTIVE)

  created_at     DateTime       @default(now())
  updated_at     DateTime       @updatedAt
  is_deleted     Boolean        @default(false)

  branch         Branch         @relation(fields: [branch_id], references: [id])
  category       ItemCategory   @relation(fields: [category_id], references: [id])
  variants       ItemVariant[]
}

enum ItemType {
  RAW_MATERIAL
  SEMI_FINISHED
  FINISHED_GOOD
  ASSET
  PACKAGING
}

model UnitOfMeasure {
  id             String         @id @default(cuid())
  branch_id      String
  code           String         // KG, GM, LTR, BOX, PCS
  description    String?

  created_at     DateTime       @default(now())
  is_deleted     Boolean        @default(false)

  variants       ItemVariant[]
  conversions_from UOMConversion[] @relation("FromUOM")
  conversions_to   UOMConversion[] @relation("ToUOM")
}

model UOMConversion {
  id             String         @id @default(cuid())
  branch_id      String
  from_uom_id    String
  to_uom_id      String
  factor         Float

  created_at     DateTime       @default(now())

  from_uom       UnitOfMeasure  @relation("FromUOM", fields: [from_uom_id], references: [id])
  to_uom         UnitOfMeasure  @relation("ToUOM", fields: [to_uom_id], references: [id])
}

model ItemVariant {
  id             String         @id @default(cuid())
  branch_id      String
  item_id        String
  uom_id         String
  sku            String         @unique
  barcode        String?
  base_cost      Float          @default(0)
  min_stock_lvl  Float          @default(0)
  status         EntityStatus   @default(ACTIVE)

  created_at     DateTime       @default(now())
  updated_at     DateTime       @updatedAt
  is_deleted     Boolean        @default(false)

  item           Item           @relation(fields: [item_id], references: [id])
  uom            UnitOfMeasure  @relation(fields: [uom_id], references: [id])

  menu_items     MenuItem[]
  modifiers      Modifier[]
  stock_ledgers  StockLedger[]
  po_items       POItem[]
  transfer_items TransferItem[]
  bom_outputs    BillOfMaterial[] // When this is the manufactured product
  bom_inputs     BOMItem[]        // When this is an ingredient
}

model Supplier {
  id             String         @id @default(cuid())
  branch_id      String
  name           String
  tax_number     String?
  contact_email  String?
  contact_phone  String?
  address        String?
  status         EntityStatus   @default(ACTIVE)

  created_at     DateTime       @default(now())
  updated_at     DateTime       @updatedAt
  is_deleted     Boolean        @default(false)

  branch         Branch         @relation(fields: [branch_id], references: [id])
  purchase_orders PurchaseOrder[]
}

model PurchaseOrder {
  id             String         @id @default(cuid())
  branch_id      String
  supplier_id    String
  status         POStatus       @default(DRAFT)
  total_amount   Float          @default(0)
  notes          String?

  created_at     DateTime       @default(now())
  updated_at     DateTime       @updatedAt
  created_by     String?
  approved_by    String?

  branch         Branch         @relation(fields: [branch_id], references: [id])
  supplier       Supplier       @relation(fields: [supplier_id], references: [id])
  items          POItem[]
  receipts       GoodsReceipt[]
  returns        VendorReturn[]
}

enum POStatus {
  DRAFT
  SENT
  PARTIALLY_RECEIVED
  RECEIVED
  CANCELLED
}

model POItem {
  id             String         @id @default(cuid())
  po_id          String
  variant_id     String
  qty_ordered    Float
  unit_price     Float
  total_price    Float

  created_at     DateTime       @default(now())

  po             PurchaseOrder  @relation(fields: [po_id], references: [id])
  variant        ItemVariant    @relation(fields: [variant_id], references: [id])
}

model GoodsReceipt {
  id             String         @id @default(cuid())
  branch_id      String
  po_id          String
  received_date  DateTime       @default(now())
  invoice_number String?
  notes          String?

  created_at     DateTime       @default(now())
  updated_at     DateTime       @updatedAt
  received_by    String?

  po             PurchaseOrder  @relation(fields: [po_id], references: [id])
}

model VendorReturn {
  id             String         @id @default(cuid())
  branch_id      String
  po_id          String
  return_reason  String
  refund_value   Float
  status         ReturnStatus   @default(PENDING)

  created_at     DateTime       @default(now())
  updated_at     DateTime       @updatedAt
  processed_by   String?

  po             PurchaseOrder  @relation(fields: [po_id], references: [id])
}

enum ReturnStatus {
  PENDING
  APPROVED
  REJECTED
  REFUNDED
}

model StockLedger {
  id               String         @id @default(cuid())
  branch_id        String
  variant_id       String
  transaction_type StockTransType
  quantity_change  Float
  running_balance  Float
  reference_id     String?        // Link to PO, Order, etc.

  created_at       DateTime       @default(now())
  created_by       String?

  branch           Branch         @relation(fields: [branch_id], references: [id])
  variant          ItemVariant    @relation(fields: [variant_id], references: [id])
}

enum StockTransType {
  PURCHASE
  SALE
  PRODUCTION_IN
  PRODUCTION_OUT
  WASTAGE
  TRANSFER_IN
  TRANSFER_OUT
  RETURN
  ADJUSTMENT
}

model StockTransfer {
  id               String         @id @default(cuid())
  from_branch_id   String
  to_branch_id     String
  status           TransferStatus @default(DISPATCHED)
  driver_name      String?

  created_at       DateTime       @default(now())
  updated_at       DateTime       @updatedAt
  dispatched_by    String?
  received_by      String?

  from_branch      Branch         @relation("TransferOut", fields: [from_branch_id], references: [id])
  to_branch        Branch         @relation("TransferIn", fields: [to_branch_id], references: [id])
  items            TransferItem[]
}

enum TransferStatus {
  DRAFT
  DISPATCHED
  RECEIVED
  LOST_IN_TRANSIT
}

model TransferItem {
  id               String         @id @default(cuid())
  transfer_id      String
  variant_id       String
  quantity         Float

  created_at       DateTime       @default(now())

  transfer         StockTransfer  @relation(fields: [transfer_id], references: [id])
  variant          ItemVariant    @relation(fields: [variant_id], references: [id])
}

// ==========================================
// MODULE 4: MANUFACTURING & RECIPE
// ==========================================

model BillOfMaterial {
  id                String         @id @default(cuid())
  branch_id         String
  output_variant_id String         @unique
  yield_quantity    Float
  instructions      String?
  status            EntityStatus   @default(ACTIVE)

  created_at        DateTime       @default(now())
  updated_at        DateTime       @updatedAt
  created_by        String?
  is_deleted        Boolean        @default(false)

  branch            Branch         @relation(fields: [branch_id], references: [id])
  output_variant    ItemVariant    @relation(fields: [output_variant_id], references: [id])
  ingredients       BOMItem[]
  batches           ProductionBatch[]
}

model BOMItem {
  id                String         @id @default(cuid())
  bom_id            String
  input_variant_id  String
  quantity          Float

  created_at        DateTime       @default(now())

  bom               BillOfMaterial @relation(fields: [bom_id], references: [id])
  input_variant     ItemVariant    @relation(fields: [input_variant_id], references: [id])
}

model ProductionBatch {
  id                String         @id @default(cuid())
  branch_id         String
  bom_id            String
  status            BatchStatus    @default(PLANNED)
  planned_qty       Float
  produced_qty      Float          @default(0)
  expiry_date       DateTime?
  notes             String?

  created_at        DateTime       @default(now())
  updated_at        DateTime       @updatedAt
  started_by        String?
  completed_by      String?

  branch            Branch         @relation(fields: [branch_id], references: [id])
  bom               BillOfMaterial @relation(fields: [bom_id], references: [id])
  qc_audits         QCAudit[]
}

enum BatchStatus {
  PLANNED
  IN_PROGRESS
  COMPLETED
  CANCELLED
}

model QCAudit {
  id                String         @id @default(cuid())
  branch_id         String
  batch_id          String?
  audit_type        QCType
  result_value      String         // e.g. "APPROVED" or "4°C"
  notes             String?

  created_at        DateTime       @default(now())
  auditor_name      String?

  batch             ProductionBatch? @relation(fields: [batch_id], references: [id])
}

enum QCType {
  TEMPERATURE
  TASTE_TEST
  HYGIENE
  PACKAGING_CHECK
}

model WastageLog {
  id                String         @id @default(cuid())
  branch_id         String
  variant_id        String
  reason            String
  quantity          Float

  created_at        DateTime       @default(now())
  logged_by         String?
}

// ==========================================
// MODULE 5: ORDER / POS / KDS
// ==========================================

model TableZone {
  id                String         @id @default(cuid())
  branch_id         String
  name              String

  created_at        DateTime       @default(now())
  updated_at        DateTime       @updatedAt
  is_deleted        Boolean        @default(false)

  branch            Branch         @relation(fields: [branch_id], references: [id])
  tables            Table[]
}

model Table {
  id                String         @id @default(cuid())
  branch_id         String
  zone_id           String
  table_number      String
  capacity          Int
  status            TableStatus    @default(AVAILABLE)

  created_at        DateTime       @default(now())
  updated_at        DateTime       @updatedAt
  is_deleted        Boolean        @default(false)

  zone              TableZone      @relation(fields: [zone_id], references: [id])
  orders            Order[]
}

enum TableStatus {
  AVAILABLE
  OCCUPIED
  CLEANING
  RESERVED
}

model DeliveryPartner {
  id                String         @id @default(cuid())
  branch_id         String
  name              String
  commission_pct    Float          @default(0)
  status            EntityStatus   @default(ACTIVE)

  created_at        DateTime       @default(now())
  updated_at        DateTime       @updatedAt
  is_deleted        Boolean        @default(false)

  orders            Order[]
}

model Order {
  id                String         @id @default(cuid())
  branch_id         String
  table_id          String?
  customer_id       String?
  employee_id       String?
  partner_id        String?
  order_type        OrderType
  status            OrderStatus    @default(OPEN)
  subtotal          Float          @default(0)
  tax_amount        Float          @default(0)
  discount_amount   Float          @default(0)
  total_amount      Float          @default(0)
  fulfillment_date  DateTime?
  notes             String?

  created_at        DateTime       @default(now())
  updated_at        DateTime       @updatedAt

  branch            Branch         @relation(fields: [branch_id], references: [id])
  table             Table?         @relation(fields: [table_id], references: [id])
  customer          Customer?      @relation(fields: [customer_id], references: [id])
  employee          Employee?      @relation(fields: [employee_id], references: [id])
  partner           DeliveryPartner? @relation(fields: [partner_id], references: [id])

  items             OrderItem[]
  kots              KitchenOrderTicket[]
  advance_payments  AdvancePayment[]
  loyalty_trans     LoyaltyTrans[]
  complaints        Complaint[]
}

enum OrderType {
  DINE_IN
  TAKEAWAY
  DELIVERY
  AGGREGATOR
  PRE_ORDER
}

enum OrderStatus {
  OPEN
  BILLED
  PAID
  CANCELLED
  REFUNDED
}

model OrderItem {
  id                String         @id @default(cuid())
  branch_id         String
  order_id          String
  menu_item_id      String
  qty               Float
  unit_price        Float
  total_price       Float
  notes             String?

  created_at        DateTime       @default(now())

  order             Order          @relation(fields: [order_id], references: [id])
  menu_item         MenuItem       @relation(fields: [menu_item_id], references: [id])
}

model KitchenOrderTicket {
  id                String         @id @default(cuid())
  branch_id         String
  order_id          String
  station           KOTStation
  status            KOTStatus      @default(PREPARING)
  print_count       Int            @default(0)

  created_at        DateTime       @default(now())
  updated_at        DateTime       @updatedAt

  order             Order          @relation(fields: [order_id], references: [id])
}

enum KOTStation {
  HOT_FOOD
  BAKERY
  DRINKS
  SWEETS_COUNTER
  PACKAGING
}

enum KOTStatus {
  PREPARING
  READY
  SERVED
  CANCELLED
}

model AdvancePayment {
  id                String         @id @default(cuid())
  branch_id         String
  order_id          String
  amount_paid       Float
  payment_method    PayMethod
  transaction_ref   String?

  created_at        DateTime       @default(now())
  processed_by      String?

  order             Order          @relation(fields: [order_id], references: [id])
}

enum PayMethod {
  CASH
  CARD
  ONLINE
  WALLET
  LOYALTY_POINTS
}

// ==========================================
// MODULE 6: CRM / COMPLAINTS
// ==========================================

model Customer {
  id                String         @id @default(cuid())
  branch_id         String         // Registered at this branch, though global loyalty possible
  phone             String         @unique
  name              String
  email             String?
  points_balance    Int            @default(0)
  status            EntityStatus   @default(ACTIVE)

  created_at        DateTime       @default(now())
  updated_at        DateTime       @updatedAt
  is_deleted        Boolean        @default(false)

  branch            Branch         @relation(fields: [branch_id], references: [id])
  orders            Order[]
  loyalty_trans     LoyaltyTrans[]
  complaints        Complaint[]
}

model LoyaltyTrans {
  id                String         @id @default(cuid())
  branch_id         String
  customer_id       String
  order_id          String?
  points            Int
  trans_type        LoyaltyTransType

  created_at        DateTime       @default(now())
  created_by        String?

  customer          Customer       @relation(fields: [customer_id], references: [id])
  order             Order?         @relation(fields: [order_id], references: [id])
}

enum LoyaltyTransType {
  EARNED
  REDEEMED
  REFUNDED
  BONUS
}

model Coupon {
  id                String         @id @default(cuid())
  branch_id         String
  code              String         @unique
  discount_pct      Float
  min_order_val     Float          @default(0)
  max_discount      Float?
  valid_until       DateTime?
  status            EntityStatus   @default(ACTIVE)

  created_at        DateTime       @default(now())
  updated_at        DateTime       @updatedAt
  is_deleted        Boolean        @default(false)
}

model Complaint {
  id                String         @id @default(cuid())
  branch_id         String
  customer_id       String
  order_id          String
  subject           String
  description       String?
  status            ComplaintStatus @default(OPEN)

  created_at        DateTime       @default(now())
  updated_at        DateTime       @updatedAt
  resolved_by       String?
  resolution_notes  String?

  customer          Customer       @relation(fields: [customer_id], references: [id])
  order             Order          @relation(fields: [order_id], references: [id])
}

enum ComplaintStatus {
  OPEN
  IN_PROGRESS
  RESOLVED
  REFUNDED
}

// ==========================================
// MODULE 7: FINANCE / ACCOUNTING
// ==========================================

model Account {
  id                String         @id @default(cuid())
  branch_id         String
  name              String
  account_type      AccountType
  status            EntityStatus   @default(ACTIVE)

  created_at        DateTime       @default(now())
  updated_at        DateTime       @updatedAt
  is_deleted        Boolean        @default(false)

  branch            Branch         @relation(fields: [branch_id], references: [id])
  ledger_entries    LedgerEntry[]
}

enum AccountType {
  ASSET
  LIABILITY
  EQUITY
  REVENUE
  EXPENSE
}

model LedgerEntry {
  id                String         @id @default(cuid())
  branch_id         String
  account_id        String
  debit             Float          @default(0)
  credit            Float          @default(0)
  reference_type    String
  reference_id      String
  notes             String?

  created_at        DateTime       @default(now())
  created_by        String?

  account           Account        @relation(fields: [account_id], references: [id])
}

model FixedAsset {
  id                String         @id @default(cuid())
  branch_id         String
  name              String
  purchase_value    Float
  depreciation_pct  Float
  status            AssetStatus    @default(ACTIVE)

  created_at        DateTime       @default(now())
  updated_at        DateTime       @updatedAt
  is_deleted        Boolean        @default(false)
}

enum AssetStatus {
  ACTIVE
  IN_REPAIR
  SOLD
  SCRAPPED
}

model RoyaltyTrans {
  id                String         @id @default(cuid())
  branch_id         String
  franchise_id      String
  calculated_amt    Float
  status            RoyaltyStatus  @default(PENDING)

  created_at        DateTime       @default(now())
  updated_at        DateTime       @updatedAt

  franchise         Franchise      @relation(fields: [franchise_id], references: [id])
}

enum RoyaltyStatus {
  PENDING
  INVOICED
  PAID
}
```

## NEW FILES AND FOLDER STRUCTURE

Based on the existing codebase style, the architecture strictly follows a **Feature-Based Domain-Driven Design (DDD)**.

### API Codebase (`apps/api/src/features`)

The backend uses a completely flat structure inside each feature folder. For the new ERP system, we will create 7 distinct feature domains.

**1. `core_hr`**

- `apps/api/src/features/core_hr/core.constant.ts`
- `apps/api/src/features/core_hr/core.controller.ts`
- `apps/api/src/features/core_hr/core.middleware.ts`
- `apps/api/src/features/core_hr/core.route.ts`
- `apps/api/src/features/core_hr/core.service.ts`
- `apps/api/src/features/core_hr/core.repo.ts`
- `apps/api/src/features/core_hr/core.type.ts`

**2. `catalog`**

- `apps/api/src/features/catalog/catalog.constant.ts`
- `apps/api/src/features/catalog/catalog.controller.ts`
- `apps/api/src/features/catalog/catalog.middleware.ts`
- `apps/api/src/features/catalog/catalog.route.ts`
- `apps/api/src/features/catalog/catalog.service.ts`
- `apps/api/src/features/catalog/catalog.repo.ts`
- `apps/api/src/features/catalog/catalog.type.ts`

**3. `inventory`**

- `apps/api/src/features/inventory/inventory.constant.ts`
- `apps/api/src/features/inventory/inventory.controller.ts`
- `apps/api/src/features/inventory/inventory.middleware.ts`
- `apps/api/src/features/inventory/inventory.route.ts`
- `apps/api/src/features/inventory/inventory.service.ts`
- `apps/api/src/features/inventory/inventory.repo.ts`
- `apps/api/src/features/inventory/inventory.type.ts`

**4. `manufacturing`**

- `apps/api/src/features/manufacturing/manufacturing.constant.ts`
- `apps/api/src/features/manufacturing/manufacturing.controller.ts`
- `apps/api/src/features/manufacturing/manufacturing.middleware.ts`
- `apps/api/src/features/manufacturing/manufacturing.route.ts`
- `apps/api/src/features/manufacturing/manufacturing.service.ts`
- `apps/api/src/features/manufacturing/manufacturing.repo.ts`
- `apps/api/src/features/manufacturing/manufacturing.type.ts`

**5. `pos_kds`**

- `apps/api/src/features/pos_kds/pos_kds.constant.ts`
- `apps/api/src/features/pos_kds/pos_kds.controller.ts`
- `apps/api/src/features/pos_kds/pos_kds.middleware.ts`
- `apps/api/src/features/pos_kds/pos_kds.route.ts`
- `apps/api/src/features/pos_kds/pos_kds.service.ts`
- `apps/api/src/features/pos_kds/pos_kds.repo.ts`
- `apps/api/src/features/pos_kds/pos_kds.type.ts`

**6. `crm`**

- `apps/api/src/features/crm/crm.constant.ts`
- `apps/api/src/features/crm/crm.controller.ts`
- `apps/api/src/features/crm/crm.middleware.ts`
- `apps/api/src/features/crm/crm.route.ts`
- `apps/api/src/features/crm/crm.service.ts`
- `apps/api/src/features/crm/crm.repo.ts`
- `apps/api/src/features/crm/crm.type.ts`

**7. `finance`**

- `apps/api/src/features/finance/finance.constant.ts`
- `apps/api/src/features/finance/finance.controller.ts`
- `apps/api/src/features/finance/finance.middleware.ts`
- `apps/api/src/features/finance/finance.route.ts`
- `apps/api/src/features/finance/finance.service.ts`
- `apps/api/src/features/finance/finance.repo.ts`
- `apps/api/src/features/finance/finance.type.ts`

---

### Mobile App Codebase (`apps/mobile/lib/features`)

We will now use a **completely flat file structure** for the Flutter app as well, perfectly mirroring the DDD approach used in the API backend.

**1. `core_hr`**

- `apps/mobile/lib/features/core_hr/core_hr.constant.dart`
- `apps/mobile/lib/features/core_hr/core_hr.controller.dart`
- `apps/mobile/lib/features/core_hr/core_hr.model.dart`
- `apps/mobile/lib/features/core_hr/core_hr.page.dart`
- `apps/mobile/lib/features/core_hr/core_hr.data.dart`

**2. `catalog`**

- `apps/mobile/lib/features/catalog/catalog.constant.dart`
- `apps/mobile/lib/features/catalog/catalog.controller.dart`
- `apps/mobile/lib/features/catalog/catalog.model.dart`
- `apps/mobile/lib/features/catalog/catalog.page.dart`
- `apps/mobile/lib/features/catalog/catalog.data.dart`

**3. `inventory`**

- `apps/mobile/lib/features/inventory/inventory.constant.dart`
- `apps/mobile/lib/features/inventory/inventory.controller.dart`
- `apps/mobile/lib/features/inventory/inventory.model.dart`
- `apps/mobile/lib/features/inventory/inventory.page.dart`
- `apps/mobile/lib/features/inventory/inventory.data.dart`

**4. `manufacturing`**

- `apps/mobile/lib/features/manufacturing/manufacturing.constant.dart`
- `apps/mobile/lib/features/manufacturing/manufacturing.controller.dart`
- `apps/mobile/lib/features/manufacturing/manufacturing.model.dart`
- `apps/mobile/lib/features/manufacturing/manufacturing.page.dart`
- `apps/mobile/lib/features/manufacturing/manufacturing.data.dart`

**5. `pos_kds`**

- `apps/mobile/lib/features/pos_kds/pos_kds.constant.dart`
- `apps/mobile/lib/features/pos_kds/pos_kds.controller.dart`
- `apps/mobile/lib/features/pos_kds/pos_kds.model.dart`
- `apps/mobile/lib/features/pos_kds/pos_kds.page.dart`
- `apps/mobile/lib/features/pos_kds/pos_kds.data.dart`

**6. `crm`**

- `apps/mobile/lib/features/crm/crm.constant.dart`
- `apps/mobile/lib/features/crm/crm.controller.dart`
- `apps/mobile/lib/features/crm/crm.model.dart`
- `apps/mobile/lib/features/crm/crm.page.dart`
- `apps/mobile/lib/features/crm/crm.data.dart`

**7. `finance`**

- `apps/mobile/lib/features/finance/finance.constant.dart`
- `apps/mobile/lib/features/finance/finance.controller.dart`
- `apps/mobile/lib/features/finance/finance.model.dart`
- `apps/mobile/lib/features/finance/finance.page.dart`
- `apps/mobile/lib/features/finance/finance.data.dart`

# FLOW: End-to-End System Workflows

This section outlines every major flow in the F&B ERP system. Each step details the UI Page involved, the underlying Prisma Models, the precise database fields being written/read, and a real-world example.

---

## 1. CORE / HR Module Flows

### Flow 1.1: Complete Branch & Franchise Setup

**Scenario:** The company opens a new franchise branch in "Downtown Dubai" owned by "Ahmad".

- **Step 1: Create Branch Profile**
  - **Page:** Admin Dashboard -> Branches -> Create Branch
  - **Models:** `Branch`
  - **Fields Involved:** `name` (Downtown Dubai), `code` (DXB-01), `address` (Sheikh Zayed Rd), `is_hq` (false), `status` (ACTIVE).
  - **Example Action:** The admin clicks "Save", inserting a new `Branch` record.
- **Step 2: Assign Franchise Agreement**
  - **Page:** Admin Dashboard -> Branches -> DXB-01 -> Franchise Settings
  - **Models:** `Franchise`
  - **Fields Involved:** `branch_id` (DXB-01 ID), `owner_name` (Ahmad Ali), `royalty_pct` (5.0), `agreement_doc` (url_to_pdf).
  - **Example Action:** The branch is now flagged as a franchise, meaning 5% of its sales will trigger a `RoyaltyTrans` at month-end.

### Flow 1.2: Employee Shift & Time Tracking

**Scenario:** A cashier clocks in for their morning shift.

- **Step 1: Employee Registration**
  - **Page:** HR Manager -> Employees -> Add Employee
  - **Models:** `Employee`
  - **Fields Involved:** `branch_id`, `name` (Sarah), `role` (CASHIER), `hourly_rate` (15.50), `status` (ACTIVE).
  - **Example Action:** Sarah is assigned to DXB-01.
- **Step 2: Manager Schedules Shift**
  - **Page:** HR Manager -> Roster -> Assign Shift
  - **Models:** `Shift`
  - **Fields Involved:** `employee_id` (Sarah's ID), `start_time` (08:00 AM), `end_time` (04:00 PM), `status` (ACTIVE).
- **Step 3: Employee Clocks In**
  - **Page:** POS Terminal -> Lock Screen -> Clock In (PIN entry)
  - **Models:** `TimeLog`
  - **Fields Involved:** `employee_id`, `clock_in` (07:55 AM).
  - **Example Action:** The system logs her exact punch-in time against the expected `Shift`.
- **Step 4: Employee Clocks Out**
  - **Page:** POS Terminal -> Lock Screen -> Clock Out
  - **Models:** `TimeLog`
  - **Fields Involved:** `clock_out` (04:05 PM), `total_hours` (8.16).

---

## 2. CATALOG Module Flows

### Flow 2.1: Advanced Menu Item with Modifiers

**Scenario:** Setting up a "Build-Your-Own Burger" menu item.

- **Step 1: Setup Modifier Group**
  - **Page:** Catalog -> Modifiers -> Create Group
  - **Models:** `ModifierGroup`
  - **Fields Involved:** `name` (Cheese Add-ons), `min_select` (0), `max_select` (2).
- **Step 2: Add Modifiers**
  - **Page:** Catalog -> Modifiers -> Cheese Add-ons -> Add Items
  - **Models:** `Modifier`
  - **Fields Involved:** `group_id`, `name` (Cheddar), `extra_price` (1.50), `variant_id` (Linked to Inventory Cheddar Slice).
- **Step 3: Create Menu Item**
  - **Page:** Catalog -> Menu -> Add Item
  - **Models:** `MenuItem`, `MenuCategory`
  - **Fields Involved:** `category_id` (Burgers), `display_name` (Custom Burger), `selling_price` (12.00), `variant_id` (Linked to Inventory Bun/Patty generic variant).
  - **Example Action:** When a customer orders this, the POS prompts the "Cheese Add-ons" `ModifierGroup`.

### Flow 2.2: Combo Meal Definition

**Scenario:** A "Lunch Special" combo including a Burger, Fries, and Drink.

- **Step 1: Define Combo Header**
  - **Page:** Catalog -> Combos -> Create Combo
  - **Models:** `ComboMeal`
  - **Fields Involved:** `name` (Lunch Special), `fixed_price` (15.00).
- **Step 2: Attach Menu Items to Combo**
  - **Page:** Catalog -> Combos -> Manage Items
  - **Models:** `ComboItem`
  - **Fields Involved:** `combo_id`, `menu_item_id` (Burger ID), `qty_included` (1).
  - **Example Action:** Adds Burger, Fries, and Soda as `ComboItem`s to the `ComboMeal`.

---

## 3. INVENTORY Module Flows

### Flow 3.1: Procurement (PO to Goods Receipt)

**Scenario:** Branch runs low on Coffee Beans and orders from a Supplier.

- **Step 1: Raise Purchase Order (PO)**
  - **Page:** Inventory -> Procurement -> New PO
  - **Models:** `PurchaseOrder`, `POItem`
  - **Fields Involved (PO):** `supplier_id`, `status` (DRAFT), `total_amount` (500.00).
  - **Fields Involved (Item):** `po_id`, `variant_id` (Arabica Beans 1KG), `qty_ordered` (50), `unit_price` (10.00).
- **Step 2: Receive Goods (GRN)**
  - **Page:** Inventory -> Receiving -> Inbound POs
  - **Models:** `GoodsReceipt`, `StockLedger`
  - **Fields Involved (GRN):** `po_id`, `invoice_number` (INV-992).
  - **Fields Involved (Ledger):** `variant_id`, `transaction_type` (PURCHASE), `quantity_change` (+50), `running_balance` (calculates previous + 50).
  - **Example Action:** Stock is instantly updated in the `StockLedger`, and the PO `status` changes to RECEIVED.

### Flow 3.2: Inter-Branch Stock Transfer

**Scenario:** HQ transfers 100 empty branded cups to the Dubai branch.

- **Step 1: Dispatch Transfer**
  - **Page:** Inventory -> Transfers -> Dispatch
  - **Models:** `StockTransfer`, `TransferItem`, `StockLedger`
  - **Fields Involved (Transfer):** `from_branch_id` (HQ), `to_branch_id` (DXB-01), `status` (DISPATCHED).
  - **Fields Involved (Ledger):** Subtracts 100 from HQ (`transaction_type` = TRANSFER_OUT).
- **Step 2: Receive Transfer**
  - **Page:** Inventory -> Transfers -> Inbound
  - **Models:** `StockTransfer`, `StockLedger`
  - **Fields Involved:** `status` changes to RECEIVED. Adds 100 to DXB-01 Ledger (`transaction_type` = TRANSFER_IN).

---

## 4. MANUFACTURING Module Flows

### Flow 4.1: Kitchen Production Batch (Central Kitchen)

**Scenario:** Producing 10 Liters of signature Tomato Sauce.

- **Step 1: Define Recipe (BOM)**
  - **Page:** Manufacturing -> Recipes (BOM)
  - **Models:** `BillOfMaterial`, `BOMItem`
  - **Fields Involved (BOM):** `output_variant_id` (Tomato Sauce 1L), `yield_quantity` (1).
  - **Fields Involved (Items):** `input_variant_id` (Fresh Tomatoes KG), `quantity` (1.5).
- **Step 2: Execute Production Batch**
  - **Page:** Manufacturing -> Batches -> Start Batch
  - **Models:** `ProductionBatch`, `StockLedger`
  - **Fields Involved (Batch):** `bom_id`, `planned_qty` (10), `status` (COMPLETED).
  - **Fields Involved (Ledger):** Automatically loops through `BOMItem`s and deducts 15 KG of Tomatoes (`PRODUCTION_OUT`), and adds 10 Liters of Tomato Sauce (`PRODUCTION_IN`).
- **Step 3: Quality Control**
  - **Page:** Manufacturing -> Batches -> QC Audit
  - **Models:** `QCAudit`
  - **Fields Involved:** `audit_type` (TEMPERATURE), `result_value` (4°C), `batch_id`.

---

## 5. POS / KDS Module Flows

### Flow 5.1: Dine-In Order Lifecycle

**Scenario:** Table 4 orders a Burger, and it routes to the Kitchen.

- **Step 1: Open Table Order**
  - **Page:** POS -> Floor Plan -> Table 4
  - **Models:** `Table`, `Order`
  - **Fields Involved (Table):** `status` (OCCUPIED).
  - **Fields Involved (Order):** `table_id`, `order_type` (DINE_IN), `status` (OPEN).
- **Step 2: Add Items & Fire to Kitchen**
  - **Page:** POS -> Menu Screen -> Send
  - **Models:** `OrderItem`, `KitchenOrderTicket` (KOT)
  - **Fields Involved (Item):** `menu_item_id`, `qty` (1).
  - **Fields Involved (KOT):** `station` (HOT_FOOD), `status` (PREPARING), `print_count` (1).
  - **Example Action:** A ticket prints at the Grill station KDS.
- **Step 3: Settle Bill**
  - **Page:** POS -> Checkout -> Pay
  - **Models:** `AdvancePayment`, `Order`, `Table`
  - **Fields Involved (Payment):** `amount_paid` (15.00), `payment_method` (CARD).
  - **Fields Involved (Order):** `status` (PAID).
  - **Fields Involved (Table):** `status` (AVAILABLE).

---

## 6. CRM Module Flows

### Flow 6.1: Loyalty Points Earn & Burn

**Scenario:** Customer buys a coffee and earns points, then uses points for a discount.

- **Step 1: Customer Identification**
  - **Page:** POS -> Add Customer
  - **Models:** `Customer`
  - **Fields Involved:** `phone` (+971501234567), `points_balance`.
- **Step 2: Earn Points on Purchase**
  - **Page:** POS -> Checkout (Background Process)
  - **Models:** `LoyaltyTrans`, `Customer`
  - **Fields Involved (Trans):** `trans_type` (EARNED), `points` (+10).
  - **Fields Involved (Customer):** `points_balance` updates to 10.
- **Step 3: Redeem Points**
  - **Page:** POS -> Checkout -> Apply Points
  - **Models:** `LoyaltyTrans`, `AdvancePayment`
  - **Fields Involved (Trans):** `trans_type` (REDEEMED), `points` (-10).
  - **Fields Involved (Payment):** `payment_method` (LOYALTY_POINTS), `amount_paid` (Equivalent monetary value).

---

## 7. FINANCE Module Flows

### Flow 7.1: End of Day Reconciliation

**Scenario:** The Cashier closes the till at the end of their shift.

- **Step 1: Open Register (Start of Shift)**
  - **Page:** POS -> Shift Management -> Open Till
  - **Models:** `CashRegister`
  - **Fields Involved:** `expected_cash` (100.00 - float), `status` (OPEN), `opened_by`.
- **Step 2: Close Register**
  - **Page:** POS -> Shift Management -> Close Till
  - **Models:** `CashRegister`, `LedgerEntry`
  - **Fields Involved:** `actual_cash` (Customer counts 550.00), `status` (CLOSED).
  - **Example Action:** The system compares `expected_cash` (Float + Cash Sales) vs `actual_cash`. Any discrepancy is flagged. A `LedgerEntry` is created moving Cash Asset to Revenue.

### Flow 7.2: Franchise Royalty Auto-Calculation

**Scenario:** Month-end processing for the Dubai Franchise (DXB-01).

- **Step 1: Revenue Calculation**
  - **Page:** Admin -> Finance -> Royalty Run
  - **Models:** `Order`, `Franchise`, `RoyaltyTrans`
  - **Example Action:** System sums all `Order.total_amount` where `branch_id = DXB-01` and `status = PAID`. E.g., Total Sales = 100,000.
- **Step 2: Generate Royalty Invoice**
  - **Fields Involved (Franchise):** Reads `royalty_pct` (5%).
  - **Fields Involved (RoyaltyTrans):** `franchise_id`, `calculated_amt` (5,000.00), `status` (INVOICED).

---

---

## FLOW ORIENTED

### 1st Flow: End-to-End Procurement (Items, Suppliers & Bulk Goods)

**Overview:**
This flow encompasses the complete lifecycle of procurement. Before a manager can buy bulk goods, they must first configure the catalog (Items, Item Categories, UOMs, UOM Conversions, and Item Variants) and manage vendors (Suppliers). Once the foundation is set, they can execute a Purchase Order (PO) and receive the goods via a Goods Receipt Note (GRN) to update the Stock Ledger.

#### 1. Database Entities Involved

- **ItemCategory**: Grouping for materials (e.g., "Dairy", "Spices").
- **UnitOfMeasure (UOM)**: Base measuring units (e.g., "KG", "GRAM").
- **UOMConversion**: Mathematical relationship between units (e.g., 1 KG = 1000 GRAMS).
- **Item**: The core product definition (e.g., "Sugar").
- **ItemVariant**: Specific stocking units (SKUs) of an item (e.g., "50 KG Bag of Sugar").
- **Supplier**: Vendors, including nested `addresses` and `bank_details`.
- **PurchaseOrder**: The document tracking the purchase. Fields: `supplier_id`, `status` (`DRAFT`, `SENT`, `RECEIVED`), `total_amount`.
- **POItem**: Line items in the PO. Fields: `variant_id`, `qty_ordered`, `unit_price`, `total_price`.
- **GoodsReceipt**: Logs the physical arrival of goods.
- **StockLedger**: Journal where the actual inventory increment is recorded (`transaction_type: PURCHASE`).

#### 2. API / Backend Architecture

**A. Types / DTOs (`apps/api/src/features/inventory/`)**

- `ItemCategoryDTO`, `UnitOfMeasureDTO`, `UOMConversionDTO`, `ItemDTO`, `ItemVariantDTO`, `SupplierDTO`, `PurchaseOrderDTO`, `POItemDTO`, `GoodsReceiptDTO`.
- `CreatePOPayload`: Contains `supplier_id`, `notes`, and an array of `{ variant_id, qty, unit_price }`.

**B. Repositories (`apps/api/src/features/inventory/[entity].repo.ts`)**

- `ItemCategoryRepo`, `UOMRepo`, `ItemRepo`, `SupplierRepo`: Standard CRUD operations.
- `PurchaseOrderRepo.createPO(data)`: Inserts PO and POItems within a database transaction.
- `PurchaseOrderRepo.logGoodsReceipt(data)`: Inserts GRN record and triggers Stock Ledger updates.

**C. Services (`apps/api/src/features/inventory/[entity].service.ts`)**

- `SupplierService`: Validates and manages vendors.
- `ItemService`: Handles item creation, automatically generating base `ItemVariant`s.
- `POService.initiatePurchase(...)`: Business logic to validate supplier, calculate totals, and create the PO.
- `POService.receiveGoods(poId, invoiceDetails)`:
  1. Validates PO is `SENT`.
  2. Calls `logGoodsReceipt`.
  3. Uses `StockService` to automatically increment inventory based on received variant quantities and configured `UOMConversion`s.
  4. Marks PO as `RECEIVED`.

**D. Controllers & Routes (`apps/api/src/features/inventory/[entity].controller.ts & .route.ts`)**

- Full RESTful endpoints for `categories`, `uoms`, `items`, `suppliers`.
- `POST /api/inventory/po`
- `POST /api/inventory/po/:id/receive`

#### 3. Mobile App Architecture (Flutter)

**A. Models (`apps/mobile/lib/features/inventory/`)**

- `item_category.model.dart`, `unit_of_measure.model.dart`, `u_o_m_conversion.model.dart`, `item.model.dart`, `item_variant.model.dart`, `supplier.model.dart`, `purchase_order.model.dart`, `goods_receipt.model.dart`.

**B. Repositories & State Management (`Cubit` & `Repo` pairs)**

- `SupplierRepo` + `SupplierCubit`: Fetch, Create, Edit suppliers.
- `ItemRepo` + `ItemCubit`: Catalog management.
- `PORepo` + `POCubit`: Draft POs, submit, mark as received.

**C. Pages & UI Elements**

1. **Inventory Settings / Setup Hub**
   - **Elements**: Tile navigation leading to Categories, UOMs, and UOM Conversions.
   - **Actions**: Simple list views with Floating Action Buttons to add/edit.

2. **Supplier Management Pages (`/suppliers` & `/suppliers/create`)**
   - **Elements**:
     - List view showing Supplier Name, Phone, and Tax Number.
     - Detail form featuring nested `Address` forms (street, city, pin) and `BankDetail` forms (account number, IFSC code).

3. **Item & Variant Management Pages (`/items` & `/items/create`)**
   - **Elements**:
     - Main list grouped by `ItemCategory`.
     - Creation form: Name, Type (Raw Material, Asset), Shelf Life.
     - Sub-form to attach `ItemVariant`s (e.g., creating the 50KG SKU, assigning base cost, and selecting the `UnitOfMeasure`).

4. **Procurement Dashboard (`/procurement`)**
   - **Elements**:
     - Active PO summary cards.
     - "Create New PO" green CTA button.
     - Status Badge indicators (DRAFT, SENT, RECEIVED).

5. **Create Purchase Order Flow (`/po/create`)**
   - **Elements**:
     - Supplier selection dropdown.
     - "Add Item" bottom sheet opening a searchable list of `ItemVariant`s.
     - Dynamic cart showing selected variants with a green quantity stepper and unit price input.
     - "Submit PO" sticky footer.

6. **Receive Goods Modal/Page (`/po/:id/receive`)**
   - **Elements**:
     - Input fields for `Invoice Number` and `Notes`.
     - Checklist UI confirming the quantities physically arriving.
     - "Confirm Receipt" CTA to trigger the GRN and stock ledger update.

## PART 3: FLOW ORIENTED

### 1. Buying bulk goods from suppliers

This flow covers the absolute end-to-end process of sourcing raw materials, packaging, or assets from vendors, receiving them into inventory, and updating financial ledgers. Because this impacts the physical supply chain and financials, it intrinsically involves the following sub-domains:
1. **Supplier Management:** Onboarding vendors, tracking their bank details, mapping tax info.
2. **Item & Variant Management:** Cataloging the raw materials, their units of measure (e.g. Kg, Ltr), and standard costs.
3. **Purchase Orders (PO):** The intent to buy.
4. **Goods Receipt Note (GRN):** The physical reception of goods.
5. **Stock Ledgers:** The real-time injection of stock into the branch warehouse.
6. **Vendor Returns (RTV):** Managing damaged goods.

#### Backend Architecture (API)

**1. API Types (`src/features/inventory/*.type.ts`)**
- `SupplierDTO`: `id`, `name`, `tax_number`, `addresses` (List<AddressDTO>), `bank_details` (List<BankDetailDTO>).
- `ItemVariantDTO`: `id`, `item_id`, `uom_id`, `sku`, `base_cost`, `min_stock_lvl`.
- `PurchaseOrderDTO`: `id`, `supplier_id`, `status` (`DRAFT`, `SENT`, `RECEIVED`), `total_amount`.
- `POItemDTO`: `id`, `po_id`, `variant_id`, `qty_ordered`, `unit_price`, `total_price`.
- `GoodsReceiptDTO`: `id`, `po_id`, `received_date`, `invoice_number`.
- `StockLedgerDTO`: `id`, `variant_id`, `transaction_type` (`PURCHASE`), `quantity_change`, `running_balance`.

**2. Repositories (`*.repo.ts`)**
- `SupplierRepo.createSupplier(data)`: Handles nested creation of Addresses and Bank Details.
- `ItemRepo.createItemWithVariants(data)`: Ensures raw materials are linked to a UoM.
- `PurchaseOrderRepo.createPO(data)`: Executes a Prisma transaction to save the PO and POItems.
- `PurchaseOrderRepo.updateStatus(id, status)`: Transitions PO state.
- `StockLedgerRepo.recordInward(poId, items)`: Critical transaction. Locks the variant rows, reads current `running_balance`, adds the new `qty`, and inserts the `StockLedger` audit trail.

**3. Services (`*.service.ts`)**
- `SupplierService.onboardVendor()`: Validates IFSC codes and Tax numbers.
- `POService.draftOrder(input)`: Validates active variants, auto-calculates totals.
- `POService.receiveGoods(grnInput)`: The most complex logic. Validates that `received_qty` <= `ordered_qty`. If there are damaged goods, it triggers `VendorReturnService`. Finally, it invokes `StockLedgerRepo.recordInward` and changes PO status to `RECEIVED`.

**4. Controllers & Routes (`*.route.ts`)**
- `POST /api/v1/inventory/suppliers`
- `GET /api/v1/inventory/suppliers`
- `POST /api/v1/inventory/items` (Cataloging)
- `POST /api/v1/inventory/purchase-orders`
- `GET /api/v1/inventory/purchase-orders/:id`
- `POST /api/v1/inventory/purchase-orders/:id/receive` (GRN execution)

#### Mobile Architecture (Flutter)

**1. Models (`features/inventory/*.model.dart`)**
- `SupplierModel`, `ItemModel`, `ItemVariantModel`, `PurchaseOrderModel`, `POItemModel`, `GoodsReceiptModel`, `StockLedgerModel`.
- All strictly use `snake_case` mapping natively generated by our pipeline.

**2. Repositories (`features/inventory/*.repo.dart`)**
- `SupplierRepo`, `ItemRepo`, `PurchaseOrderRepo`.
- All inject `ApiClient` and use `TaskResult<T>`.

**3. State Management / Cubits (`features/inventory/*.cubit.dart`)**
- `SupplierCubit`: Manages `loadInfo`, `saveInfo`, and `List<SupplierModel>`.
- `CatalogCubit`: Handles the infinite scrolling list of `ItemVariantModel`.
- `PurchaseOrderCubit`: Emits `PurchaseOrderState`. Handles cart mechanics locally before calling `submitPO()`.
- `GrnCubit`: Manages the scanning and receiving checklist state.

**4. Pages & UI Elements**
- The UI must encompass the complete flow from adding the supplier, adding the items, creating the PO, to receiving it. (See Stitch Prompt below for exactly what to generate).

#### Stitch Prompt for UI Generation

***

**Prompt for Stitch:**
```text
You are an expert Flutter UI Architect. We are building the completely comprehensive "Buying Bulk Goods" flow for our Enterprise ERP. This is a massive, highly detailed module.

**CRITICAL DIRECTIVE:**
I need you to design and implement the exact UI pages and elements for this ENTIRE flow. You MUST generate **MORE THAN 20 PAGES/SCREENS**. Do NOT generate less than 20 pages. You must NOT stop generating until all 20+ screens/modal variations are completely outputted. Keep generating continuously. Automatically build them in batches if needed, but do not stop. Follow the STRICT mobile standards: no comments, everything uses ScreenUtil (.w, .h, .sp, .r), and features are grouped in a flat structure (e.g. `features/inventory/purchase_order.page.dart`). STRICTLY adhere to the base UI file I will paste next.

**Required Screens & Elements (Generate ALL of these, amounting to 20+ files/components):**

**A. Supplier Management Sub-Flow**
1. `supplier_list.page.dart`: List of all vendors, search bar, active/inactive badges.
2. `supplier_detail.page.dart`: View vendor info, their past POs, and account balance.
3. `create_supplier.page.dart`: Form to onboard a vendor.
4. `supplier_address_sheet.widget.dart`: Bottom sheet to add their nested `Address`.
5. `supplier_bank_sheet.widget.dart`: Bottom sheet to add their nested `BankDetail`.

**B. Item & Catalog Setup Sub-Flow**
6. `raw_material_list.page.dart`: List of all `RAW_MATERIAL` items.
7. `create_item.page.dart`: Form to define a new Item.
8. `create_variant_sheet.widget.dart`: Bottom sheet to add SKUs, UoM, and base cost to the Item.
9. `uom_picker_sheet.widget.dart`: Bottom sheet selecting KG, GM, LTR, etc.

**C. Purchase Order (PO) Sub-Flow**
10. `purchase_order_list.page.dart`: List of all DRAFT, SENT, RECEIVED orders.
11. `purchase_order_detail.page.dart`: Read-only view of a specific PO and its items.
12. `create_po.page.dart`: The main drafting screen.
13. `po_supplier_picker.widget.dart`: Modal to search and select a Supplier for the PO.
14. `po_add_item_sheet.widget.dart`: Modal with search bar to select an `ItemVariant`.
15. `po_cart_item_card.widget.dart`: The custom widget showing the added item, with a green quantity stepper and unit price input field.
16. `po_review_sheet.widget.dart`: Bottom sheet summarizing the Grand Total before final dispatch.

**D. Goods Receipt (GRN) Sub-Flow**
17. `grn_pending_list.page.dart`: List of SENT POs awaiting delivery.
18. `goods_receipt.page.dart`: The main receiving checklist. Displays ordered items alongside numeric inputs for "Actual Received Qty".
19. `grn_damage_report_sheet.widget.dart`: Bottom sheet triggered if received qty < ordered qty, logging it as damaged.
20. `grn_success_modal.widget.dart`: A massive success screen showing +Stock added to the Ledger.

**E. Stock Ledger & Verification Sub-Flow**
21. `stock_ledger.page.dart`: The real-time running balance screen showing exactly what came in.
22. `vendor_return_form.page.dart`: (RTV) Screen to send damaged goods back.

**UI Rules:**
- Use `AppColors.primaryIndigo`, `pureWhite`, `softGrey`, and `AppColors.textPrimary`.
- Form layouts must use `SingleChildScrollView` and `SafeArea`.
- Modals must use the standard Bottom Sheet Template (40.w handle, << back button). No Scaffolds inside Modals.
- Generate them continuously. Do not stop.
```

### 2. Table Order and Kitchen Action (POS & KDS Flow)

This flow manages the core operations of a dine-in restaurant environment, covering everything from seating a customer, punching in an order, splitting the ticket into station-specific KOTs (Kitchen Order Tickets), kitchen preparation feedback, order fulfillment, and ultimately the table checkout and ledger update. It strictly bridges the Front-of-House (POS) and Back-of-House (KDS).

#### Backend Architecture (API)

**1. API Types (`src/features/pos_kds/*.type.ts`, `src/features/catalog/*.type.ts`)**
- `TableZoneDTO`: `id`, `branch_id`, `name`.
- `TableDTO`: `id`, `zone_id`, `table_number`, `capacity`, `status` (`AVAILABLE`, `OCCUPIED`, `CLEANING`).
- `OrderDTO`: `id`, `table_id`, `status` (`OPEN`, `BILLED`, `PAID`, `CANCELLED`), `total_amount`, `items` (List<OrderItemDTO>).
- `OrderItemDTO`: `id`, `order_id`, `menu_item_id`, `qty`, `price`, `modifier_notes`.
- `KitchenOrderTicketDTO` (KOT): `id`, `order_id`, `station` (`HOT_FOOD`, `BAKERY`, `DRINKS`), `status` (`PREPARING`, `READY`, `SERVED`).
- `MenuItemDTO` & `ModifierDTO`: Used for the POS catalog layout.

**2. Repositories (`*.repo.ts`)**
- `TableRepo.getZonesAndTables()`: Retrieves visual floor plans.
- `TableRepo.updateStatus(id, status)`: Transitions a table's occupancy.
- `OrderRepo.createOrderWithKOT(data)`: A complex Prisma transaction that saves the `Order`, `OrderItems`, and intelligently splits the items into multiple `KOT` rows based on their respective kitchen stations.
- `KOTRepo.updateTicketStatus(id, status)`: Moves a ticket from `PREPARING` to `READY`.

**3. Services (`*.service.ts`)**
- `TableService.seatCustomer()`: Assigns a table, marks it `OCCUPIED`.
- `OrderService.punchOrder(input)`: Validates stock availability in `StockLedger`, calculates combo/modifier prices, triggers `OrderRepo.createOrderWithKOT`.
- `KDSService.bumpTicket(kotId)`: Called by the kitchen display when a chef finishes a dish. Changes KOT status and sends a real-time event (e.g. WebSocket/SSE) to the waiters to serve the food.
- `CheckoutService.settleBill(orderId)`: Calculates taxes, processes loyalty points (`LoyaltyTrans`), logs the financial `LedgerEntry` (Revenue), and marks the Table as `CLEANING`.

**4. Controllers & Routes (`*.route.ts`)**
- `GET /api/v1/pos/tables`
- `PATCH /api/v1/pos/tables/:id/status`
- `POST /api/v1/pos/orders`
- `GET /api/v1/kds/tickets` (Long-polling or standard fetch for the kitchen display)
- `PATCH /api/v1/kds/tickets/:id/bump`
- `POST /api/v1/pos/orders/:id/checkout`

#### Mobile Architecture (Flutter)

**1. Models (`features/pos_kds/*.model.dart`)**
- `TableModel`, `TableZoneModel`, `OrderModel`, `OrderItemModel`, `KitchenOrderTicketModel`.
- `MenuItemModel`, `ModifierModel` (from Catalog feature).
- All use `snake_case` properties matching the API exact schemas.

**2. Repositories (`features/pos_kds/*.repo.dart`)**
- `PosRepo`, `KdsRepo`.
- Uses `ApiClient` mapping Dio calls to `TaskResult<T>`.

**3. State Management / Cubits (`features/pos_kds/*.cubit.dart`)**
- `FloorPlanCubit`: Manages the visual grid of tables and their live statuses.
- `PosCartCubit`: A robust local state manager handling the active order, modifier selections, and price tallying before hitting the API.
- `KdsBoardCubit`: Manages the kanban-style board for chefs, grouping tickets by `station`. Auto-refreshes periodically.

**4. Pages & UI Elements**
- The UI demands two completely distinct interfaces: The **POS Interface** (Waitstaff/Cashier) and the **KDS Interface** (Chefs). (See Stitch Prompt below for 25+ specific UI targets).

#### Stitch Prompt for UI Generation

***

**Prompt for Stitch:**
```text
You are an expert Flutter UI Architect. We are building the massive "Table Order & Kitchen Management (POS/KDS)" flow for our Enterprise ERP. This bridges front-of-house ordering with back-of-house kitchen displays.

**CRITICAL DIRECTIVE:**
I need you to design and implement the exact UI pages and elements for this ENTIRE flow. You MUST generate **MORE THAN 25 PAGES/SCREENS**. Do NOT generate less than 25 pages. You must NOT stop generating until all 25+ screens/modal variations are completely outputted. Keep generating continuously. Automatically build them in batches if needed, but do not stop. Follow the STRICT mobile standards: no comments, everything uses ScreenUtil (.w, .h, .sp, .r), and features are grouped in a flat structure (e.g. `features/pos_kds/floor_plan.page.dart`). STRICTLY adhere to the base UI file I will paste next.

**Required Screens & Elements (Generate ALL of these, amounting to 25+ files/components):**

**A. Floor Plan & Table Management Sub-Flow**
1. `floor_plan.page.dart`: Grid layout of Tables grouped by Zones. Color-coded (Green=Available, Red=Occupied, Yellow=Cleaning).
2. `table_card.widget.dart`: Visual representation of a table, showing seat count and active order time.
3. `table_action_sheet.widget.dart`: Bottom sheet popping up on a Table tap (Options: "New Order", "View Bill", "Mark Clean").
4. `zone_selector_tabs.widget.dart`: Horizontal scrollable tabs to switch between "Patio", "Main Dining", "Bar".

**B. POS Ordering (Catalog & Cart) Sub-Flow**
5. `pos_terminal.page.dart`: The main dual-pane POS screen (Left: Menu Grid, Right: Active Cart).
6. `pos_category_sidebar.widget.dart`: Vertical list of `MenuCategory` items with icons.
7. `pos_menu_grid.widget.dart`: Grid of `MenuItem` cards displaying prices and images.
8. `modifier_selection_modal.widget.dart`: A large modal popping up when an item is tapped, allowing selection of `ModifierGroup` options (e.g. Extra Cheese, Crust Type).
9. `combo_builder_modal.widget.dart`: Specialized modal for selecting `ComboItem` variations.
10. `pos_cart_pane.widget.dart`: The right-side pane holding the current order.
11. `cart_item_row.widget.dart`: A single row in the cart showing the item name, selected modifiers underneath in small text, quantity stepper, and price.
12. `cart_action_footer.widget.dart`: Sticky bottom area in the cart pane with Grand Total and massive "Punch Order (Send to KDS)" button.

**C. Kitchen Display System (KDS) Sub-Flow**
13. `kds_board.page.dart`: Kanban style board for the kitchen. Landscape-oriented layout.
14. `kds_station_filter.widget.dart`: Toggle to show tickets for "Hot Food", "Bakery", or "Drinks".
15. `kot_card.widget.dart`: A Kitchen Order Ticket card showing Table Number, Waiter Name, Elapsed Timer (red if > 15 mins), and a checklist of items.
16. `kot_item_row.widget.dart`: Inside the KOT card, the specific item (with modifiers highlighted for the chef).
17. `bump_ticket_button.widget.dart`: The "Done / Ready" action button on the KOT card.
18. `kds_history.page.dart`: A side-panel or page showing recently bumped/completed tickets in case of mistakes.

**D. Waitstaff Fulfillment Sub-Flow**
19. `service_queue.page.dart`: A screen for waiters showing items that are "READY" in the kitchen, waiting to be taken to tables.
20. `serve_action_sheet.widget.dart`: Bottom sheet confirming the food was dropped at the table.

**E. Checkout & Billing Sub-Flow**
21. `checkout_split.page.dart`: Screen to split the bill (By Item, or Equal Split).
22. `loyalty_redeem_sheet.widget.dart`: Modal to enter customer phone number and apply loyalty points to the bill.
23. `payment_tender_modal.widget.dart`: Grid of payment options (Cash, Card, UPI). If Cash, shows quick exact-change buttons (e.g. $20, $50, $100).
24. `digital_receipt.page.dart`: Final summary screen showing the generated invoice.
25. `tip_adjustment_sheet.widget.dart`: Modal to add a tip post-payment for card transactions.

**UI Rules:**
- Use `AppColors.primaryIndigo`, `pureWhite`, `softGrey`, and `AppColors.textPrimary`.
- Use the standard Bottom Sheet Template for all modals (40.w handle, << back button). No Scaffolds inside Modals.
- POS/KDS interfaces heavily rely on GridViews and dual-pane layouts.
- Generate them continuously. Do not stop.

[PASTE BASE UI FILE CONTENT HERE]
```

### 3. Preparing Food Items (Manufacturing & Production Flow)

This flow manages the back-of-house manufacturing process where raw materials are transformed into semi-finished or finished goods. This is crucial for bakeries, sweet shops, and central kitchens. It involves creating a master recipe (Bill of Materials), running a production batch, consuming raw inventory, performing quality control, and logging wastage.

#### Backend Architecture (API)

**1. API Types (`src/features/manufacturing/*.type.ts`)**
- `BillOfMaterialDTO`: `id`, `output_variant_id`, `yield_quantity`, `items` (List<BOMItemDTO>).
- `BOMItemDTO`: `id`, `bom_id`, `input_variant_id`, `quantity`.
- `ProductionBatchDTO`: `id`, `bom_id`, `status` (`PLANNED`, `IN_PROGRESS`, `COMPLETED`), `produced_qty`.
- `QCAuditDTO`: `id`, `batch_id`, `temperature`, `taste_status`, `notes`.
- `WastageLogDTO`: `id`, `variant_id`, `qty`, `reason`.

**2. Repositories (`*.repo.ts`)**
- `BOMRepo.createBOM(data)`: Saves the master recipe.
- `ProductionBatchRepo.startBatch(id)`: Changes status to `IN_PROGRESS`.
- `ProductionBatchRepo.completeBatch(id, actualYield)`: This is a massive Prisma transaction. It calculates theoretical consumption from the BOM, deducts those raw materials from `StockLedger`, and adds the `actualYield` to the finished goods `StockLedger`.
- `WastageRepo.logWaste(data)`: Deducts inventory directly via `StockLedger`.

**3. Services (`*.service.ts`)**
- `BOMService.calculateCost(bomId)`: Dynamically sums up the `base_cost` of all `BOMItem` ingredients to determine the exact cost to produce the finished good.
- `ProductionService.executeBatch(batchId, yield)`: Validates that enough raw material exists in the warehouse before starting. If short, it throws an `InsufficientStockException`.
- `QCService.auditBatch()`: Prevents a batch from being marked `COMPLETED` and entering inventory if it fails health/taste standards.

**4. Controllers & Routes (`*.route.ts`)**
- `POST /api/v1/manufacturing/boms`
- `GET /api/v1/manufacturing/boms/:id`
- `POST /api/v1/manufacturing/batches`
- `PATCH /api/v1/manufacturing/batches/:id/complete`
- `POST /api/v1/manufacturing/qc-audits`
- `POST /api/v1/manufacturing/wastage`

#### Mobile Architecture (Flutter)

**1. Models (`features/manufacturing/*.model.dart`)**
- `BillOfMaterialModel`, `BOMItemModel`, `ProductionBatchModel`, `QCAuditModel`, `WastageLogModel`.
- All strictly use `snake_case` properties.

**2. Repositories (`features/manufacturing/*.repo.dart`)**
- `ManufacturingRepo`, `WastageRepo`.
- Uses `ApiClient` mapping Dio calls to `TaskResult<T>`.

**3. State Management / Cubits (`features/manufacturing/*.cubit.dart`)**
- `BomBuilderCubit`: Manages the complex state of adding/removing ingredients and adjusting yields before saving a recipe.
- `ActiveBatchCubit`: Tracks running kitchen batches, timer durations, and actual vs expected yields.
- `QCCubit`: Handles health inspection forms and batch approvals.

**4. Pages & UI Elements**
- The UI handles the intricate workflow of recipe formulation, kitchen batch execution, and health compliance. (See Stitch Prompt below for 25+ specific UI targets).

#### Stitch Prompt for UI Generation

***

**Prompt for Stitch:**
```text
You are an expert Flutter UI Architect. We are building the massive "Preparing Food Items (Manufacturing & Production)" flow for our Enterprise ERP. This manages recipes, bulk production, QC, and wastage.

**CRITICAL DIRECTIVE:**
I need you to design and implement the exact UI pages and elements for this ENTIRE flow. You MUST generate **MORE THAN 25 PAGES/SCREENS**. Do NOT generate less than 25 pages. You must NOT stop generating until all 25+ screens/modal variations are completely outputted. Keep generating continuously. Automatically build them in batches if needed, but do not stop. Follow the STRICT mobile standards: no comments, everything uses ScreenUtil (.w, .h, .sp, .r), and features are grouped in a flat structure (e.g. `features/manufacturing/bom_list.page.dart`). STRICTLY adhere to the base UI file I will paste next.

**Required Screens & Elements (Generate ALL of these, amounting to 25+ files/components):**

**A. Bill of Materials (Recipe) Sub-Flow**
1. `bom_list.page.dart`: List of all master recipes, showing Output Item Name, Yield, and Total Cost.
2. `bom_detail.page.dart`: Read-only view of a recipe, showing theoretical cost breakdowns per ingredient.
3. `create_bom.page.dart`: The main drafting screen for a new recipe.
4. `bom_output_picker.widget.dart`: Modal to select the `ItemVariant` that this recipe produces.
5. `bom_ingredient_sheet.widget.dart`: Bottom sheet with search to add a raw material ingredient.
6. `bom_ingredient_row.widget.dart`: A custom list tile in the builder showing ingredient name, required qty, and cost contribution.
7. `bom_yield_calculator.widget.dart`: A sliding scale or input to adjust the expected output yield (e.g. "Makes 10 Kg").

**B. Production Batch Execution Sub-Flow**
8. `production_dashboard.page.dart`: Kanban board or list of `PLANNED`, `IN_PROGRESS`, and `COMPLETED` batches.
9. `plan_batch_sheet.widget.dart`: Modal to schedule a new batch based on a selected BOM.
10. `active_batch.page.dart`: The execution screen for chefs. Shows ingredients to gather.
11. `batch_ingredient_checklist.widget.dart`: Checkboxes for chefs to tick off ingredients as they dump them into the mixer.
12. `batch_timer.widget.dart`: A visual countdown timer for baking/cooking durations.
13. `complete_batch_modal.widget.dart`: Crucial modal where the chef enters the *Actual Yield* (e.g. expected 10kg, got 9.5kg) to finalize the batch.

**C. Quality Control (QC) Sub-Flow**
14. `qc_audit_list.page.dart`: Log of all past quality inspections.
15. `perform_qc_audit.page.dart`: A form-based screen for managers.
16. `qc_temperature_input.widget.dart`: Custom numeric input for logging food/fridge temperatures.
17. `qc_taste_toggle.widget.dart`: Thumbs up / Thumbs down (or Pass/Fail) toggle for sensory audits.
18. `qc_signature_pad.widget.dart`: A canvas area for the manager to sign off on the audit.
19. `qc_reject_sheet.widget.dart`: Modal triggered if the batch fails, requiring a reason code before discarding.

**D. Wastage & Spoilage Sub-Flow**
20. `wastage_log.page.dart`: History of thrown away items.
21. `report_waste.page.dart`: Form to log expired or dropped items.
22. `waste_item_picker.widget.dart`: Bottom sheet to select the ruined variant from inventory.
23. `waste_reason_dropdown.widget.dart`: Standardized dropdown (e.g. "Expired", "Dropped", "Burnt").
24. `waste_cost_impact.widget.dart`: A red banner calculating how much money was lost due to this waste entry.
25. `waste_photo_capture.widget.dart`: A UI element to snap a photo of the ruined goods for auditing.

**UI Rules:**
- Use `AppColors.primaryIndigo`, `pureWhite`, `softGrey`, and `AppColors.errorRed` (for wastage/QC failures).
- Use the standard Bottom Sheet Template for all modals (40.w handle, << back button). No Scaffolds inside Modals.
- Generate them continuously. Do not stop.

[PASTE BASE UI FILE CONTENT HERE]
```
