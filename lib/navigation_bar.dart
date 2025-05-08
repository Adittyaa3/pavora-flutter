import 'package:flutter/material.dart';

class CustomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            width: 3,
            color: Color(0xFF205781),
          ),
          borderRadius: BorderRadius.circular(64),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Home Icon
          GestureDetector(
            onTap: () => onItemTapped(0),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: ShapeDecoration(
                color: selectedIndex == 0
                    ? const Color(0xFF205781)
                    : Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Icon(
                Icons.home_outlined,
                color: selectedIndex == 0
                    ? Colors.white
                    : const Color(0xFF205781),
                size: 36,
              ),
            ),
          ),
          // Cart Icon
          GestureDetector(
            onTap: () => onItemTapped(1),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: ShapeDecoration(
                color: selectedIndex == 1
                    ? const Color(0xFF205781)
                    : Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Icon(
                Icons.shopping_cart_outlined,
                color: selectedIndex == 1
                    ? Colors.white
                    : const Color(0xFF205781),
                size: 36,
              ),
            ),
          ),
          // History/Order Icon
          GestureDetector(
            onTap: () => onItemTapped(2),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: ShapeDecoration(
                color: selectedIndex == 2
                    ? const Color(0xFF205781)
                    : Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Icon(
                Icons.inventory_outlined,
                color: selectedIndex == 2
                    ? Colors.white
                    : const Color(0xFF205781),
                size: 36,
              ),
            ),
          ),
          // Profile Icon
          GestureDetector(
            onTap: () => onItemTapped(3),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: ShapeDecoration(
                color: selectedIndex == 3
                    ? const Color(0xFF205781)
                    : Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Icon(
                Icons.person_outlined,
                color: selectedIndex == 3
                    ? Colors.white
                    : const Color(0xFF205781),
                size: 36,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

