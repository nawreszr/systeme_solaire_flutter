import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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
      final response = await http.get(Uri.parse('https://systeme-solaire-api.onrender.com/'));

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
          return Card(
            child: ListTile(
              leading: Image.network(item['image']),
              title: Text(item['name']),
              subtitle: Text(item['description']),
            ),
          );
        },
      ),
    );
  }
}
