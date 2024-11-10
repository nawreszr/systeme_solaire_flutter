import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:systeme_solaire_ar/planetDetailsScreen.dart';

class PlanetListScreen extends StatefulWidget {
  const PlanetListScreen({super.key});

  @override
  State<PlanetListScreen> createState() => _PlanetListScreenState();
}

class _PlanetListScreenState extends State<PlanetListScreen> {
  List<Map<String, dynamic>> solarItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSolarData();
  }

  Future<void> fetchSolarData() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.0.102:80/'));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          solarItems = data.map((item) {
            return {
              'id': item['id'],
              'image': item['image'],
              'name': item['name'],
              'description': item['description'],
            };
          }).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        throw Exception('Failed to load solar data');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('النظام الشمسي'),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : solarItems.isEmpty
          ? const Center(child: Text('No solar data available.'))
          : ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: solarItems.length,
        itemBuilder: (context, index) {
          final item = solarItems[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlanetDetailsScreen(
                    name: item['name'],
                    image: item['image'],
                    description: item['description'],
                  ),
                ),
              );
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 5,
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        item['image'],
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.broken_image, size: 100),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['name'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
