now let's work deeply on create branch page flow:

- since we are giving option to add addresses and bank details, there should be option to reduce same as well
- while fetching location in 2nd fields, it makeing the loading in all current location fetching button, fix it and make it load only corresponsing one

### Implementation Plan

**1. Implement Removal of Dynamic Sections:**
- In `_CreateBranchPageState`, add `_removeAddressBlock(int index)` and `_removeBankBlock(int index)` methods.
- These methods will:
  - Dispose all text controllers for the specified map to prevent memory leaks.
  - Remove the map from the `_addressControllers` or `_bankControllers` list.
  - Call `setState()`.
- Update the UI to include a "Remove" text button (styled with an error/red color per standards) aligned to the right, under each block (except for the very first block, ensuring at least one address and bank section remains).

**2. Isolate Loading State for Location Fetching:**
- Replace the single boolean `bool _isFetchingLocation = false;` with `int? _fetchingLocationIndex;`.
- Update `_fetchLocation(int index)` to set `_fetchingLocationIndex = index;` when starting the fetch, and `_fetchingLocationIndex = null;` upon completion.
- In `_buildSectionHeaderWithLocation`, update the loading check to `_fetchingLocationIndex == index`. This ensures only the block currently fetching the location displays the loading spinner.
