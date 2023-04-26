import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../utils/colors.dart';
import '../../widgets/app_bar.dart';

class ReviewScreen extends StatelessWidget {
  ReviewScreen();

  @override
  Widget build(BuildContext context) {
    final String imageUrl = Get.arguments['imageUrl'];
    final List<Map<String, dynamic>> reviews =
        List<Map<String, dynamic>>.from(Get.arguments['reviews']);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Reviews'),
      body: Column(
        children: [
          Image.network(imageUrl),
          Expanded(
            child: ListView.builder(
              itemCount: reviews.length,
              itemBuilder: (BuildContext context, int index) {
                final review = reviews[index];
                final String userImage = review['userImage'];
                final String userName = review['userName'];
                final String comment = review['comment'];
                final double rating = review['rating'];

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
                    padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(userImage),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(userName,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        )),
                                    Row(
                                      children: [
                                        Text(
                                          '$rating',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
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
                                comment,
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
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.toNamed("/add-review", arguments: {
            'imageUrl':
                "https://res.cloudinary.com/dbkivxzek/image/upload/v1681557790/ARkea/moo8hs2jle9evi5u8o1z.png"
          });
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
