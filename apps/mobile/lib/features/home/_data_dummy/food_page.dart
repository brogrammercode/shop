class FoodSubItem {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  final bool isVeg;

  const FoodSubItem({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.isVeg,
  });
}

class FoodReview {
  final String userName;
  final String avatarUrl;
  final double rating;
  final String date;
  final String reviewText;

  const FoodReview({
    required this.userName,
    required this.avatarUrl,
    required this.rating,
    required this.date,
    required this.reviewText,
  });
}

class CartSubItem {
  final String id;
  final String name;
  final double price;
  int quantity;

  CartSubItem({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
  });
}

class FoodPageArgs {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  final double rating;
  final bool isVeg;
  final int initialQuantity;
  final List<CartSubItem> initialSubItems;

  const FoodPageArgs({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.rating,
    required this.isVeg,
    this.initialQuantity = 1,
    this.initialSubItems = const [],
  });
}

class FoodPageResult {
  final int quantity;
  final List<CartSubItem> subItems;

  const FoodPageResult({
    required this.quantity,
    required this.subItems,
  });
}

const List<String> dummyFoodExtraImages = [
  'https://images.unsplash.com/photo-1586190848861-99aa4a171e90?w=800',
  'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=800',
  'https://images.unsplash.com/photo-1625938144755-652e08e359b7?w=800',
];

const List<FoodSubItem> dummyFoodSubItems = [
  FoodSubItem(
    id: 'sub_1',
    name: 'Mint Chutney',
    price: 15,
    imageUrl: 'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=300',
    isVeg: true,
  ),
  FoodSubItem(
    id: 'sub_2',
    name: 'Masala Papad',
    price: 29,
    imageUrl: 'https://images.unsplash.com/photo-1605197785406-a3c795d53e26?w=300',
    isVeg: true,
  ),
  FoodSubItem(
    id: 'sub_3',
    name: 'Coca-Cola 300ml',
    price: 40,
    imageUrl: 'https://images.unsplash.com/photo-1581636625402-29b2a704ef13?w=300',
    isVeg: true,
  ),
  FoodSubItem(
    id: 'sub_4',
    name: 'Sweet Raita',
    price: 35,
    imageUrl: 'https://images.unsplash.com/photo-1589302168068-964664d93dc0?w=300',
    isVeg: true,
  ),
  FoodSubItem(
    id: 'sub_5',
    name: 'Chocolate Mousse',
    price: 79,
    imageUrl: 'https://images.unsplash.com/photo-1511715112108-9acc5f8474e5?w=300',
    isVeg: true,
  ),
  FoodSubItem(
    id: 'sub_6',
    name: 'Extra Sauce',
    price: 10,
    imageUrl: 'https://images.unsplash.com/photo-1472476443507-c7a5948772fc?w=300',
    isVeg: true,
  ),
  FoodSubItem(
    id: 'sub_7',
    name: 'Nimbu Pani',
    price: 25,
    imageUrl: 'https://images.unsplash.com/photo-1523677011781-c91d1bbe2f9e?w=300',
    isVeg: true,
  ),
  FoodSubItem(
    id: 'sub_8',
    name: 'Gulab Jamun',
    price: 37,
    imageUrl: 'https://images.unsplash.com/photo-1601050690597-df056fb4ce78?w=300',
    isVeg: true,
  ),
];

const List<FoodReview> dummyFoodReviews = [
  FoodReview(
    userName: 'Rahul Sharma',
    avatarUrl: 'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=100',
    rating: 4.5,
    date: '2 days ago',
    reviewText: 'Absolutely delicious! The texture was perfect and it arrived fresh. Will definitely order again. Highly recommended for sweet lovers!',
  ),
  FoodReview(
    userName: 'Priya Mehta',
    avatarUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100',
    rating: 5.0,
    date: '1 week ago',
    reviewText: 'Best I\'ve had in a long time. Quality packaging ensured it reached in great condition. The flavour is authentic and not too sweet.',
  ),
  FoodReview(
    userName: 'Amit Singh',
    avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100',
    rating: 4.0,
    date: '2 weeks ago',
    reviewText: 'Good value for money. Taste is good but portion size could be a little bigger. Overall satisfied with the order.',
  ),
  FoodReview(
    userName: 'Neha Gupta',
    avatarUrl: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=100',
    rating: 4.5,
    date: '3 weeks ago',
    reviewText: 'Ordered for a family gathering and everyone loved it. Freshness was top-notch and delivery was on time. Great experience!',
  ),
];

