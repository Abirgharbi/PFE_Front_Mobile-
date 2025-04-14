import 'dart:convert';
import 'package:arkea/utils/shared_preferences.dart';

import 'package:arkea/Model/cart_model.dart';
import 'package:arkea/Model/product_card_model.dart';
import 'package:arkea/Model/product_model.dart';
import 'package:arkea/ViewModel/product_controller.dart';
import 'package:arkea/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Model/order_model.dart';
import '../Model/promo_model.dart';
import '../Model/service/network_handler.dart';

var productController = Get.put(ProductController());

class OrderController extends GetxController {
  TextEditingController promoCode = TextEditingController();
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
  RxList productCarts = [].obs;
  @override
  void onInit() {
    super.onInit();
  }

  void addToCart(Product product) {

  
    Cart cart = Cart(product: product);
    if (product.quantity! > 0) {
      product.quantity = product.quantity! - 1;

      verifyProductExistence(cart);
      if (exist.isTrue) {
        final index = productCarts.indexOf(foundProduct);
        productCarts[index].quantity = productCarts[index].quantity + 1;
        exist.value = false;
      } else {
        productCarts.add(cart);
        sharedPrefs.setStringList(
          "cart",
          productCarts.map((e) => jsonEncode(e.toJson())).toList(),
        );
      }

      orderSum.value = 0.0; // Initialize orderSum to 0
      orderCost = 0.0; // Initialize orderCost to 0

      for (var i = 0; i < productCarts.length; i++) {
        orderSum.value +=
            productCarts[i].product.price * productCarts[i].quantity;
        sharedPrefs.setPref('orderSum', orderSum.value.toString());

        orderCost +=
            productCarts[i].product.productCost! * productCarts[i].quantity;
      }
    } else {
      Get.snackbar("Error", "Product out of stock");
    }
  }

  void decreaseQuantity(Product product) {
    Cart cart = Cart(product: product);

    product.quantity = product.quantity! + 1;

    final index = productCarts.indexOf(foundProduct);

    productCarts[index].quantity -= 1;

    orderSum.value -= product.price;
    sharedPrefs.setPref('orderSum', orderSum.value.toString());

    orderCost -= product.productCost!;
  }

  void verifyProductExistence(Cart cart) {
    exist.value = false;

    for (var i = 0; i < productCarts.length; i++) {
      if (productCarts[i].product.id == cart.product.id) {
        exist.value = true;
        foundProduct = productCarts[i];
        break;
      }
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
        sharedPrefs.setPref('orderSum', orderSum.value.toString());

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
    List<ProductCard> productCard = productCarts
        .map((cart) => ProductCard(
              id: cart.product.id,
              quantity: cart.quantity,
              price: cart.product.price,
              name: cart.product.name,
            ))
        .toList();

    final customerId = await sharedPrefs.getPref("customerId");
    final addressId = await sharedPrefs.getPref("addressId");

    Order order = Order()
      ..productCard = productCard.cast<ProductCard>()
      ..amount = orderSum.value
      ..revenue = orderSum.value - orderCost
      ..addressId = addressId
      ..customerId = customerId;

    print(jsonEncode(order));

    var response = await NetworkHandler.post(order, "order/add");
    print('-----------------');
    print(response);
    Map<String, dynamic> payload = {
      'spend': orderSum.value,
      'products': productCarts.map((cart) {
        return {
          'id': cart.product.id,
          'quantity': cart.product.quantity,
        };
      }).toList(),
    };

    await NetworkHandler.put(json.encode(payload), "product/update-after-sell");

    await NetworkHandler.put(
        '{"spend": ${orderSum.value}}', "user/customer/spending/$customerId");

    productCarts.clear();

    productCarts.value = [];
    sharedPrefs.removePref("cart");
    orderSum.value = 0.0;
    sharedPrefs.setPref('orderSum', orderSum.value.toString());
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
