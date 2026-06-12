# Product Module Implementation Plan

## Original Requirements & Context

1. **Models & API**: Complete the models declared inside `product/models` and update the backend API accordingly.
2. **`product_page.dart`**: Exactly like `search_result` page in user app but:
   - Remove textfield.
   - Add a top-right menu icon button with options: Add Category (navigates to category list page), Add Product (navigates to create product page).
   - Remove filters, "new to you", and other filter sections.
   - Show sub-categories just like the category bar in the top (below app bar), showing `images[0]` and name for each.
   - Remove "Recommended for you" title header and "All items" section entirely.
   - Show the products grid below according to the selected category.
3. **Category List Page (referred to as `create_category` in point 3)**: Show categories exact UI as the `search` page in the user app. Remove filters below the app bar. Top app bar icon button -> tap -> "Create Category".
4. **Category Detail Page (referred to as `category page` in point 4)**: Shows category details (like `product detail` page in user app). Inside this page, display all its sub-categories (using the exact UI of the Category List page as a nested view; tapping allows editing). Also show products coming inside it. Top right menu icon -> tap -> "Create Sub Category" (opens form for sub-category CRUD).
5. **Create Category Page (Form)**: A form page to add/edit all category fields.
6. **Create Product Page (Form)**: A form page to add/edit all product fields.

---

## Detailed Implementation Plan

### 1. Backend API Updates (TypeScript / Prisma)
Adhering to `code_standard.md`:
- **Prisma Schema**: Update `schema.prisma` with robust `Product`, `ProductCategory`, `ProductSubCategory`, and `ProductVariant` models. Run `npx prisma generate`.
- **Constants**: Create `product.constant.ts`, `category.constant.ts` to house all error messages, string literals, and configuration. Nothing will be hardcoded.
- **Types**: Create `[feature].type.ts` for request payloads and responses.
- **Repositories & Services**: Implement Prisma-based repositories (`product.repo.ts`, `category.repo.ts`) and business logic services.
- **Controllers & Routes**: Use `asyncHandler`, create controllers, and attach routes in `src/routes/index.ts`.

### 2. Mobile App: Core & Models
Adhering to `code_standard.md`:
- **Complete Models**: Update `product.dart`, `product_category.dart`, and `product_sub_category.dart` inside `features/product/models/`.
  - Add `const` constructors, `copyWith`, `fromJson()`, and `toJson()`.
  - Ensure all database mirror fields use `snake_case` strictly (e.g., `created_at`, `is_veg`, `branch_id`).
- **Constants**: Create `product.endpoints.dart`, `product.constant.dart`, and `product.params.dart` in `features/product/constants/`. No text/labels will be hardcoded in UI.
- **Repo & State**: Create `ProductRepo` returning Dartz `TaskResult`. Create `ProductCubit` to manage data lists and `OperationStatus` loading states for creations/edits.

### 3. Mobile App: UI Pages
Adhering to `ui_standard.md`:
- **No `Scaffold.appBar`**: Build custom headers for all pages.
- **ScreenUtil**: Use `.w`, `.h`, `.sp`, `.r` everywhere.
- **Comments**: Zero-comment policy.

#### A. `product_page.dart` (Product Dashboard)
- **Structure**: Modeled on `search_result` page. Custom app bar with back button and Title.
- **Top Right Menu**: A custom `Circular Icon Button` or `PopupMenuButton` for "Add Category" and "Add Product".
- **Sub-Category Bar**: Horizontal scrolling list using `56.w` circle images with name and `3.h` green underline for the active selection.
- **Products Grid**: Replace the "Recommended" / "All Items" layout with a standard grid/list of `Product` cards, filtered by the selected sub-category.

#### B. `categories_page.dart` (Category List)
- **Structure**: Modeled on `search` page.
- **Header**: Custom app bar. Top right icon button for "Create Category".
- **Content**: 3-column circle grid (shadowed circle images, `12.sp w700` labels) for categories. Tapping navigates to `category_detail_page.dart`.

#### C. `category_detail_page.dart` (Category View)
- **Structure**: Modeled on `store` / `product detail` page.
- **Header Info**: Category name, description, `images[0]`. Top right menu icon for "Create Sub Category".
- **Nested Sub-Categories UI**: Display the category's sub-categories using the identical 3-column circle grid pattern from `categories_page.dart`. Tapping one opens it for editing.
- **Products Section**: List/Grid of products belonging to this parent category.

#### D. `create_category_page.dart` (Form)
- **Structure**: Scrollable form using `AppInput`, `AppButton`, and image/video pickers.
- **Logic**: Used for both Category and Sub-Category creation/editing based on passed arguments (e.g., if a `parent_id` is passed, it acts on sub-categories).
- **State**: Show inline thin circular loading indicator on the submit button.

#### E. `create_product_page.dart` (Form)
- **Structure**: Complex form handling simple strings, numbers (`stock`, `price`), and lists (`variants`, `images`). Dropdowns for `category_id` and `sub_category_id`.
- **State**: Same as category form. No UI blocking, only inline progress indicators. Errors trigger Cubit-level toasts/snackbars handled exclusively from the Cubit/State listening layer.
