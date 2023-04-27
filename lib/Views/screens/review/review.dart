import 'package:ARkea/Model/review_model.dart';
import 'package:ARkea/ViewModel/review_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../utils/colors.dart';
import '../../widgets/app_bar.dart';

class ReviewScreen extends StatefulWidget {
  ReviewScreen();

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  final ReviewController _reviewController = Get.put(ReviewController());

  @override
  Widget build(BuildContext context) {
    final String thumbnail = Get.arguments[0]['thumbnail'];
    final String productId = Get.arguments[1]['productId'];

    return Scaffold(
      appBar: const CustomAppBar(title: 'Reviews'),
      body: Column(
        children: [
          Image.network(thumbnail),
          Obx(
            () => _reviewController.count.value == 0
                ? const Center(
                    child: Text("No Reviews Yet"),
                  )
                : _reviewController.isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : Expanded(
                        child: ListView.builder(
                          itemCount: _reviewController.count.value,
                          itemBuilder: (BuildContext context, int index) {
                            final review = _reviewController.reviewsList[index];

                            return Container(
                              margin: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: 5,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(15, 15, 15, 15),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      radius: 30,
                                      backgroundImage:
                                          NetworkImage(review.customerImage),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(review.customerName,
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    )),
                                                Row(
                                                  children: [
                                                    Text(
                                                      '${review.rating}',
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 5),
                                                    const Icon(
                                                      Icons.star,
                                                      color: Colors.yellow,
                                                      size: 20,
                                                    ),
                                                  ],
                                                ),
                                              ]),
                                          const SizedBox(height: 5),
                                          Text(
                                            review.comment,
                                            style: const TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.toNamed(
            "/add-review",
            arguments: [
              {'thumbnail': thumbnail},
              {'productId': productId}
            ],
          );
        },
        label: const Text(
          'Add Review',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: MyColors.btnBorderColor,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
