import 'package:flutter/material.dart';

class CardForm extends StatelessWidget {
  final List<Widget> children;
  final String title;
  final EdgeInsets? padding;
  const CardForm({
    Key? key,
    this.children = const [],
    this.title = '',
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(title, style: Theme.of(context).textTheme.headlineSmall),
        ),
        const SizedBox(height: 4),
        if (padding != null)
          Padding(
            padding: padding!,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: children,
            ),
          )
        else
          ...children,
      ],
    );
  }
}
