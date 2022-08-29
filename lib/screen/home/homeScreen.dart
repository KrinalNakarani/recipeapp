import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipeapp/provider1/dbProvider.dart';
import 'package:recipeapp/provider1/ragisterProvider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController id = TextEditingController();
  TextEditingController cate = TextEditingController();
  TextEditingController desc = TextEditingController();
  TextEditingController img = TextEditingController();
  TextEditingController title = TextEditingController();

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
        body: StreamBuilder(
          stream: Provider.of<FDProvider>(context, listen: false).readData(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return Text("${snapshot.error}");
            } else if (snapshot.hasData) {
              print("====================${snapshot.data.snapshot}");

              List l1 = [];
              DataSnapshot data = snapshot.data.snapshot;

              for (var x in data.children) {
                ModelRecipe r1 = ModelRecipe(
                    id: x.child("id").value.toString(),
                    title: x.child("title").value.toString(),
                    cate: x.child("cate").value.toString(),
                    desc: x.child("desc").value.toString(),
                    img: x.child("img").value.toString(),
                    key: x.key);
                l1.add(r1);
              }

              return ListView.builder(
                  itemCount: l1.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Text("${l1[index].id}"),
                      title: Text("${l1[index].title}"),
                      subtitle: Text("${l1[index].cate}"),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                id = TextEditingController(text: l1[index].id);
                                title = TextEditingController(text: l1[index].title);
                                cate = TextEditingController(text: l1[index].cate);
                                desc = TextEditingController(text: l1[index].desc);
                                img = TextEditingController(text: l1[index].img);
                                DialogBox(l1[index].key.toString());
                              },
                              icon: Icon(
                                Icons.edit,
                                color: Colors.green,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                Provider.of<FDProvider>(context, listen: false)
                                    .Delete(l1[index].key);
                              },
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  });
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            id = TextEditingController();
            title = TextEditingController();
            cate = TextEditingController();
            desc = TextEditingController();
            img = TextEditingController();
            DialogBox(null);
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  void DialogBox(String? key) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: SizedBox(
                height: 500,
                child: Column(
                  children: [
                    TextField(
                      controller: id,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "id",
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: title,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Title",
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: cate,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Category",
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: desc,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Description",
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: img,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Image",
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Provider.of<FDProvider>(context, listen: false).AddData(
                            id: id.text,
                            title: title.text,
                            cate: cate.text,
                            desc: desc.text,
                            img: img.text,
                            key: key);
                      },
                      child: Text("Submit"),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
