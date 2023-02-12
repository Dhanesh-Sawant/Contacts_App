import 'package:flutter/material.dart';

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
  final String name;
  Contact({required this.name});


}

class ContactBook{

  static final ContactBook _instance = ContactBook._internal();

  factory ContactBook() {
    return _instance;
  }

  ContactBook._internal() {

  }

  final List<Contact> _contacts = [];
  int get length => _contacts.length;

  void add({required Contact contact}){
    _contacts.add(contact);
  }

  void remove({required Contact contact}){
    _contacts.remove(contact);
  }

  Contact? contact({required int atIndex}) =>
      length > atIndex ? _contacts[atIndex] : null;

}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key? key}) : super(key: key);

  final contactBook = ContactBook();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Your Contacts')),
      ),
      body: ListView.builder(
          itemBuilder: (context, index){

            final contact = contactBook.contact(atIndex: index)!;
            return ListTile(
              title: Text(contact.name),
            );
          },
          itemCount: contactBook.length,
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
