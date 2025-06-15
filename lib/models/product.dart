class Product {
  final int id;
  final String title;
  final double price;
  final String? image;

  Product({
    required this.id,
    required this.title,
    required this.price,
    this.image,
  });

  // Factory method untuk membuat Product dari JSON (data dari Supabase)
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      title: json['title'] as String,
      price: (json['price'] as num).toDouble(), // Konversi ke double karena price adalah DECIMAL
      image: json['image'] as String?,
    );
  }

  // Method untuk mengubah Product ke JSON (opsional, jika perlu insert/update ke Supabase)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'image': image,
    };
  }
}