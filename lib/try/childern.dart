import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // Sebaiknya gunakan const constructor jika semua field final
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Contoh Penggunaan Children'),
        ),
        body: MyWidgetWithChildren(),
      ),
    );
  }
}

class MyWidgetWithChildren extends StatelessWidget {
  // Sebaiknya gunakan const constructor jika semua field final
  const MyWidgetWithChildren({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column( // Column menggunakan 'children' untuk menata widget secara vertikal
        crossAxisAlignment: CrossAxisAlignment.start, // Ratakan anak-anak ke kiri
        children: <Widget>[ // Ini adalah properti 'children', menerima List<Widget>
          const Text(
            'Ini adalah anak pertama (Text Widget)',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10), // Memberi jarak antar anak

          const Icon(
            Icons.star,
            color: Colors.amber,
            size: 40,
          ),
          const SizedBox(height: 10),

          Container( // Anak ketiga adalah sebuah Container
            padding: const EdgeInsets.all(12.0),
            color: Colors.blue[100],
            child: const Text('Ini teks di dalam Container'),
          ),
          const SizedBox(height: 10),

          const Row( // Anak keempat adalah Row, yang juga menggunakan 'children'
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[ // 'children' di dalam Row
              Icon(Icons.thumb_up, color: Colors.green),
              Text('Suka'),
              Icon(Icons.comment, color: Colors.blue),
              Text('Komentar'),
            ],
          ),
          const SizedBox(height: 10),

          ElevatedButton(
            onPressed: () {
              // Aksi ketika tombol ditekan
              print('Tombol ditekan!');
            },
            child: const Text('Ini Tombol (ElevatedButton)'),
          ),
        ],
      ),
    );
  }
}
