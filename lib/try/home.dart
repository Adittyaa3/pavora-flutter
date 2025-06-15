import 'package:flutter/material.dart';

void main() => runApp( const MyApp());

class MyApp extends StatelessWidget {
const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Contoh Row Widget'),
        ),
        body: MyRowLayout(),
      ),
    );
  }
}

class MyRowLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column( // Menggunakan Column untuk menampilkan beberapa contoh Row
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Row dengan MainAxisAlignment.start:', style: TextStyle(fontWeight: FontWeight.bold)),
          Container(
            color: Colors.amber[100],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start, // Default
              children: <Widget>[
                Icon(Icons.star, size: 50),
                Icon(Icons.star, size: 50),
                Icon(Icons.star, size: 50),
              ],
            ),
          ),
          SizedBox(height: 20),

          Text('Row dengan MainAxisAlignment.center:', style: TextStyle(fontWeight: FontWeight.bold)),
          Container(
            color: Colors.lightBlue[100],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.home, size: 50),
                Icon(Icons.settings, size: 50),
                Icon(Icons.person, size: 50),
              ],
            ),
          ),
          SizedBox(height: 20),

          Text('Row dengan MainAxisAlignment.spaceBetween:', style: TextStyle(fontWeight: FontWeight.bold)),
          Container(
            color: Colors.pink[100],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Kiri'),
                Text('Tengah'),
                Text('Kanan'),
              ],
            ),
          ),
          SizedBox(height: 20),

          Text('Row dengan CrossAxisAlignment.center (dalam Container dengan tinggi):', style: TextStyle(fontWeight: FontWeight.bold)),
          Container(
            height: 100, // Memberi tinggi pada Container agar efek CrossAxisAlignment terlihat
            color: Colors.green[100],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center, // Anak-anak akan di tengah secara vertikal
              children: <Widget>[
                Icon(Icons.thumb_up, size: 30),
                Text('Suka Ini'),
                ElevatedButton(onPressed: () {}, child: Text('Aksi'))
              ],
            ),
          ),
           SizedBox(height: 20),

          Text('Row dengan Expanded widget:', style: TextStyle(fontWeight: FontWeight.bold)),
          Container(
            color: Colors.orange[100],
            child: Row(
              children: <Widget>[
                Container(color: Colors.red, padding: EdgeInsets.all(8), child: Text('Item 1')),
                Expanded(
                  child: Container(color: Colors.yellow, padding: EdgeInsets.all(8), child: Text('Item 2 (Expanded)')),
                ),
                Container(color: Colors.blue, padding: EdgeInsets.all(8), child: Text('Item 3')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
