class FoodPageArgs {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  final double rating;
  final bool isVeg;
  final int initialQuantity;
  final List<CartSubItem> initialSubItems;

  FoodPageArgs({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.rating,
    required this.isVeg,
    required this.initialQuantity,
    required this.initialSubItems,
  });
}

class CartSubItem {
  final String id;
  final String name;
  final double price;
  final int quantity;
  CartSubItem({required this.id, required this.name, required this.price, required this.quantity});
}

class FoodPageResult {
  final int quantity;
  final List<CartSubItem> subItems;
  FoodPageResult({required this.quantity, required this.subItems});
}

class SearchSuggestion {
  final String label;
  SearchSuggestion(this.label);
}

class MindFoodItem {
  final String name;
  final String imageUrl;
  MindFoodItem(this.name, this.imageUrl);
}

class SearchResultRestaurant {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  final double rating;
  final String promoText;
  final bool isNearAndFast;
  final String deliveryTime;
  
  SearchResultRestaurant({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.rating,
    required this.promoText,
    required this.isNearAndFast,
    required this.deliveryTime,
  });
}

class SearchResultLargeRestaurant {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  final double rating;
  final String ratingCount;
  final String deliveryTime;
  final String distance;
  final String offer;
  final bool isPureVeg;
  final String dishSpotlight;
  final bool isAd;
  
  SearchResultLargeRestaurant({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.rating,
    required this.ratingCount,
    required this.deliveryTime,
    required this.distance,
    required this.offer,
    required this.isPureVeg,
    required this.dishSpotlight,
    required this.isAd,
  });
}

class SubCategory {
  final String id;
  final String name;
  final String imageUrl;
  
  SubCategory({required this.id, required this.name, required this.imageUrl});
}

class FoodSubItem {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  FoodSubItem({required this.id, required this.name, required this.price, required this.imageUrl});
}

class FoodReview {
  final String avatarUrl;
  final String userName;
  final String date;
  final double rating;
  final String reviewText;
  FoodReview({
    required this.avatarUrl,
    required this.userName,
    required this.date,
    required this.rating,
    required this.reviewText,
  });
}

class BannerItem {
  final String imageUrl;
  final String title;
  final String subtitle;
  final String buttonText;
  BannerItem({required this.imageUrl, required this.title, required this.subtitle, required this.buttonText});
}

class CategoryItem {
  final String id;
  final String name;
  final String imageUrl;
  final bool isSpecialCard;
  CategoryItem({required this.id, required this.name, required this.imageUrl, required this.isSpecialCard});
}

class RestaurantItem {
  final String id;
  final String name;
  final String imageUrl;
  final double rating;
  final String promoText;
  final String deliveryTime;
  final bool isNearAndFast;
  final double price;
  
  RestaurantItem({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.promoText,
    required this.deliveryTime,
    required this.isNearAndFast,
    required this.price,
  });
}

class ExploreMoreItem {
  final String title;
  final String imageUrl;
  final String iconType;
  ExploreMoreItem({required this.title, required this.imageUrl, required this.iconType});
}

class LargeRestaurantItem {
  final String id;
  final String name;
  final String imageUrl;
  final double rating;
  final String ratingCount;
  final String deliveryTime;
  final String distance;
  final List<String> offers;
  final bool isPureVeg;
  final String dishSpotlight;
  final bool isAd;
  final double price;
  final List<String> tags;
  
  LargeRestaurantItem({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.ratingCount,
    required this.deliveryTime,
    required this.distance,
    required this.offers,
    required this.isPureVeg,
    required this.dishSpotlight,
    required this.isAd,
    required this.price,
    required this.tags,
  });
}

// Dummy Lists
final List<SearchSuggestion> dummySearchSuggestions = [];
final List<MindFoodItem> dummyMindFoodItems = [];
final List<SearchResultRestaurant> dummySearchResultRecommended = [];
final List<SearchResultLargeRestaurant> dummySearchResultLarge = [];
final List<SubCategory> dummySubCategories = [];
final List<FoodSubItem> dummyFoodSubItems = [];
final List<String> dummyFoodExtraImages = [];
final List<FoodReview> dummyFoodReviews = [];
final List<BannerItem> dummyBanners = [];
final List<CategoryItem> dummyCategories = [];
final List<RestaurantItem> dummyRestaurants = [];
final List<ExploreMoreItem> dummyExploreMore = [];
final List<LargeRestaurantItem> dummyLargeRestaurants = [];
