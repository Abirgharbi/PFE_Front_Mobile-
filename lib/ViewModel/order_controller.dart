import 'dart:convert';

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
  final RxList<Cart> demoCarts = RxList<Cart>([]);
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
        final index = demoCarts.indexOf(foundProduct);

        demoCarts[index].quantity = demoCarts[index].quantity + 1;
      } else {
        demoCarts.add(cart);
        productNbInCart.value = demoCarts.length;
      }

      for (var i = 0; i < demoCarts.length; i++) {
        orderSum.value = demoCarts[i].product.price * demoCarts[i].quantity;
        orderCost = (demoCarts[i].product.productCost! * demoCarts[i].quantity);
      }
    } else {
      Get.snackbar("Error", "Product out of stock");
    }
  }

  void decreaseQuantity(Product product) {
    Cart cart = Cart(product: product);
    product.quantity = product.quantity! + 1;

    final index = demoCarts.indexOf(foundProduct);
    demoCarts[index].quantity = demoCarts[index].quantity - 1;

    orderSum.value = orderSum.value - product.price;
    orderCost = orderCost - product.productCost!;
  }

  void verifyProductExistence(Cart cart) {
    int i = 0;

    if (demoCarts.isNotEmpty) {
      do {
        if (demoCarts.elementAt(i).product.id == cart.product.id) {
          exist.value = true;
          foundProduct = demoCarts.elementAt(i);
        }
        i++;
      } while (i < demoCarts.length && exist.isFalse);
    }
  }

  void applyPromoCode() async {
    int i = 0;
    var response = await NetworkHandler.get("order/promo/getValidPromos");

    try {
      PromoModel promoModel = PromoModel.fromJson(json.decode(response));

      print(promoModel.promos.elementAt(0).code);
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
        orderSum.value = orderSum.value * (validPromo.discount / 100);
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
    for (var i = 0; i < demoCarts.length; i++) {
      products
          .addAll({demoCarts[i].product.id.toString(): demoCarts[i].quantity});
    }

    var response = await NetworkHandler.post(
        jsonEncode(products), "product/check-availability");

    ProductModel productModel = ProductModel.fromJson(jsonDecode(response));
    List<Product> productsUnavailable = productModel.products;

    for (var i = 0; i < productsUnavailable.length; i++) {
      showConfirmationDialog(productsUnavailable[i], (confirmed) {
        if (!confirmed) {
          demoCarts.removeWhere(
              (element) => element.product.id == productsUnavailable[i].id);
        }
      });
    }
  }

  addOrder() async {
    Order order = Order();
    List<ProductCard> productCard = <ProductCard>[];

    for (var i = 0; i < demoCarts.length; i++) {
      productCard.add(
        ProductCard(
          id: demoCarts[i].product.id,
          quantity: demoCarts[i].quantity,
          price: demoCarts[i].product.price,
          name: demoCarts[i].product.name,
        ),
      );
    }
    var revenue = orderSum.value - orderCost;
    final customerId =
        await NetworkHandler.getItem("customerId"); // Await the future
    final addressId = await NetworkHandler.getItem("addressId");
    order.productCard = productCard.cast<ProductCard>();
    order.amount = orderSum.value;
    order.revenue = revenue;
    order.addressId = addressId;
    order.customerId = customerId;

    var response =
        await NetworkHandler.post(json.encode(order.toJson()), "order/add");

    for (var i = 0; i < demoCarts.length; i++) {
      await NetworkHandler.put(
          "product/update-after-sell/${demoCarts[i].product.id}",
          '{"quantity": ${demoCarts[i].product.quantity}}');
    }

    var spends = await NetworkHandler.put(
        '{"spend":${orderSum.value}}', "user/customer/spending/$customerId");

    demoCarts.clear();
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
