const fs = require('fs');

const cartPath = 'apps/mobile/lib/features/pos_kds/pos.cart.page.dart';
let cartCode = fs.readFileSync(cartPath, 'utf8');

// 1. Fix User Fetching (404 Issue)
cartCode = cartCode.replace(
  "await ApiClient().get('/api/v1/pos-kds/customers/$phone');",
  "await ApiClient().get('/pos-kds/customers/$phone');"
);

// 2. Add Loading Indicator to Search
// Look for the Row containing 'User found:' or 'New Customer'
// Instead of complex regex, let's inject it into the phone number TextField suffixIcon, or right next to the customerName text.
// Right now, _searchCustomer sets _isSearchingCustomer = true;
// Let's find the UI displaying _customerName.
const customerNameTextRegex = /Text\(\s*_customerName\s*,\s*style:\s*TextStyle\(\s*fontSize:\s*13\.sp,\s*fontWeight:\s*FontWeight\.w800,\s*color:\s*_customerName\s*==\s*'Not found'\s*\?\s*Colors\.red\s*:\s*AppColors\.primaryGreen,\s*\),\s*\),/;

const loadingIndicatorCode = `Text(
                            _customerName,
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w800,
                              color: _customerName == 'Not found'
                                  ? Colors.red
                                  : AppColors.primaryGreen,
                            ),
                          ),
                          if (_isSearchingCustomer)
                            Padding(
                              padding: EdgeInsets.only(left: 8.w),
                              child: SizedBox(
                                width: 12.w,
                                height: 12.w,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.primaryGreen,
                                ),
                              ),
                            ),`;

cartCode = cartCode.replace(customerNameTextRegex, loadingIndicatorCode);

// 3. Qty Field Alignment and Padding
// The current layout is a Container with a Row containing GestureDetector(remove) -> SizedBox(TextField) -> GestureDetector(add)
const rowRegex = /GestureDetector\([\s\S]*?Icon\(Icons\.remove,[\s\S]*?SizedBox\([\s\S]*?TextFormField\([\s\S]*?GestureDetector\([\s\S]*?Icon\(Icons\.add,[\s\S]*?size:\s*16\.w\),\s*\),\s*\),/g;

// Wait, I will replace the container contents exactly by matching `child: Row(` inside that specific Container.
// Since regex might be tricky, I'll use simple string replace for the components.

// Fix remove icon padding
cartCode = cartCode.replace(
  "padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),\n                                      child: Icon(Icons.remove, color: const Color(0xFFC2185B), size: 16.w),",
  "padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),\n                                      child: Icon(Icons.remove, color: const Color(0xFFC2185B), size: 16.w),"
);

// Fix add icon padding
cartCode = cartCode.replace(
  "padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),\n                                      child: Icon(Icons.add, color: const Color(0xFFC2185B), size: 16.w),",
  "padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),\n                                      child: Icon(Icons.add, color: const Color(0xFFC2185B), size: 16.w),"
);

// Fix TextFormField centering by adding textAlignVertical and better height constraints
cartCode = cartCode.replace(
  /width:\s*36\.w,\s*height:\s*28\.h,/,
  "width: 48.w,\n                                    height: 36.h," // larger text field bounds
);

cartCode = cartCode.replace(
  /textAlign:\s*TextAlign\.center,/,
  "textAlign: TextAlign.center,\n                                      textAlignVertical: TextAlignVertical.center,"
);

cartCode = cartCode.replace(
  /contentPadding:\s*EdgeInsets\.zero,/,
  "contentPadding: EdgeInsets.only(bottom: 12.h), // adjusted for optical centering"
);

fs.writeFileSync(cartPath, cartCode);
console.log('Fixed cart page bugs');
