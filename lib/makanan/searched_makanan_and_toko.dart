import 'package:flutter/material.dart';
import 'package:academeats_mobile/models/makanan.dart';
import 'package:academeats_mobile/models/toko.dart';
import 'package:academeats_mobile/utils/fetch.dart';

import '../toko/toko_detail.dart';
import 'detail_makanan.dart';


class SearchedMakananAndTokoScreen extends StatefulWidget {
  final String searchQuery;

  const SearchedMakananAndTokoScreen({Key? key, required this.searchQuery})
      : super(key: key);

  @override
  _SearchedMakananAndTokoScreenState createState() =>
      _SearchedMakananAndTokoScreenState();
}

class _SearchedMakananAndTokoScreenState
    extends State<SearchedMakananAndTokoScreen> {
  late Future<List<Makanan>> _makananFuture;
  late Future<List<Toko>> _tokoFuture;

  @override
  void initState() {
    super.initState();
    _makananFuture = _fetchMakananData();
    _tokoFuture = _fetchTokoData();
  }

  Future<List<Makanan>> _fetchMakananData() async {
    // Fetch Makanan data from the API
    Map<String, dynamic> makananData = await fetchData('makanan/api/v1/');
    List<dynamic> makananList = makananData['data'];
    List<Makanan> makanans =
    makananList.map((data) => Makanan.fromJson(data)).toList();

    // Filter Makanan based on similarity with the search query
    List<Makanan> filteredMakanans = makanans.where((makanan) {
      return makanan.nama
          .toLowerCase()
          .contains(widget.searchQuery.toLowerCase());
    }).toList();

    return filteredMakanans;
  }

  Future<List<Toko>> _fetchTokoData() async {
    // Fetch Toko data from the API
    Map<String, dynamic> tokoData = await fetchData('toko/api/v1/');
    List<dynamic> tokoList = tokoData['data'];
    List<Toko> tokos = tokoList.map((data) => Toko.fromJson(data)).toList();

    // Filter Toko based on similarity with the search query
    List<Toko> filteredTokos = tokos.where((toko) {
      return toko.name.toLowerCase().contains(widget.searchQuery.toLowerCase());
    }).toList();

    return filteredTokos;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results for "${widget.searchQuery}"'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Toko',
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          SizedBox(
            height: 130, // Adjust the height as necessary
            child: FutureBuilder<List<Toko>>(
              future: _tokoFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  List<Toko> tokos = snapshot.data ?? [];
                  if (tokos.isEmpty) {
                    return Center(child: Text('No matching Toko found.'));
                  }
                  return _buildTokoCarousel(tokos);
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Makanan',
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Makanan>>(
              future: _makananFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  List<Makanan> makanans = snapshot.data ?? [];
                  if (makanans.isEmpty) {
                    return Center(child: Text('No matching Makanan found.'));
                  }
                  return _buildMakananGrid(makanans);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTokoCarousel(List<Toko> tokos) {
    return PageView.builder(
      itemCount: tokos.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TokoDetailScreen(toko: tokos[index]),
              ),
            );
          },
          child: _buildTokoItem(tokos[index]),
        );
      },
    );
  }

  Widget _buildTokoItem(Toko toko) {
    return Container(
      width: MediaQuery.of(context).size.width / 3.5, // Adjust the width to be slightly wider than square
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: Colors.pink, // Pink background color
      ),
      child: Center(
        child: Text(
          toko.name,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.0, // Smaller font size
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildMakananGrid(List<Makanan> makanans) {
    return GridView.builder(
      padding: EdgeInsets.all(8.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // Three columns
        childAspectRatio: 0.8, // Slightly rectangular to fit the design better
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: makanans.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FoodDetailScreen(makanan: makanans[index]),
              ),
            );
          },
          child: _buildMakananItem(makanans[index]),
        );
      },
    );
  }

  Widget _buildMakananItem(Makanan makanan) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        image: DecorationImage(
          image: NetworkImage(makanan.imgUrl), // Assuming Makanan has an imageUrl field
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          gradient: LinearGradient(
            colors: [Colors.black54, Colors.transparent],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              makanan.nama,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.0, // Smaller font size
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
