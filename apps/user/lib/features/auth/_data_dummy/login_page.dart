
class LoginSlide {
  final String title;
  final String logoText;
  final String imageUrl;
  final bool isSpecialDeals;

  const LoginSlide({
    required this.title,
    required this.logoText,
    required this.imageUrl,
    this.isSpecialDeals = false,
  });
}

class LoginAccount {
  final String name;
  final String phoneNumber;
  final String avatarUrl;

  const LoginAccount({
    required this.name,
    required this.phoneNumber,
    required this.avatarUrl,
  });
}

const List<LoginSlide> dummyLoginSlides = [
  LoginSlide(
    title: "INDIA'S #1 FOOD\nDELIVERY APP",
    logoText: "zomato",
    imageUrl: "https://images.unsplash.com/photo-1513104890138-7c749659a591?w=800",
  ),
  LoginSlide(
    title: "FIND THE BEST\nDEALS ON EVERY MEAL",
    logoText: "%",
    imageUrl: "https://images.unsplash.com/photo-1607349913338-fca6f7fc42d0?w=800",
    isSpecialDeals: true,
  ),
  LoginSlide(
    title: "SAFE AND HYGIENIC\nDELIVERY ALWAYS",
    logoText: "zomato",
    imageUrl: "https://images.unsplash.com/photo-1534080391025-097b03b27340?w=800",
  ),
  LoginSlide(
    title: "TRACK YOUR ORDER\nIN REAL-TIME",
    logoText: "zomato",
    imageUrl: "https://images.unsplash.com/photo-1526625303811-6f947f6b86e9?w=800",
  ),
];

const LoginAccount dummyLoginAccount = LoginAccount(
  name: "Harsh",
  phoneNumber: "+91 6XXXX X4184",
  avatarUrl: "https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=500",
);
