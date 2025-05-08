import 'package:flutter/material.dart';

class ProductCard extends StatefulWidget {
  final VoidCallback onDelete; // Callback for delete action

  const ProductCard({super.key, required this.onDelete});

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  int quantity = 1; // Initial quantity

  void incrementQuantity() {
    setState(() {
      quantity++;
    });
  }

  void decrementQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        widget.onDelete(); // Call the delete callback when swiped
      },
      background: Container(
        color: const Color(0xFFE65A5A), // Red background for delete
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 24,
        ),
      ),
      child: Container(
        width: 328,
        padding: const EdgeInsets.all(16),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: const BorderSide(
              width: 1,
              color: Color(0xFF205781),
            ),
            borderRadius: BorderRadius.circular(13),
          ),
        ),
        child: Wrap(
          alignment: WrapAlignment.start,
          runAlignment: WrapAlignment.start,
          spacing: 17,
          runSpacing: 32,
          children: [
            // Image Container
            Container(
              width: 97,
              height: 147,
              clipBehavior: Clip.antiAlias,
              decoration: ShapeDecoration(
                color: const Color(0xFFECECEC),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    left: 17,
                    top: 38,
                    child: Container(
                      width: 60,
                      height: 71,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage("https://placehold.co/60x71"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Description Container
            Container(
              width: 157,
              padding: const EdgeInsets.only(top: 41),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 157,
                    child: Text(
                      'Medium Chair',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 7),
                  SizedBox(
                    width: 154,
                    child: Text(
                      'is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xFF9B9B9B),
                        fontSize: 8,
                        fontFamily: 'Sora',
                        fontWeight: FontWeight.w400,
                        height: 1.64,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Buttons Row
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Quantity Selector
                Container(
                  width: 97,
                  height: 34,
                  padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                        width: 1,
                        color: Color(0xFF205781),
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Minus Button
                      GestureDetector(
                        onTap: decrementQuantity,
                        child: Container(
                          width: 29,
                          height: 29,
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.remove,
                              color: Color(0xFF205781),
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                      // Quantity Display
                      SizedBox(
                        width: 6.5,
                        child: Text(
                          '$quantity',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Color(0xFF3E4462),
                            fontSize: 10,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                            height: 1.67,
                            letterSpacing: -0.24,
                          ),
                        ),
                      ),
                      // Plus Button
                      GestureDetector(
                        onTap: incrementQuantity,
                        child: Container(
                          width: 29,
                          height: 29,
                          decoration: ShapeDecoration(
                            color: const Color(0xFF205781),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 81),
                // Checkout Button
                Container(
                  width: 104,
                  height: 34,
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                    color: const Color(0xFF205781),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'Chekout',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        height: 1,
                        letterSpacing: -0.24,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<int> cards = [1]; // List to manage multiple cards (for demo purposes)

  void removeCard(int index) {
    setState(() {
      cards.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center( // Center the entire content vertically and horizontally
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Center the column's children vertically
              children: [
                ...cards.asMap().entries.map((entry) {
                  int index = entry.key;
                  return ProductCard(
                    onDelete: () => removeCard(index),
                  );
                }).toList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}