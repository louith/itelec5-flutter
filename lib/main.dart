import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
//import 'package:fsa_seprado_clothingshop/models/items.dart';
//import 'package:fsa_seprado_clothingshop/services/firestoredb.dart';
import 'package:flutter_launcher_icons/android.dart';
import 'package:flutter_launcher_icons/constants.dart';
import 'package:flutter_launcher_icons/custom_exceptions.dart';
import 'package:flutter_launcher_icons/ios.dart';
import 'package:flutter_launcher_icons/main.dart';
import 'package:flutter_launcher_icons/utils.dart';
import 'package:flutter_launcher_icons/xml_templates.dart';
import 'package:provider/provider.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

//https://miseclothingshop-fsa.firebaseapp.com/
//https://miseclothingshop-fsa.web.app/

//https://miseclothingshop.web.app/
//com.summative.fsa_seprado_clothingshop
//AA:85:6E:64:59:E1:BA:B1:DD:05:FD:E6:3F:F8:30:A0:82:74:11:4F

Future<void> main() async {

    WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MISE Clothing Shop',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.brown,
        
      ),
      home: const MyHomePage(title: 'MISE Clothing Shop'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Stream<QuerySnapshot> _itemStream = FirebaseFirestore.instance.collection('items').snapshots();

  @override
  Widget build(BuildContext context) {

    
    
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: Container(
          width:MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: StreamBuilder<QuerySnapshot>(
      stream: _itemStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong' + snapshot.error.toString());
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return 
          Center(
            child: Text("Loading"));
        }

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
          Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
            return 

        Card(
          elevation: 5,
          child:

          Stack(
            children:[

              //1st stack; main container
              Container(
                width: MediaQuery.of(context).size.width,
                height: 350,
                color: Colors.brown[200]
              ),

              //2nd stack; a row of 2 containers on top of main container
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children:[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.48,
                    height: 350,
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    color: Colors.brown[50],
                    child: Image.network(data['image_url'])
                  ),

                  //3rd child in the stack (column of text, size, and description)
                  Container(
                    width: MediaQuery.of(context).size.width * 0.45,
                    height: 300,
                    child:
                      Column(
                        children: [
                          SizedBox(
                            width:15,
                            height:15
                          ),

                          Text(data['name'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,),
                            textAlign: TextAlign.left
                            ),
                          SizedBox(
                            width:10,
                            height:10
                          ),
                          Text(data['size'],
                          textAlign: TextAlign.left),
                           SizedBox(
                            width:15,
                            height:15
                          ),
                          Text(data['description'],
                          textAlign: TextAlign.justify),
                                                    SizedBox(
                            width:15,
                            height:15
                          ),
                          Text(data['price'],
                          textAlign: TextAlign.right),

                        ],
                      )
                  )
                ] //children of row inside the stack
              ),


                    //4th on stack (button)
                    Container(
                      width:40,
                      height: 40,
                      color: Colors.transparent,
                      margin: EdgeInsets.fromLTRB(165, 302, 100,0),
                      child:
                      Icon(Icons.shopping_cart_checkout, color:Colors.brown)
                    ),

                    Container(
                      width: 100,
                      height: 40,
                      margin: EdgeInsets.fromLTRB(100, 303, 100,0),
                      child: 
                      ElevatedButton.icon(
                       onPressed: () {print("Item added to cart");}, 
                       icon: Icon(Icons.shopping_cart_checkout),
                       label: Text("Add to cart"),
                       style: ElevatedButton.styleFrom(
                         primary: Colors.brown,
                         textStyle: TextStyle(fontSize: 12),
                         fixedSize: Size(100,40)
                       )
                       )
                    )
            ]
          )
        );
            

          }).toList()
        );
      },
    )
        )
      )
    

    );
  }
}
