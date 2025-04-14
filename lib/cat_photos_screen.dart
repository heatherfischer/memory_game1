import 'package:flutter/material.dart';

import 'cat_api_service.dart';

class CatPhotos extends StatefulWidget {
  const CatPhotos({super.key});

  @override
  _CatPhotosState createState() => _CatPhotosState();
}

class _CatPhotosState extends State<CatPhotos> {
  final CatApiService _catApiService = CatApiService();
  late Future<List<String>> _catImages;

  @override
  void initState() {
    super.initState();
    _catImages = _catApiService.fetchCatImages(limit: 3);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink[300],
        foregroundColor: Colors.white,
        title: Text('Cat Photos'),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<String>>(
              future: _catImages,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error loading cat images'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No images found'));
                }

                final images = snapshot.data!;

                return ListView.builder(
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.network(images[index]),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.blue,
        child: Row(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
                foregroundColor: Colors.white
              ),
              child: Text('Memory Game'),
            ),
          ],
        ),
      ),
    );
  }
}
