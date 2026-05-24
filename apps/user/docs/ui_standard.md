# User App UI Standards

This document defines the UI Standards, layout rules, typography, and color palettes used in the User App (`apps/user`).

## 1. Color Palette

Harmonious, curated brand colors that evoke premium food/ordering interface aesthetics:

*   **Primary Green**: `Color(0xFF0F8244)` (Used for active states, Veg Mode switches, lightning tags, and main buttons).
*   **Gold Badge/Accent**: `Color(0xFFC99B3B)` / `Color(0xFFFFF9E6)` / `Color(0xFF4D3600)` (Used for Gold membership banners, text, page dots, and pricing details).
*   **Header Gradient**: A full-screen width gold/peach gradient starting with `Color(0xFFFFF5D1)` to `Color(0xFFFFFFFF)` to support single prominent banner layouts.
*   **Promo Banners**: Large full-width PageView cards with dark overlays (`Color(0x33000000)`) displaying gold sales or BHIM UPI Hand Cricket (ZPL) sports games.
*   **Neutrals & Backgrounds**:
    *   Text Primary: `Color(0xFF1C1C1C)`
    *   Text Secondary: `Color(0xFF666666)`
    *   Text Tertiary (Disabled/Hint/Secondary labels): `Color(0xFF999999)`
    *   Pure White: `Color(0xFFFFFFFF)`
    *   Soft Grey (Inputs/Chips): `Color(0xFFF4F4F4)`
    *   Borders: `Color(0xFFE8E8E8)`

## 2. Typography

We use **GoogleFonts.outfit** for modern, premium sans-serif styling:

*   **Headline Large**: `32.sp` | Bold | height: `1.2` (Main landing page headers)
*   **Headline Medium**: `24.sp` | Semi-bold | height: `1.3` (Feature titles/banners)
*   **Body Large**: `16.sp` | Normal | height: `1.5` (Primary body text/input text)
*   **Body Medium**: `14.sp` | Normal | height: `1.5` (Subtext/captions)
*   **Label Large**: `14.sp` | Semi-bold (Button labels/tab titles)

## 3. Layout Standards

*   **Scale Factor**: Run the application within a `ScreenUtilInit` bootstrap at design size `Size(411.4, 843.4)`. Use `.w`, `.h`, `.sp`, and `.r` constraints on all widgets.
*   **Spacing**: Maintain an outer page padding of `16.w` for layout contents.
*   **Category List**: Horizontal scrolling containing:
    *   *Special Offer Card*: Ticket-style rectangle (`72.w` x `72.w`), soft blue gradient background, custom text layout highlighting price points.
    *   *Standard Categories*: Circle cards (diameter `64.w`) with central text. Active states display a `3.h` height indicator underline in `AppColors.primaryGreen`.
*   **Filter Chips**: Rounded borders (`10.r`), subtle border outline (`1.w`), small label font (`12.sp`). Lightning icon colored in green for "Near & Fast" indicator.
*   **Recommended Cards**: 3-column Grid layout. Delivery times display a green lightning icon if the restaurant is tagged as "Near & Fast".
*   **Explore More Grid**: 4-column cards with light shadow, circular colored icon containers (blue, red, green, purple), and bold captions.
*   **Large Restaurant List**: Vertical listing of cards displaying a full-bleed photo (`200.h`) with bookmark icons, rating averages with total reviews (e.g. `★ 4.3 By 800+`), bolting tags, and flat discount lines.
*   **Floating Tooltip**: Bottom aligned pill banner, dark grey background (`Color(0xFF212121)`), rounded corners (`12.r`), and an arrow triangle pointer facing downwards.
*   **Floating Bottom Navigation**:
    *   Positioned: `bottom: 16.h, left: 24.w, right: 24.w`.
    *   Height: `58.h`.
    *   Shape: Fully rounded capsule (`30.r` radius) with floating shadow.
    *   Alignment: Center-docked tabs distributed evenly inside the bar (`Delivery`, `Under ₹250`, `Dining`). Active tab uses a soft green capsule background.
*   **Search Page Suggestions**: Horizontal scrolling suggestions chips with white background, subtle border, rounded corners (`20.r`), and a rose pink sparkle icon (`Icons.auto_awesome`).
*   **Cursive Header Style**: Pink/rose colored (`Color(0xFFEC4899)`), bold, italic, `16.sp` styling used for suggestion banners.
*   **What's on your Mind Grid**: 3-column GridView showing circular food items (shadowed and clipped to shape) with centered labels underneath.
*   **Double-Row Filter Chips**: Stacked layout of two independent horizontal scrolling filter chips lists to support dense tagging without overcrowding.
*   **Veg Dish Spotlight Banner**: Image overlay capsule with dark transparency background (`0.7` opacity), containing a custom green veg dot square and white text (`10.sp`) displaying spotlight dishes and pricing.
*   **Ad Badge Indicator**: Small translucent black badge with white text "Ad" positioned next to top action buttons on sponsored large cards.
*   **Store Detail Layout**: Clear circular navigation back and dot actions alongside rating capsules, detailed complaint history tags, and flat offer bars.
*   **Expandable Menu Category Sections**: Best in Sweets section containing collapsible header icons, green veg dots, highly reordered progress bars, details, price points, and bottom overlay "ADD" buttons positioned on dishes.
*   **Interactive Customisation Bottom Sheet**: Modal sheet extending from bottom (`0.76` height ratio), carrying custom close buttons floating on top, full image headers, radio choice selectors, count controls, and confirmation add buttons displaying total costs.
