import 'dart:ffi';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:recipeapp/provider1/dbProvider.dart';
import 'package:recipeapp/provider1/ragisterProvider.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

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
FirebaseMessaging? firebaseMessaging;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();

    local();
    FirebaseNotification();
  }

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
            IconButton(
              onPressed: () {
                //notificationLocal();
                notificationLocalSchedual();
              },
              icon: Icon(Icons.notifications_active),
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
                                title = TextEditingController(
                                    text: l1[index].title);
                                cate =
                                    TextEditingController(text: l1[index].cate);
                                desc =
                                    TextEditingController(text: l1[index].desc);
                                img =
                                    TextEditingController(text: l1[index].img);
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

  void notificationLocal(String title,String body) async {
    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        "1", "Local Notification",
        importance: Importance.max, priority: Priority.high);

    IOSNotificationDetails IOSDetails =
        IOSNotificationDetails(presentSound: true, presentAlert: false);

    NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails, iOS: IOSDetails);

    await flutterLocalNotificationsPlugin.show(
      1,
      "$title",
      "$body",
      notificationDetails,
    );
  }

  void notificationLocalSchedual() async {
    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        "1", "Local Notification",
        importance: Importance.max, priority: Priority.high);

    IOSNotificationDetails IOSDetails =
        IOSNotificationDetails(presentSound: true, presentAlert: false);

    NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails, iOS: IOSDetails);

    await flutterLocalNotificationsPlugin.zonedSchedule(
        1,
        "PowBhaji",
        "Local Notification",
        tz.TZDateTime.now(tz.local).add(Duration(seconds: 3)),
        notificationDetails,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true);
  }

  void FirebaseNotification()async{
    firebaseMessaging = FirebaseMessaging.instance;

    NotificationSettings notificationSettings = await firebaseMessaging!.requestPermission(
      badge: true,
      alert: true,
      sound: true,
      provisional: false,
    );
    if(notificationSettings.authorizationStatus==AuthorizationStatus.authorized){
      FirebaseMessaging.onMessage.listen((event) {
        String title = event.notification!.title.toString();
        String body = event.notification!.body.toString();

        notificationLocal(title,body);
      });
    }
    else {
      print("No Permission");
    }
  }
  void local(){

    AndroidInitializationSettings androidInitializationSettings =
    AndroidInitializationSettings('android');
    IOSInitializationSettings IOSinitializationSettings =
    IOSInitializationSettings();
    InitializationSettings initializationSettings = InitializationSettings(
        android: androidInitializationSettings, iOS: IOSinitializationSettings);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }
}
