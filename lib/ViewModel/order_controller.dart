import 'package:ARkea/Model/cart_model.dart';
import 'package:ARkea/Model/product_model.dart';
import 'package:ARkea/ViewModel/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

var productController = Get.put(ProductController());

class OrderController extends GetxController {
  final RxList<Cart> demoCarts = RxList<Cart>([]);
  RxBool exist = false.obs;
  late Cart foundProduct;
  RxDouble orderSum = 0.0.obs;
  RxBool isAdded = false.obs;

  RxInt productNbInCart = 0.obs;
  @override
  void onInit() {
    super.onInit();
    // getOrderSum();
  }

  void addToCart(Product product) {
    // print(product.quantity);
    Cart cart = Cart(product: product);

    print(demoCarts);
    verifyProductExistence(cart);
    if (exist.isTrue) {
      final index = demoCarts.indexOf(foundProduct);
      demoCarts[index].quantity = demoCarts[index].quantity + 1;

      print("exists");
    } else {
      demoCarts.add(cart);
      productNbInCart.value = demoCarts.length;
    }

    for (var i = 0; i < demoCarts.length; i++) {
      orderSum.value = demoCarts[i].product.price * demoCarts[i].quantity;
    }
  }

  void decreaseQuantity(Product product) {
    Cart cart = Cart(product: product);

    final index = demoCarts.indexOf(foundProduct);
    demoCarts[index].quantity = demoCarts[index].quantity - 1;

    orderSum.value = orderSum.value - product.price;
  }

  void verifyProductExistence(Cart cart) {
    int i = 0;

    if (demoCarts.length != 0) {
      do {
        if (demoCarts.elementAt(i).product == cart.product) {
          exist.value = true;
          foundProduct = demoCarts.elementAt(i);
        }
        i++;
      } while (i < demoCarts.length && exist.isFalse);
    }
  }
}
