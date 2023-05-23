import 'dart:convert';
import 'package:ARkea/utils/shared_preferences.dart';

import 'package:ARkea/Model/cart_model.dart';
import 'package:ARkea/Model/product_card_model.dart';
import 'package:ARkea/Model/product_model.dart';
import 'package:ARkea/ViewModel/product_controller.dart';
import 'package:ARkea/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Model/order_model.dart';
import '../Model/promo_model.dart';
import '../Model/service/network_handler.dart';

var productController = Get.put(ProductController());

class OrderController extends GetxController {
  TextEditingController promoCode = TextEditingController();
  List<Cart> productCarts = [];
  RxBool exist = false.obs;
  RxBool applyDisabled = false.obs;
  late Cart foundProduct;
  late Promo validPromo;
  RxDouble orderSum = 0.0.obs;
  double orderCost = 0.0;
  RxString message = "".obs;
  RxBool isAdded = false.obs;
  RxBool isValidCode = false.obs;
  List<Promo> validPromoList = [];

  RxInt productNbInCart = 0.obs;
  @override
  void onInit() {
    super.onInit();
    // getOrderSum();
  }

  void addToCart(Product product) {
    Cart cart = Cart(product: product);
    if (product.quantity! > 0) {
      product.quantity = product.quantity! - 1;

      verifyProductExistence(cart);
      if (exist.isTrue) {
        final index = productCarts.indexOf(foundProduct);

        productCarts[index].quantity = productCarts[index].quantity + 1;
      } else {
        productCarts.add(cart);
        sharedPrefs.setStringList(
          "cart",
          productCarts.map((e) => jsonEncode(e.toJson())).toList(),
        );
        productNbInCart.value = productCarts.length;
      }

      for (var i = 0; i < productCarts.length; i++) {
        orderSum.value =
            productCarts[i].product.price * productCarts[i].quantity;
        orderCost =
            (productCarts[i].product.productCost! * productCarts[i].quantity);
      }
    } else {
      Get.snackbar("Error", "Product out of stock");
    }
  }

  void decreaseQuantity(Product product) {
    Cart cart = Cart(product: product);
    product.quantity = product.quantity! + 1;

    final index = productCarts.indexOf(foundProduct);
    productCarts[index].quantity = productCarts[index].quantity - 1;

    orderSum.value = orderSum.value - product.price;
    orderCost = orderCost - product.productCost!;
  }

  void verifyProductExistence(Cart cart) {
    int i = 0;

    if (productCarts.isNotEmpty) {
      do {
        if (productCarts.elementAt(i).product.id == cart.product.id) {
          exist.value = true;
          foundProduct = productCarts.elementAt(i);
        }
        i++;
      } while (i < productCarts.length && exist.isFalse);
    }
  }

  void applyPromoCode() async {
    int i = 0;
    var response = await NetworkHandler.get("order/promo/getValidPromos");

    try {
      PromoModel promoModel = PromoModel.fromJson(json.decode(response));

      validPromoList = promoModel.promos;

      if (validPromoList.isNotEmpty) {
        do {
          if (validPromoList.elementAt(i).code == promoCode.text) {
            isValidCode.value = true;
            validPromo = validPromoList.elementAt(i);
          }
          i++;
        } while (i < validPromoList.length && isValidCode.isFalse);
      }

      if (isValidCode.isTrue) {
        double discount = validPromo.discount.toDouble();
        double calculatedValue = orderSum.value * (discount / 100);
        orderSum.value = double.parse(calculatedValue.toStringAsFixed(2));
        applyDisabled.value = true;
        message.value = "promotion applied";
      } else {
        message.value = "Invalid promo code";
      }
    } catch (e) {
      print(e);
    }
  }

  void showConfirmationDialog(Product product, Function(bool) onConfirmation) {
    Get.defaultDialog(
      title: 'Quantity Unavailable',
      content: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'We have left only ${product.quantity} from the "${product.name}" currently in our of stock. '
          'Would you like to add them anyway?',
        ),
      ),
      textConfirm: 'Add',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      cancelTextColor: MyColors.btnBorderColor,
      onConfirm: () => onConfirmation(true),
      onCancel: () => onConfirmation(false),
      buttonColor: MyColors.btnBorderColor,
      cancel: const Text('Cancel'),
      confirm: const Text('Add'),
    );
  }

  checkAvailability() async {
    Map<String, int> products = <String, int>{};
    for (var i = 0; i < productCarts.length; i++) {
      products.addAll(
          {productCarts[i].product.id.toString(): productCarts[i].quantity});
    }

    var response = await NetworkHandler.post(
        jsonEncode(products), "product/check-availability");

    ProductModel productModel = ProductModel.fromJson(jsonDecode(response));
    List<Product> productsUnavailable = productModel.products;

    for (var i = 0; i < productsUnavailable.length; i++) {
      showConfirmationDialog(productsUnavailable[i], (confirmed) {
        if (!confirmed) {
          productCarts.removeWhere(
              (element) => element.product.id == productsUnavailable[i].id);
          sharedPrefs.setStringList(
              "cart", productCarts.map((e) => jsonEncode(e)).toList());
        }
      });
    }
  }

  addOrder() async {
    Order order = Order();
    List<ProductCard> productCard = <ProductCard>[];

    for (var i = 0; i < productCarts.length; i++) {
      productCard.add(
        ProductCard(
          id: productCarts[i].product.id,
          quantity: productCarts[i].quantity,
          price: productCarts[i].product.price,
          name: productCarts[i].product.name,
        ),
      );
    }
    var revenue = orderSum.value - orderCost;
    final customerId =
        await sharedPrefs.getPref("customerId"); // Await the future
    final addressId = await sharedPrefs.getPref("addressId");
    order.productCard = productCard.cast<ProductCard>();
    order.amount = orderSum.value;
    order.revenue = revenue;
    order.addressId = addressId;
    order.customerId = customerId;

    var response =
        await NetworkHandler.post(json.encode(order.toJson()), "order/add");

    for (var i = 0; i < productCarts.length; i++) {
      await NetworkHandler.put(
          "product/update-after-sell/${productCarts[i].product.id}",
          '{"quantity": ${productCarts[i].product.quantity}}');
    }

    await NetworkHandler.put(
        '{"spend":${orderSum.value}}', "user/customer/spending/$customerId");

    productCarts = [];
    orderSum = 0.0.obs;
    print(productCarts.length);
  }

  Future<List<Order>> fetchOrders(String customerId) async {
    var response =
        await NetworkHandler.get("order/getCustomerOrders/$customerId");
    final data = jsonDecode(response);
    List<Order> fetchedOrders =
        List.from(data).map((json) => Order.fromJson(json)).toList();
    return fetchedOrders;
  }
}
