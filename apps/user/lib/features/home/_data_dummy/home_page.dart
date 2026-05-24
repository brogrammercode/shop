class CategoryItem {
  final String id;
  final String name;
  final String imageUrl;
  final bool isSpecialCard;
  final String? subtitle;

  const CategoryItem({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.isSpecialCard = false,
    this.subtitle,
  });
}

class PromoBanner {
  final String id;
  final String title;
  final String subtitle;
  final String buttonText;
  final String imageUrl;

  const PromoBanner({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.imageUrl,
  });
}

class RestaurantItem {
  final String id;
  final String name;
  final double rating;
  final String promoText;
  final String deliveryTime;
  final String imageUrl;
  final bool isNearAndFast;

  const RestaurantItem({
    required this.id,
    required this.name,
    required this.rating,
    required this.promoText,
    required this.deliveryTime,
    required this.imageUrl,
    this.isNearAndFast = true,
  });
}

class ExploreMoreItem {
  final String title;
  final String iconType;

  const ExploreMoreItem({
    required this.title,
    required this.iconType,
  });
}

class LargeRestaurantItem {
  final String id;
  final String name;
  final double rating;
  final String ratingCount;
  final List<String> tags;
  final List<String> offers;
  final String imageUrl;

  const LargeRestaurantItem({
    required this.id,
    required this.name,
    required this.rating,
    required this.ratingCount,
    required this.tags,
    required this.offers,
    required this.imageUrl,
  });
}

const List<CategoryItem> dummyCategories = [
  CategoryItem(
    id: 'special_offer',
    name: 'MEALS UNDER',
    imageUrl: 'https://images.unsplash.com/photo-1607349913338-fca6f7fc42d0?w=200',
    isSpecialCard: true,
    subtitle: '₹250 Explore >',
  ),
  CategoryItem(
    id: 'all',
    name: 'All',
    imageUrl: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400',
  ),
  CategoryItem(
    id: 'sweets',
    name: 'Sweets',
    imageUrl: 'https://images.unsplash.com/photo-1587314168485-3236d6710814?w=400',
  ),
  CategoryItem(
    id: 'pizza',
    name: 'Pizza',
    imageUrl: 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=400',
  ),
  CategoryItem(
    id: 'cake',
    name: 'Cake',
    imageUrl: 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=400',
  ),
];

const List<PromoBanner> dummyBanners = [
  PromoBanner(
    id: 'gold_sale',
    title: 'GOLD FLASH SALE',
    subtitle: '₹1 for 3 months',
    buttonText: 'Renew Gold now →',
    imageUrl: 'https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=800',
  ),
  PromoBanner(
    id: 'zpl_cricket',
    title: 'ZPL HAND CRICKET',
    subtitle: 'PLAY & WIN',
    buttonText: 'Play ZPL Now →',
    imageUrl: 'https://images.unsplash.com/photo-1531482615713-2afd69097998?w=800',
  ),
];

const List<RestaurantItem> dummyRestaurants = [
  RestaurantItem(
    id: '1',
    name: 'Roop Vihar Resorts',
    rating: 4.3,
    promoText: '₹100 OFF above ₹1049',
    deliveryTime: '30-35 mins',
    imageUrl: 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=500',
    isNearAndFast: true,
  ),
  RestaurantItem(
    id: '2',
    name: 'Fire N Ice',
    rating: 4.2,
    promoText: '40% OFF up to ₹80',
    deliveryTime: '25-30 mins',
    imageUrl: 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?w=500',
    isNearAndFast: true,
  ),
  RestaurantItem(
    id: '3',
    name: 'Cake N Ice',
    rating: 4.1,
    promoText: '₹60 OFF above ₹99',
    deliveryTime: '40-45 mins',
    imageUrl: 'https://images.unsplash.com/photo-1606787366850-de6330128bfc?w=500',
    isNearAndFast: true,
  ),
  RestaurantItem(
    id: '4',
    name: '11:11 Cafe And Res...',
    rating: 3.7,
    promoText: '₹40 OFF above ₹99',
    deliveryTime: '30-35 mins',
    imageUrl: 'https://images.unsplash.com/photo-1569058242253-92a9c755a0ec?w=500',
    isNearAndFast: true,
  ),
  RestaurantItem(
    id: '5',
    name: "Prabha's Kitchen",
    rating: 3.9,
    promoText: '40% OFF up to ₹80',
    deliveryTime: '30-35 mins',
    imageUrl: 'https://images.unsplash.com/photo-1551024601-bec78aea704b?w=500',
    isNearAndFast: false,
  ),
  RestaurantItem(
    id: '6',
    name: "Domino's Pizza",
    rating: 4.4,
    promoText: '20% OFF up to ₹50',
    deliveryTime: '20-25 mins',
    imageUrl: 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=500',
    isNearAndFast: true,
  ),
];

const List<ExploreMoreItem> dummyExploreMore = [
  ExploreMoreItem(
    title: 'Offers',
    iconType: 'offers',
  ),
  ExploreMoreItem(
    title: 'Play & win',
    iconType: 'play_win',
  ),
  ExploreMoreItem(
    title: 'Food on train',
    iconType: 'train',
  ),
  ExploreMoreItem(
    title: 'Collections',
    iconType: 'collections',
  ),
];

const List<LargeRestaurantItem> dummyLargeRestaurants = [
  LargeRestaurantItem(
    id: 'large_1',
    name: 'Roop Vihar Resorts',
    rating: 4.3,
    ratingCount: 'By 800+',
    tags: ['Near & Fast'],
    offers: ['Flat ₹100 OFF above ₹1049', 'Extra 15% OFF'],
    imageUrl: 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=800',
  ),
  LargeRestaurantItem(
    id: 'large_2',
    name: '11:11 Cafe And Restaurant',
    rating: 3.7,
    ratingCount: 'By 1.7K+',
    tags: ['Near & Fast'],
    offers: ['Flat ₹40 OFF above ₹99', 'Extra 10% OFF'],
    imageUrl: 'https://images.unsplash.com/photo-1569058242253-92a9c755a0ec?w=800',
  ),
  LargeRestaurantItem(
    id: 'large_3',
    name: "Prabha's Kitchen",
    rating: 3.9,
    ratingCount: 'By 500+',
    tags: ['Near & Fast', 'Vegetarian'],
    offers: ['Flat ₹80 OFF above ₹149', 'Extra 12% OFF'],
    imageUrl: 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?w=800',
  ),
];
