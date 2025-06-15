class Category {
  final int id;
  final String name;

  Category({
    required this.id,
    required this.name,
  });

  // Factory method untuk membuat Category dari JSON (data dari Supabase)
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }

  // Method untuk mengubah Category ke JSON (opsional, jika perlu insert/update ke Supabase)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}