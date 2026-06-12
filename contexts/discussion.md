- the categories and sub categories are actually fantastically placed, don't touch that
- make the grid of products exactly like we have for the food items of food page (3 element in a row grid and also show more info like availablilty, etc)
- fix the ui

---

## Implementation Plan

### 3. Redesign Products Grid (3-Column Layout)

**Problem**: The current products grid is a 2-column layout with a thick card shadow, which differs from the sleek 3-column 'food items' presentation requested. It also lacks important operational info like availability and stock status.
**Solution**:

- Update `_buildProductsGrid` in `lib/features/product/pages/products_page.dart`.
- Change `gridDelegate` to `crossAxisCount: 3`, `childAspectRatio: 0.62`, and `crossAxisSpacing: 10.w`.
- Remove the overall white card wrapper. Instead, follow the standard UI pattern where the image container is fully rounded (`12.r`) without a card wrapper, and text sits below it.
- Within the `Expanded` image `Stack`, add a conditional overlay badge (e.g., a green veg dot or a dark 'Out of Stock' overlay if `!is_available`).
- Below the image, display:
  - Product Name (`11.sp w800`, max 2 lines, ellipsis).
  - Price (`11.sp w900 AppColors.primaryGreen`).
  - Stock Info (`10.sp w600 AppColors.textSecondary` displaying "Stock: X").
