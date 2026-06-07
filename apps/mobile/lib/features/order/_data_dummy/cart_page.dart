class CartAddress {
  final String title;
  final String fullAddress;
  final double distanceInMeters;
  final String phoneNumber;
  final bool deliversTo;

  const CartAddress({
    required this.title,
    required this.fullAddress,
    required this.distanceInMeters,
    required this.phoneNumber,
    required this.deliversTo,
  });
}

class PairingDish {
  final String name;
  final double price;
  final String imageUrl;
  final bool isVeg;
  final String sizeInfo;

  const PairingDish({
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.isVeg,
    required this.sizeInfo,
  });
}

class PaymentMethod {
  final String id;
  final String name;
  final String iconType;

  const PaymentMethod({
    required this.id,
    required this.name,
    required this.iconType,
  });
}

const List<CartAddress> dummyAddresses = [
  CartAddress(
    title: 'Home',
    fullAddress: 'Barari High School, Housing Board Colony, Barari',
    distanceInMeters: 0,
    phoneNumber: '+91-6204245184',
    deliversTo: true,
  ),
  CartAddress(
    title: 'Home',
    fullAddress: 'BOYS HOSTEL 2 RRSDCE COLLEGE BEGUSARAI, Singhaul Dih',
    distanceInMeters: 94000,
    phoneNumber: '+91-6204245184',
    deliversTo: false,
  ),
];

const List<PairingDish> dummyPairingDishes = [
  PairingDish(
    name: 'Matti [5 Pieces]',
    price: 264,
    imageUrl: 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?w=500',
    isVeg: true,
    sizeInfo: '5 Pieces',
  ),
  PairingDish(
    name: 'Paneer Masala Dosa',
    price: 253,
    imageUrl: 'https://images.unsplash.com/photo-1668236543090-82eba5ee5976?w=500',
    isVeg: true,
    sizeInfo: 'Normal Polybag Packing',
  ),
  PairingDish(
    name: 'Matar Paneer Masala',
    price: 248,
    imageUrl: 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?w=500',
    isVeg: true,
    sizeInfo: 'Standard Serving',
  ),
  PairingDish(
    name: 'Cheese Masala Dosa',
    price: 253,
    imageUrl: 'https://images.unsplash.com/photo-1668236543090-82eba5ee5976?w=500',
    isVeg: true,
    sizeInfo: 'Normal Polybag Packing',
  ),
];

const List<PaymentMethod> dummyPaymentMethods = [
  PaymentMethod(id: 'paytm', name: 'Paytm UPI', iconType: 'paytm'),
  PaymentMethod(id: 'gpay', name: 'Google Pay UPI', iconType: 'gpay'),
  PaymentMethod(id: 'navi', name: 'Navi UPI', iconType: 'navi'),
  PaymentMethod(id: 'whatsapp', name: 'Whatsapp UPI', iconType: 'whatsapp'),
  PaymentMethod(id: 'amazon', name: 'Amazon Pay Balance', iconType: 'amazon'),
  PaymentMethod(id: 'mobikwik', name: 'Mobikwik', iconType: 'mobikwik'),
];

