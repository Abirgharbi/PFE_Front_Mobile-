import 'package:ARkea/utils/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../../ViewModel/login_controller.dart';
import '../../../ViewModel/review_controller.dart';
import '../../../utils/colors.dart';
import '../../../utils/shared_preferences.dart';
import '../../widgets/app_bar.dart';
import '../auth/login_page.dart';
import '../profil_page/noLoggedIn_profilPage.dart';

class AddReviewScreen extends StatefulWidget {
  const AddReviewScreen();

  @override
  _AddReviewScreenState createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends State<AddReviewScreen> {
  final ReviewController _reviewController = Get.put(ReviewController());

  String _comment = '';
  double _rating = 4;

  String token = '';
  @override
  void initState() {
    super.initState();
    checkToken();
  }

  checkToken() async {
    String updatedToken = await sharedPrefs.getPref('token');
    setState(() {
      token = updatedToken;
    });
  }

  @override
  Widget build(BuildContext context) {
    final String thumbnail = Get.arguments[0]['thumbnail'];
    final String productId = Get.arguments[1]['productId'];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(title: 'Add Review'),
      body: token.isEmpty
          ? const noLoggedIn_profilPage()
          : SingleChildScrollView(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Image.network(
                      thumbnail,
                      fit: BoxFit.cover,
                      height: 250,
                    ),
                    const SizedBox(height: 50),
                    Center(
                      child: RatingBar.builder(
                        initialRating: 4,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemPadding:
                            const EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          setState(() {
                            _rating = rating;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 50),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Write your review...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Colors.grey,
                                width: 1,
                              ),
                            ),
                          ),
                          maxLines: 5,
                          onChanged: (value) {
                            setState(() {
                              _comment = value;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                    Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width / 2,
                        height: 50,
                        decoration: BoxDecoration(
                          color: MyColors.btnBorderColor,
                          border: Border.all(
                            color: MyColors.btnBorderColor,
                            width: 1 / 2,
                          ),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(15),
                          onTap: () {
                            _reviewController.addReview(
                                _comment, _rating, productId);
                            Get.snackbar(
                                "Success", "Review Added successfully");
                            Get.toNamed('/landing');
                          },
                          splashColor: MyColors.btnBorderColor,
                          child: const Center(
                            child: Text(
                              "Submit Review",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
