make the nav bar and secondary nav bar tightened to the nav items and also make it very professional

---

# Implementation Plan: Tightened Navigation Bars

## Goal Description
Refactor the primary and secondary floating navigation bars so they dynamically wrap tightly around the menu items instead of stretching across the entire width of the screen.

## Proposed Changes
### 1. Tighten the Navigation Bars
**File:** `apps/mobile/lib/features/home/pages/home_page.dart`
- Remove the hardcoded `left: 24.w` and `right: 24.w` constraints from both the primary and secondary `Positioned` widgets.
- Wrap the main `Container` for each navigation bar inside a `Center` widget, combined with `left: 0` and `right: 0` on the `Positioned` parent, to ensure they remain perfectly centered horizontally.
- Set `mainAxisSize: MainAxisSize.min` on the `Row` within the `Container` so that the layout dynamically shrinks to closely hug the active/inactive child items.
- Increase the border radius to a perfect pill shape `40.r` and utilize a more subtle, professional shadow color `Color(0x14000000)` with `blurRadius: 24` to create a premium "floating" look.

## Verification Plan
- Run `dart analyze` to ensure syntax is fully valid.
- Visually verify that the navigation bars now display as centered pills rather than stretched rectangles.
