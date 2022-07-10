// @dart=2.9
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:todo_list/splash.dart';
import 'signup.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.blue,
        colorScheme: ColorScheme.fromSwatch()
            .copyWith(secondary: Colors.orangeAccent)),
    home: Splash(),
    routes: <String, WidgetBuilder>{
      '/signup': (BuildContext context) => new SignupPage()
    },
  ));
}


class MyApp extends StatefulWidget {

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  int _success = 1;
  String _userEmail = "";

  //void _singIn() async {
    //Navigator.push(
     // context,
      //MaterialPageRoute(builder: (context) => MyApp())
    //);
    //final User user = (await _auth.signInWithEmailAndPassword(email: _emailController.text, password: _passwordController.text)).user;

    //if(user != null) {
      //setState(() {
       // _success = 2;
       // _userEmail = user.email;
     // });
   // } else {
     // setState(() {
        //_success = 3;
      //});
   // }
  //}

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(15, 110, 0, 0),
                    child: Text("HELLO!",
                        style: TextStyle(
                            fontSize: 40, fontWeight: FontWeight.bold
                        )
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 35, left: 20, right: 30),
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                        labelText: 'EMAIL',
                        labelStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            color: Colors.grey
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                        )
                    ),
                  ),
                  SizedBox(height: 20,),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                        labelText: 'PASSWORD',
                        labelStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            color: Colors.grey
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                        )
                    ),
                    obscureText: true,
                  ),
                  SizedBox(height: 5.0,),
                  Container(
                    alignment: Alignment(1,0),
                    padding: EdgeInsets.only(top: 15, left: 20),
                    child: InkWell(
                      child: Text(
                        'Forgot Password',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat',
                            decoration: TextDecoration.underline
                        ),
                      ),
                    ),
                  ),
                  Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        _success == 1
                            ? ''
                            : (
                            _success == 2
                                ? 'Successfully signed in ' + _userEmail
                                : 'Sign in failed'),
                        style: TextStyle(color: Colors.red),
                      )
                  ),
                  SizedBox(height: 40,),
                  Container(
                    height: 40,
                    child: Material(
                      borderRadius: BorderRadius.circular(20),
                      shadowColor: Colors.greenAccent,
                      color: Colors.black,
                      elevation: 7,
                      child: GestureDetector(
                          onTap: () async{
                            final User user = (await _auth.signInWithEmailAndPassword(email: _emailController.text, password: _passwordController.text)).user;
                            print(user);
                            if(user != null) {
                              setState(() {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) => MyApp())
                                );
                              });
                            } else {
                              setState(() {
                                _success = 3;
                              });
                            }

                          },
                          child: Center(
                              child: Text(
                                  'LOGIN',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Montserrat'
                                  )
                              )
                          )
                      ),
                    ),
                  ),
                  SizedBox(height: 15,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed('/signup');
                        },
                        child: Text(
                            'Register',
                            style: TextStyle(
                                color: Colors.blueGrey,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline
                            )
                        ),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        )
    );
  }

}

  List todos = List.empty(growable: true);
  String input = "";
  String url = "https://swapi.co/api/people/";

  createTodos(){
    DocumentReference documentReference = FirebaseFirestore.instance.collection("MyTodos").doc(input);
    //map
    Map<String, String> todos = {"todoTitle": input};
    documentReference.set(todos).whenComplete((){
      print("$input created");
    });
  }

  deleteTodos(item){
    DocumentReference documentReference = FirebaseFirestore.instance.collection("MyTodos").doc(item);

    documentReference.delete().whenComplete((){
      print("$item deleted");
    });
  }

  @override
  void initState() {
    initState();
    todos.add("Item1");
    todos.add("Item2");
    todos.add("Item3");
    todos.add("Item4");
  }
  @override
  Widget build(BuildContext context) {
    //Firebase.initializeApp();
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('TODO LIST'),
           actions: [
                IconButton(
                    onPressed: () async {
                    print(context);
                    showMenu(
                      context: context,
                      position: const RelativeRect.fromLTRB(110.0, 80.0, 0.0, 0.0),
                      items: ["Home", "SignIN", "Settings", "SignOut"]
                      .map(
                          (value) => PopupMenuItem<String>(
                          child: Text(value),
                          value: value,
                    ),
                  )
                  .toList(),
              elevation: 8.0,
            );
          },
          icon: Icon(Icons.menu),
        ),
      ],

    ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
           showDialog(
               context: context,
                builder: (BuildContext context) {
                 return AlertDialog(
                   shape: RoundedRectangleBorder(borderRadius:
                   BorderRadius.circular(8)),
                   title: Text("Add Todolist"),
                   content: TextField(
                      onChanged: (String value) {
                        input = value;
                    },
                  ),
                   actions: <Widget>[
                     TextButton(
                         onPressed: (){
                           createTodos();
                          Navigator.of(context).pop();
                     },child: Text("Add"))
                   ],
                );
          });
    },
        child: Icon(
          Icons.add,
        ),
    ),

        body: StreamBuilder<QuerySnapshot>(stream: FirebaseFirestore.instance.collection("MyTodos").snapshots(),builder: (context,AsyncSnapshot<QuerySnapshot> snapshots){
                return ListView.builder(
                  shrinkWrap: true,
            itemCount: snapshots.data.docs.length,
            itemBuilder: (context,index) {
              QueryDocumentSnapshot<Object> documentSnapshot = snapshots.data.docs[index];
              return Dismissible(
                onDismissed: (direction) {
                  deleteTodos(documentSnapshot["todoTitle"]);
                },
              key: Key(documentSnapshot["todoTitle"]),
              child: Card(
                elevation: 4,
                margin: EdgeInsets.all(8),
                shape: RoundedRectangleBorder(borderRadius:
                BorderRadius.circular(8)),
                  child: ListTile(
                    title: Text(documentSnapshot["todoTitle"]),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,),
                        onPressed: () {
                          deleteTodos(documentSnapshot["todoTitle"]);
                        }
                    ),

                  )));
        });}),
    );

  }

