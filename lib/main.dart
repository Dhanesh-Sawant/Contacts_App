import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  MyHomePage(),

      routes: {
        NewContactView.routeName : (context) => NewContactView()
      },

    );
  }
}

class Contact{

  final String id;
  final String name;
  Contact({required this.name}): id = const Uuid().v4();

}

class ContactBook extends ValueNotifier<List<Contact>>
{

  ContactBook._sharedInstance(): super([]);
  static final ContactBook _shared = ContactBook._sharedInstance();

  factory ContactBook() =>_shared;

  // final List<Contact> _contacts = [];


  int get length => value.length;


  void add({required Contact contact}){

    // value.add(contact);
    // notifyListeners();
    // (OR)

    final contacts = value;
    contacts.add(contact);
    value = contacts;
    notifyListeners();
  }

  void remove({required Contact contact}){
    final contacts = value;
    if(contacts.contains(contact)){
      contacts.remove(contact);
      notifyListeners();
    }
  }

  Contact? contact({required int atIndex}) =>
      value.length > atIndex ? value[atIndex] : null;

}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key? key}) : super(key: key);

  // final contactBook = ContactBook();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Your Contacts')),
      ),
      body: ValueListenableBuilder(
        valueListenable: ContactBook(),
        builder: (context,value,child){
          final contacts = value as List<Contact>;
          return ListView.builder(
            itemBuilder: (context, index){
              final contact = contacts[index];
              return Dismissible(
                onDismissed: (direction){
                  contacts.remove(contact);
                  //ContactBook().remove(contact: contact);
                },
                key: ValueKey(contact.id),
                child: Material(
                  color: Colors.white,
                  elevation: 6.0,
                  child: ListTile(
                  title: Text(contact.name),
                ),
                )
              );
            },
            itemCount: contacts.length,
          );
        },

      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).pushNamed(NewContactView.routeName);
        },
        child: Icon(Icons.add),
      ),

    );
  }
}

class NewContactView extends StatefulWidget {
  const NewContactView({Key? key}) : super(key: key);

  static String routeName = 'NewContactView';

  @override
  State<NewContactView> createState() => _NewContactViewState();
}

class _NewContactViewState extends State<NewContactView> {

  late final TextEditingController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Contact'),),

      body: Column(
        children: [
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              hintText: 'Enter the new contact\'s name..',
            ),
          ),

          TextButton(
              onPressed: (){
                final contact = Contact(name: _controller.text);
                ContactBook().add(contact: contact);
                Navigator.pop(context);
              },
              child: Text('Add Contact'),
          )
        ],
      )

    );

  }
}
