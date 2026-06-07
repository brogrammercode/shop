class SearchSuggestion {
  final String label;

  const SearchSuggestion(this.label);
}

class MindFoodItem {
  final String name;
  final String imageUrl;

  const MindFoodItem({
    required this.name,
    required this.imageUrl,
  });
}

const List<SearchSuggestion> dummySearchSuggestions = [
  SearchSuggestion('Desk-friendly options'),
  SearchSuggestion('Crunchy and crispy'),
  SearchSuggestion('Kuch chatpata ho jaye?'),
  SearchSuggestion('Healthy bites'),
];

const List<MindFoodItem> dummyMindFoodItems = [
  MindFoodItem(
    name: 'Under ₹250',
    imageUrl: 'https://images.unsplash.com/photo-1509722747041-616f39b57569?w=400',
  ),
  MindFoodItem(
    name: 'Sweets',
    imageUrl: 'https://images.unsplash.com/photo-1587314168485-3236d6710814?w=400',
  ),
  MindFoodItem(
    name: 'Pizza',
    imageUrl: 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=400',
  ),
  MindFoodItem(
    name: 'Cake',
    imageUrl: 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=400',
  ),
  MindFoodItem(
    name: 'Biryani',
    imageUrl: 'https://images.unsplash.com/photo-1633945274405-b6c8069047b0?w=400',
  ),
  MindFoodItem(
    name: 'Paneer',
    imageUrl: 'https://images.unsplash.com/photo-1601050690597-df056fb4ce78?w=400',
  ),
  MindFoodItem(
    name: 'Rolls',
    imageUrl: 'https://images.unsplash.com/photo-1626700051175-6518c4793f4f?w=400',
  ),
  MindFoodItem(
    name: 'Dosa',
    imageUrl: 'https://images.unsplash.com/photo-1668236543090-82eba5ee5976?w=400',
  ),
  MindFoodItem(
    name: 'Noodles',
    imageUrl: 'https://images.unsplash.com/photo-1585032226651-759b368d7246?w=400',
  ),
  MindFoodItem(
    name: 'Momo',
    imageUrl: 'https://images.unsplash.com/photo-1625220194771-7ebedd0b70b9?w=400',
  ),
  MindFoodItem(
    name: 'North Indian',
    imageUrl: 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?w=400',
  ),
  MindFoodItem(
    name: 'Burger',
    imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400',
  ),
  MindFoodItem(
    name: 'Chinese',
    imageUrl: 'https://images.unsplash.com/photo-1526318896980-cf78c088247c?w=400',
  ),
  MindFoodItem(
    name: 'Manchurian',
    imageUrl: 'https://images.unsplash.com/photo-1626132647523-66f5bf380027?w=400',
  ),
  MindFoodItem(
    name: 'Italian',
    imageUrl: 'https://images.unsplash.com/photo-1551183053-bf91a1d81141?w=400',
  ),
  MindFoodItem(
    name: 'Samosa',
    imageUrl: 'https://images.unsplash.com/photo-1601050690697-df056fb4ce78?w=400',
  ),
  MindFoodItem(
    name: 'Tiramisu',
    imageUrl: 'https://images.unsplash.com/photo-1571877227200-a0d98ea607e9?w=400',
  ),
  MindFoodItem(
    name: 'Chaat',
    imageUrl: 'https://images.unsplash.com/photo-1606491956689-2ea866880c84?w=400',
  ),
];

