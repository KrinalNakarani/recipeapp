import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipeapp/provider1/ragisterProvider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Recipe"),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                Provider.of<RagiProvider>(context, listen: false).signOut();
                Navigator.pushReplacementNamed(context, '/');
              },
              icon: Icon(Icons.logout),
            ),
          ],
        ),
        body: Container(),
      ),
    );
  }
}
