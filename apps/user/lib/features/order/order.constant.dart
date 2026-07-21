import 'order.model.dart';

class OrderConstants {
  static const String ORDER_TYPE_DELIVERY = 'DELIVERY';
  static const String LADYLUCK_BRANCH_ID = '1783064192233';
  static const String LADYLUCK_SUMMARY_ENDPOINT = '/api/v1/ladyluck/summary';
  static const String LADYLUCK_SCRATCH_CARD_ENDPOINT = '/api/v1/ladyluck/scratch-cards';
  static const String POS_ORDERS_ENDPOINT = '/api/v1/pos-kds/orders';
}

class OrderMessages {
  static const String CART_EMPTY = 'Cart is empty';
  static const String ORDER_SUCCESS = 'Order placed successfully!';
  static const String LADYLUCK_SCRATCH_FAILED = 'Unable to scratch card';
  static const String LADYLUCK_POINTS = 'Ladyluck points';
  static const String LADYLUCK_REWARDS = 'Ladyluck Rewards';
  static const String LADYLUCK_SCRATCH_READY = 'Scratch card ready';
  static const String LADYLUCK_SCRATCH_BODY = 'Scratch to unlock your order discount.';
  static const String LADYLUCK_SCRATCH_NOW = 'SCRATCH';
  static const String LADYLUCK_APPLIED = 'Ladyluck applied';
  static const String LADYLUCK_NO_CARD = 'Earn 500 points to unlock a scratch card.';
  static const String LADYLUCK_DISCOUNT = 'Ladyluck discount';
  static const String MINIMUM_ORDER = 'Min order';
}

final List<PaymentMethod> dummyPaymentMethods = [
  const PaymentMethod(id: 'paytm', name: 'Paytm', iconType: 'paytm'),
  const PaymentMethod(id: 'gpay', name: 'GPay', iconType: 'gpay'),
  const PaymentMethod(id: 'navi', name: 'Navi', iconType: 'navi'),
  const PaymentMethod(id: 'whatsapp', name: 'WhatsApp', iconType: 'whatsapp'),
  const PaymentMethod(id: 'amazon', name: 'Amazon Pay', iconType: 'amazon'),
  const PaymentMethod(id: 'mobikwik', name: 'MobiKwik', iconType: 'mobikwik'),
];

final List<CartAddress> dummyAddresses = [
  const CartAddress(
    title: 'Home',
    fullAddress: '123 Main Street, Phase 2, City',
    phoneNumber: '+91 9876543210',
    deliversTo: true,
  ),
  const CartAddress(
    title: 'Work',
    fullAddress: 'Tech Park, Block B, City',
    phoneNumber: '+91 9876543210',
    deliversTo: false,
  ),
];

final List<PairingDish> dummyPairingDishes = [
  const PairingDish(
    name: 'Extra Chutney',
    price: 15,
    imageUrl: 'https://images.unsplash.com/photo-1548943487-a2e4b43b4850?w=500',
    sizeInfo: '1 Portion',
    isVeg: true,
  ),
  const PairingDish(
    name: 'Gulab Jamun',
    price: 45,
    imageUrl: 'https://images.unsplash.com/photo-1598514982205-f36b96d1e8d4?w=500',
    sizeInfo: '2 Pieces',
    isVeg: true,
  ),
];
