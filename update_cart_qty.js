const fs = require('fs');
const cartPath = 'apps/mobile/lib/features/pos_kds/pos.cart.page.dart';
let code = fs.readFileSync(cartPath, 'utf8');

// Replace the simple qty Text with a TextField
const textQtyRegex = /Text\(\s*'\$qty',\s*style:\s*TextStyle\([\s\S]*?color:\s*const Color\(0xFFC2185B\),\s*\),\s*\),/;
const textFieldReplacement = `
                                  SizedBox(
                                    width: 36.w,
                                    height: 28.h,
                                    child: TextFormField(
                                      initialValue: '$qty',
                                      keyboardType: TextInputType.number,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w900,
                                        color: const Color(0xFFC2185B),
                                      ),
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.zero,
                                      ),
                                      onChanged: (val) {
                                        final newQty = int.tryParse(val);
                                        if (newQty != null) {
                                          context.read<PosKdsCubit>().setCartQuantity(item.id, newQty);
                                        }
                                      },
                                    ),
                                  ),`;

code = code.replace(textQtyRegex, textFieldReplacement);

fs.writeFileSync(cartPath, code);
console.log('Updated Qty TextField');
