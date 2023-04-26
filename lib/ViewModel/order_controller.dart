import 'package:ARkea/Model/cart_model.dart';
import 'package:ARkea/Model/product_model.dart';
import 'package:ARkea/ViewModel/product_controller.dart';
import 'package:get/get.dart';

var productController = Get.put(ProductController());

class OrderController extends GetxController {
  List<Cart> demoCarts = [
    // Cart(product: productController.productList[0], quantity: 2),
    // Cart(product: productController.productList[0], quantity: 1),
    // Cart(product: productController.productList[0], quantity: 3),
  ];

  // final Product product;

  // final int quantity;

  RxInt productNbInCart = 0.obs;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    productNbInCart.value = demoCarts.length;
  }

  void addToCart(Product product) {
    int index = 0;
    bool exist = false;
    if (demoCarts.length != 0) {
      do {
        if (demoCarts.elementAt(0).product == product) {
          exist = true;
        }
        index++;
      } while (exist == false);
    }

    if (exist == true) {
      print("exists");
    } else {
      demoCarts.add(Cart(product: product, quantity: 0));
      productNbInCart.value = demoCarts.length;
    }

    print(demoCarts.elementAt(0).product.toJson().toString());
  }
}
