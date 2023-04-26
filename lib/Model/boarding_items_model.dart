class Items {
  final String img;
  final String title;
  final String subTitle;

  Items({
    required this.img,
    required this.title,
    required this.subTitle,
  });
}

List<Items> listOfItems = [
  Items(
    img: "assets/images/1.png",
    title: "Choose Product ",
    subTitle: "Choose your product from our \nshop",
  ),
  Items(
    img: "assets/images/2.png",
    title: "Make Payment",
    subTitle: "Easy Checkout & Safe Payment \nmethod.",
  ),
  Items(
    img: "assets/images/3.png",
    title: "Get Your Order",
    subTitle: "We Deliver your product the \nfastest way possible",
  ),
];
