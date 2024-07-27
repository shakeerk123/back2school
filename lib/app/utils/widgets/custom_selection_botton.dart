import 'package:flutter/material.dart';

class CheckButtonComponent extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onPressed;

  CheckButtonComponent({
    required this.text,
    required this.isSelected,
    required this.onPressed,
  });

  final Color defaultColor = Color.fromARGB(255, 37, 24, 24);
  final Color selectedColor = Color.fromARGB(255, 196, 115, 115);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SizedBox(
        width: 280,
        height: 80,
        child: Column(
          children: [
            InkWell(
              onTap: onPressed,
              borderRadius: BorderRadius.circular(
                MediaQuery.of(context).size.height * 0.02,
              ),
              child: Ink(
                width: 200,
                height: 50,
                decoration: BoxDecoration(
                  color: isSelected ? selectedColor : defaultColor,
                  borderRadius: BorderRadius.circular(
                    MediaQuery.of(context).size.height * .014,
                  ),
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(0, 5),
                      blurRadius: 12,
                      color: Colors.blueGrey.withOpacity(.2),
                      spreadRadius: -5,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    MediaQuery.of(context).size.height * .014,
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          child: Text(
                            text,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                          ),
                        ),
                      ),
                      if (isSelected)
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            width: MediaQuery.of(context).size.height * .05,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(
                                  MediaQuery.of(context).size.height * .014,
                                ),
                                bottomLeft: Radius.circular(
                                  MediaQuery.of(context).size.height * .014,
                                ),
                              ),
                              color: const Color(0xffd62764),
                            ),
                            child: Icon(
                              Icons.check,
                              color: Colors.white,
                              size: MediaQuery.of(context).size.height * .02,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
