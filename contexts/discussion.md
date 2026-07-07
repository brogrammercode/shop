What i want from web app:

- web app is totally for users (costumers)
- the first usecase is, on scan of qr code, the menu will be opened, the qr code will contain the branch info and order type info (if delivery or table)
- if table, qr code url will contain table info along with branch info
- update table models and schema and add/update some pages of mobile app in such a way that [SEE_BELOW_POINTS_FOR_FULL_FUNCTIONALITY_DESIRE]
- let's say i have a restaurant, where there is 3 tables with 4 person sitting in each side (not necessary, maybe only 2 or 3 side may be there where there are chairs placed) and 3 tables on the opposite side of road with same logic of person sitting system, means there may be many zones where there can be table placed
- each side of table will be containing a unique qr code which the costumers can scan and order menu items
- now let's say a group of 11 boys comes in which boys are sitting in table A (A1, A2), B(B1, B2, B3, B4), C(C1, C2, C3), D(D1, D2)
- here, C & D table is outside and A & B table is inside, A3 & A4 is occupied by a couple, C4 is occupied by a single guy
- now each person should order for themseleves or their group from single side as well, let's say when the borthday guy will scan qr code to order from qr code given in C1, then he will first select the menu items, huge amount, and in the cart page, he will select all the sides of tables he is involving in this order
- while opening menu and creating cart (selecting menu-items), the guy will not need to be logged in
- in cart page before placing order, the user will need to log in first, where his info will be preserved so that next time upon scanning any qr from same device, no need to login again
- now since user has logged in, the coupons/offers will appear before placing order and then when the guy will select the coupon and save some money then finally will place order
- the order will be made

- same flow will happen on delivery qr code that we will provide on billboards in roads
- user will scan that code and the qr code url will contain info that ok, this is for delivery
- again no need to login until cart making
- once ready to place order
- login if not
- then order placed
