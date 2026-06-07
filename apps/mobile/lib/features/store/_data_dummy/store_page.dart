class QuantityOption {
  final String label;
  final double price;

  const QuantityOption({
    required this.label,
    required this.price,
  });
}

class DishItem {
  final String id;
  final String name;
  final double price;
  final String description;
  final String imageUrl;
  final String badge;
  final bool isVeg;
  final List<QuantityOption> options;

  const DishItem({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.imageUrl,
    required this.badge,
    required this.isVeg,
    required this.options,
  });
}

class StoreDetails {
  final String name;
  final double rating;
  final String ratingCount;
  final String distance;
  final String locality;
  final String deliveryTime;
  final String scheduleLabel;
  final String vegStatus;
  final String complaintsText;
  final String mainOffer;
  final String totalOffersText;

  const StoreDetails({
    required this.name,
    required this.rating,
    required this.ratingCount,
    required this.distance,
    required this.locality,
    required this.deliveryTime,
    required this.scheduleLabel,
    required this.vegStatus,
    required this.complaintsText,
    required this.mainOffer,
    required this.totalOffersText,
  });
}

const StoreDetails dummyStoreDetails = StoreDetails(
  name: 'Adarsh Jalpan',
  rating: 4.1,
  ratingCount: 'By 21K+',
  distance: '5.5 km',
  locality: 'Bhagalpur Locality',
  deliveryTime: '30-35 mins',
  scheduleLabel: 'Schedule for later',
  vegStatus: 'Pure Veg',
  complaintsText: 'Last 100 orders without complaints',
  mainOffer: 'Flat ₹80 OFF above ₹199',
  totalOffersText: '7 offers',
);

const List<DishItem> dummyStoreDishes = [
  DishItem(
    id: 'dish_sohan_papdi',
    name: 'Sohan Papdi',
    price: 53,
    description: 'A popular Indian dessert. It is usually cube shaped or served as flakes, and has a crisp and flaky texture.',
    imageUrl: 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?w=500',
    badge: 'Highly reordered',
    isVeg: true,
    options: [
      QuantityOption(label: '2 Pieces', price: 53),
      QuantityOption(label: '5 Pieces', price: 132),
      QuantityOption(label: '10 Pieces', price: 264),
    ],
  ),
  DishItem(
    id: 'dish_kaju_barfi',
    name: 'Kaju Barfi',
    price: 75,
    description: 'Kaju Barfi made with cashew nuts and milk, topped with silver varq. The sweet of every occasion ...more',
    imageUrl: 'https://images.unsplash.com/photo-1601050690597-df056fb4ce78?w=500',
    badge: 'Highly reordered',
    isVeg: true,
    options: [
      QuantityOption(label: '2 Pieces', price: 75),
      QuantityOption(label: '5 Pieces', price: 180),
      QuantityOption(label: '10 Pieces', price: 350),
    ],
  ),
];

