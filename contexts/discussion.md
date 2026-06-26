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
