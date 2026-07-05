- from [menu_item.model.dart](file;file:///c:/F0526/Quest/shop/apps/mobile/lib/features/catalog/models/menu_item.model.dart) , remove image url and add field List<String> videos
- do the same with schema & related operations to sync entity features & functionality
- menu item page is not opening & also study the UI style & pattern of category page, item page,etc and update entirely the menu category, add menu category, menu item, add menu item pages at UI and functional UI level
- in each form pages give proper fields as per given in schema

- also in existinhg pages, the loader is not our common reusable one, if anwhere inside [code_standard.md](file;file:///c:/F0526/Quest/shop/contexts/code_standard.md) & [ui_standard.md](file;file:///c:/F0526/Quest/shop/apps/user/context/ui_standard.md) , this point is missed to give our common loader , then add it and anywgere it is lacking add it


# Implementation Plan

## 1. Schema & Backend Operations Updates
- **Problem**: `MenuItem` schema has `image_url` but requires `videos` string array instead.
- **Action**: 
  - Modify `schema.prisma`. Remove `image_url String?` from `MenuItem` and add `videos String[] @default([])`.
  - Run `prisma db push` to synchronize changes with NeonDB.
  - Update related backend entities, DTOs, controllers, and services in the API's Catalog module to properly process and save `videos`.

## 2. Model & Mobile Updates
- **Problem**: Mobile models and data types are out of sync with the new schema requirements.
- **Action**: 
  - Update `menu_item.model.dart` to remove `image_url` and add `final List<String> videos;`. 
  - Update `copyWith`, `toJson`, and `fromJson` in the model to parse the videos list.

## 3. Menu Item Page Routing & UI Overhaul
- **Problem**: Menu item page is not opening. UI style & pattern needs to match category/item pages and be completely updated.
- **Action**:
  - Fix routing in `home.layout.page.dart` so `_currentRoute` correctly points to the menu items list (`/menu-items`) and ensure `routes.dart` registers this mapping to a `MenuItemListPage`.
  - Create/Refactor `menu.item.list.page.dart` (which may be missing or barebones) to use beautiful, info-loaded UI cards mimicking `category.list.page.dart` / `item.list.page.dart`.
  - Update the entire flow: `menu.category.list.page.dart`, `create.menu.category.page.dart`, `menu.category.detail.page.dart`, `menu.item.list.page.dart`, `create.menu.item.page.dart`, and `menu.item.detail.page.dart` for a cohesive and premium UI experience.

## 4. Proper Form Fields
- **Problem**: Forms are missing proper schema fields.
- **Action**: 
  - Audit form pages (`create.menu.category.page.dart`, `create.menu.item.page.dart`).
  - Add missing fields such as `display_order`, `videos` inputs, and `images` so that every field given in the schema is available in the forms.

## 5. Common Reusable Loader Implementation
- **Problem**: Existing pages use generic loaders instead of the standard common reusable loader defined in the standards.
- **Action**: 
  - Audit the codebase (specifically catalog/menu pages, and lists) for standard `CircularProgressIndicator` or missing loaders. 
  - Replace them with the standard `AppRefresher` for lists and our common loader widget as strictly defined in `ui_standard.md` & `code_standard.md`.
