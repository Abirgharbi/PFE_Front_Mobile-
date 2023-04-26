import 'package:ARkea/utils/colors.dart';
import 'package:flutter/material.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({Key? key}) : super(key: key);

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  var _tmp = [false, false, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.scaffoldBGColor,
      body: Container(
          height: MediaQuery.of(context).size.height / 2,
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Filter",
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.clear,
                      size: 30,
                    ))
              ],
            ),
            Divider(),
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        "Brand",
                        style: TextStyle(fontSize: 16),
                      ),
                      Spacer(),
                      const Text(
                        "View all",
                        style: TextStyle(fontSize: 16),
                      ),
                      IconButton(
                          onPressed: () {}, icon: Icon(Icons.arrow_forward_ios))
                    ],
                  ),
                  SizedBox(
                    child: Wrap(
                      direction: Axis.horizontal,
                      runSpacing: 6,
                      spacing: 6,
                      children: [
                        InputChip(
                          label: Text("Ardell"),
                          labelStyle: const TextStyle(
                            color: Colors.white,
                          ),
                          backgroundColor: MyColors.btnBorderColor,
                          isEnabled: true,
                          disabledColor: Colors.grey,
                          selectedColor: MyColors.btnBorderColor,
                          deleteIcon: const Icon(
                            Icons.check,
                            size: 14,
                          ),
                          deleteIconColor: Colors.white,
                          onDeleted: () {
                            print("onDeleted");
                          },
                          onSelected: (b) {
                            print("onSelected");
                            setState(() {});
                          },
                          selected: _tmp[0],
                        ),
                        InputChip(
                          label: Text("bareMinerals"),
                          labelStyle: const TextStyle(
                            color: Colors.white,
                          ),
                          backgroundColor: MyColors.btnBorderColor,
                          isEnabled: true,
                          disabledColor: Colors.grey,
                          selectedColor: MyColors.btnBorderColor,
                          deleteIcon: const Icon(
                            Icons.check,
                            size: 14,
                          ),
                          deleteIconColor: Colors.white,
                          onDeleted: () {
                            print("delete");
                          },
                          onSelected: (b) {
                            print("b");
                            setState(() {});
                          },
                          selected: _tmp[1],
                        ),
                        InputChip(
                          label: Text("Clate"),
                          labelStyle: TextStyle(
                            color: Colors.white,
                          ),
                          backgroundColor: MyColors.btnBorderColor,
                          isEnabled: true,
                          disabledColor: Colors.grey,
                          selectedColor: MyColors.btnBorderColor,
                          deleteIcon: Icon(
                            Icons.check,
                            size: 14,
                          ),
                          deleteIconColor: Colors.white,
                          onDeleted: () {
                            print("onDeleted");
                          },
                          onSelected: (b) {
                            print("onSelected");
                            setState(() {});
                          },
                          selected: _tmp[2],
                        )
                      ],
                    ),
                  ),
                  // ExpansionTile(
                  //   title: Text("Color"),
                  //   initiallyExpanded: true,
                  //   children: [
                  //     SizedBox(
                  //       height: 64,
                  //       child: ListView.builder(
                  //           scrollDirection: Axis.horizontal,
                  //           itemBuilder: (context, index) {
                  //             if (index == 0) {
                  //               return Padding(
                  //                 padding: const EdgeInsets.only(right: 8),
                  //                 child: InputChip(
                  //                   label: Text(
                  //                     "L",
                  //                   ),
                  //                   selectedColor: Colors.black,
                  //                   labelStyle: TextStyle(
                  //                     color: Colors.white,
                  //                   ),
                  //                   backgroundColor: Colors.black,
                  //                   avatar: CircleAvatar(
                  //                     backgroundColor: Colors.grey,
                  //                   ),
                  //                   onSelected: (s) {},
                  //                   onDeleted: () {},
                  //                   deleteIconColor: Colors.white,
                  //                 ),
                  //               );
                  //             }
                  //             return Padding(
                  //               padding: const EdgeInsets.only(right: 8),
                  //               child: ChoiceChip(
                  //                 label: Text("XXL"),
                  //                 selected: false,
                  //                 avatar: CircleAvatar(
                  //                   backgroundColor: Colors.black,
                  //                 ),
                  //                 shape: StadiumBorder(side: BorderSide()),
                  //                 backgroundColor: Colors.transparent,
                  //                 onSelected: (b) {},
                  //               ),
                  //             );
                  //           }),
                  //     ),
                  //   ],
                  // ),
                  SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Price Range",
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        "\$${rangeValue.start.toStringAsFixed(0)}-${rangeValue.end.toStringAsFixed(0)}",
                        selectionColor: MyColors.btnBorderColor,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      RangeSlider(
                          activeColor: MyColors.btnBorderColor,
                          inactiveColor: Colors.grey,
                          min: 0,
                          max: 300,
                          values: rangeValue,
                          onChanged: (s) {
                            setState(() {
                              rangeValue = s;
                            });
                          })
                    ],
                  )

                  // ExpansionTile(
                  //   title: const Text(

                  //     "Price Range",
                  //     selectionColor: MyColors.btnBorderColor,

                  //   ),
                  //   trailing: Text(
                  //     "\$${rangeValue.start.toStringAsFixed(0)}-${rangeValue.end.toStringAsFixed(0)}",
                  //     selectionColor: MyColors.btnBorderColor,
                  //   ),
                  //   initiallyExpanded: true,
                  //   children: [
                  //     RangeSlider(
                  //         activeColor: MyColors.btnBorderColor,
                  //         inactiveColor: Colors.grey,
                  //         min: 0,
                  //         max: 300,
                  //         values: rangeValue,
                  //         onChanged: (s) {
                  //           setState(() {
                  //             rangeValue = s;
                  //           });
                  //         })
                  //   ],
                  // ),
                ],
              ),
            ),
          ])),
    );

    // Scaffold(
    //   backgroundColor: Colors.white,
    //   appBar: AppBar(
    //     backgroundColor: Colors.white,
    //     foregroundColor: Colors.black,
    //     elevation: 0,
    //     centerTitle: true,
    //     actions: [
    //       TextButton(
    //         onPressed: () {},
    //         child: Text("Reset"),
    //         style: TextButton.styleFrom(
    //           primary: Colors.black,
    //         ),
    //       ),
    //     ],
    //     title: Text("Filter"),
    //   ),
    //   body:
  }

  RangeValues rangeValue = RangeValues(0.0, 300);
}
