import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'fullscreen.dart';

class GalleryPage extends StatefulWidget {
  String email="";
  String lecturename="";
  GalleryPage(email,lecturename)
  {
    this.email=email;
    this.lecturename=lecturename;
  }
  @override
  _GalleryPageState createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<Map<String, dynamic>> allImages = []; // Store all images from Firestore
  List<Map<String, dynamic>> filteredImages = [];
  bool loading=true;
// Filtered images to display

  @override
  void initState() {
    super.initState();
    fetchImages();
    _searchController.addListener(_updateSearch); // Listen for text changes
  }

  // Fetch images from Firestore once
  void fetchImages() async {

    setState(() {
      loading=true;
    });
    print(widget.email);
    print(widget.lecturename);
    var snapshot = await FirebaseFirestore.instance.collection('users').doc(widget.email).collection('lectures').doc(widget.lecturename).collection('images').get();
    setState(() {
      allImages = snapshot.docs.map((doc) => doc.data()).toList();
      filteredImages = List.from(allImages);
      loading=false;
    });
  }

  void _updateSearch() {
    setState(() {
      loading=true;
    });

    setState(() {

      _searchQuery = _searchController.text.toLowerCase();
      filteredImages = allImages.where((image) {
        List<dynamic> keywords = image['topics']; // Get the list of keywords
        return _searchQuery.isEmpty ||
            keywords.any((keyword) => keyword.toLowerCase().contains(_searchQuery));
      }).toList();
    });
    loading=false;
  }

  @override
  void dispose() {
    _searchController.removeListener(_updateSearch);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gallery"),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search images...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body:loading? Center(
          child: CircularProgressIndicator()
      ):
      filteredImages.isEmpty
          ? Center(child: Text("No images found!", style: TextStyle(fontSize: 18)))
          : GridView.builder(
        padding: EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: filteredImages.length,
        itemBuilder: (context, index) {
          String base64String = filteredImages[index]['image_base64']; // Fetch Base64 string
          Uint8List imageBytes = base64Decode(base64String);

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FullScreenImage(imageBytes: imageBytes),
                ),
              );
            },
            child: Hero(
              tag: 'image$index',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.memory(imageBytes, fit: BoxFit.cover),
              ),
            ),
          );
        },
      ),
    );
  }
}