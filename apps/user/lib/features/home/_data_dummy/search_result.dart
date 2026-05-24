class SubCategoryItem {
  final String id;
  final String name;
  final String imageUrl;

  const SubCategoryItem({
    required this.id,
    required this.name,
    required this.imageUrl,
  });
}

class SearchResultRestaurant {
  final String id;
  final String name;
  final double rating;
  final String promoText;
  final String deliveryTime;
  final String imageUrl;
  final bool isNearAndFast;

  const SearchResultRestaurant({
    required this.id,
    required this.name,
    required this.rating,
    required this.promoText,
    required this.deliveryTime,
    required this.imageUrl,
    required this.isNearAndFast,
  });
}

class SearchResultLargeRestaurant {
  final String id;
  final String name;
  final double rating;
  final String ratingCount;
  final String deliveryTime;
  final String distance;
  final String offer;
  final String dishSpotlight;
  final String imageUrl;
  final bool isPureVeg;
  final bool isAd;

  const SearchResultLargeRestaurant({
    required this.id,
    required this.name,
    required this.rating,
    required this.ratingCount,
    required this.deliveryTime,
    required this.distance,
    required this.offer,
    required this.dishSpotlight,
    required this.imageUrl,
    required this.isPureVeg,
    required this.isAd,
  });
}

const List<SubCategoryItem> dummySubCategories = [
  SubCategoryItem(
    id: 'sweets',
    name: 'Sweets',
    imageUrl: 'https://images.unsplash.com/photo-1587314168485-3236d6710814?w=400',
  ),
  SubCategoryItem(
    id: 'milk_sweets',
    name: 'Milk Sweets',
    imageUrl: 'https://images.unsplash.com/photo-1509722747041-616f39b57569?w=400',
  ),
  SubCategoryItem(
    id: 'kaju_katli',
    name: 'Kaju Katli',
    imageUrl: 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?w=400',
  ),
  SubCategoryItem(
    id: 'bengali_sweets',
    name: 'Bengali S...',
    imageUrl: 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=400',
  ),
  SubCategoryItem(
    id: 'gulab_jamun',
    name: 'Gulab...',
    imageUrl: 'https://images.unsplash.com/photo-1601050690597-df056fb4ce78?w=400',
  ),
];

const List<SearchResultRestaurant> dummySearchResultRecommended = [
  SearchResultRestaurant(
    id: 'rec_1',
    name: 'Roop Vihar Resorts',
    rating: 4.3,
    promoText: '₹100 OFF above ₹1049',
    deliveryTime: '20-25 mins',
    imageUrl: 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=500',
    isNearAndFast: true,
  ),
  SearchResultRestaurant(
    id: 'rec_2',
    name: 'Adarsh Jalpan',
    rating: 4.1,
    promoText: '50% OFF select items',
    deliveryTime: '30-35 mins',
    imageUrl: 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?w=500',
    isNearAndFast: false,
  ),
  SearchResultRestaurant(
    id: 'rec_3',
    name: 'Devendra Jalpan',
    rating: 4.1,
    promoText: '₹60 OFF above ₹99',
    deliveryTime: '30-35 mins',
    imageUrl: 'https://images.unsplash.com/photo-1606787366850-de6330128bfc?w=500',
    isNearAndFast: false,
  ),
  SearchResultRestaurant(
    id: 'rec_4',
    name: "Prabha's Kitchen",
    rating: 3.9,
    promoText: '40% OFF up to ₹80',
    deliveryTime: '25-30 mins',
    imageUrl: 'https://images.unsplash.com/photo-1551024601-bec78aea704b?w=500',
    isNearAndFast: true,
  ),
  SearchResultRestaurant(
    id: 'rec_5',
    name: 'Vanakkam Sweets',
    rating: 4.4,
    promoText: '₹120 OFF above ₹199',
    deliveryTime: '30-35 mins',
    imageUrl: 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=500',
    isNearAndFast: false,
  ),
  SearchResultRestaurant(
    id: 'rec_6',
    name: 'Vanakkam',
    rating: 4.2,
    promoText: '₹60 OFF above ₹99',
    deliveryTime: '30-35 mins',
    imageUrl: 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=500',
    isNearAndFast: false,
  ),
];

const List<SearchResultLargeRestaurant> dummySearchResultLarge = [
  SearchResultLargeRestaurant(
    id: 'large_res_1',
    name: 'Adarsh Jalpan',
    rating: 4.1,
    ratingCount: 'By 21K+',
    deliveryTime: '30-35 mins',
    distance: '5.5 km',
    offer: '50% OFF on select items',
    dishSpotlight: 'Sohan Papdi - ₹53',
    imageUrl: 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?w=800',
    isPureVeg: true,
    isAd: true,
  ),
  SearchResultLargeRestaurant(
    id: 'large_res_2',
    name: 'Vanakkam Sweets',
    rating: 4.4,
    ratingCount: 'By 900+',
    deliveryTime: '30-35 mins',
    distance: '5.5 km',
    offer: 'Flat ₹120 OFF above ₹199',
    dishSpotlight: 'Safed Rasgulla - ₹45',
    imageUrl: 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=800',
    isPureVeg: true,
    isAd: false,
  ),
  SearchResultLargeRestaurant(
    id: 'large_res_3',
    name: 'Devendra Jalpan',
    rating: 4.1,
    ratingCount: 'By 12K+',
    deliveryTime: '30-35 mins',
    distance: '5.5 km',
    offer: 'Flat ₹60 OFF above ₹99',
    dishSpotlight: 'Gulab Jamun - ₹37',
    imageUrl: 'https://images.unsplash.com/photo-1601050690597-df056fb4ce78?w=800',
    isPureVeg: false,
    isAd: true,
  ),
];
