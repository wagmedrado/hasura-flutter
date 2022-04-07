import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hasuraflutter/model/user_model.dart';
import 'package:hasuraflutter/pages/subscription_page.dart';
import 'package:hasuraflutter/repository/hasura_repository.dart';

void main() async {
  await dotenv.load(fileName: 'assets/.env');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hasura Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Hasura Flutter App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  late Future<List<User>> _listaUsuario;
  final HasuraRepository _hasuraRepository = HasuraRepository();

  Future<List<User>> _getUsers() async {
    return await _hasuraRepository.getUsersListQuery();
  }

  @override
  void initState() {
    super.initState();
    _listaUsuario = _getUsers();
  }

  Column _listCommentsView(List<Comment> data) {
    List<Widget> children = [];
    for (final item in data) {
      children.add(
        Row(
          children: [
            Icon(Icons.comment, size: 16, color: Theme.of(context).disabledColor,),
            const SizedBox(width: 5,),
            Expanded(child: Text(item.commentText ?? '')),
          ],
        )
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  Column _listPostView(List<Post> data) {
    List<Widget> children = [];
    for (final item in data) {
      children.add(Text(item.insertDate ?? '',));
      children.add(Text(item.title ?? '', style: const TextStyle(fontWeight: FontWeight.w500),));
      children.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(item.description ?? '', style: TextStyle(color: Theme.of(context).disabledColor),),
        )
      );
      children.add(_listCommentsView(item.comments));
      children.add(const SizedBox(height: 16,));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  Column _listUserView(List<User> data) {
    List<Widget> children = [];
    for (final item in data) {
      children.add(const Divider(height: 3,));
      children.add(_tile(item.name ?? '', item.email ?? 'no email'));
      children.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _listPostView(item.posts),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  ListTile _tile(String title, String subtitle) => ListTile(
    leading: const CircleAvatar(
      child: Icon(Icons.person, color: Colors.black26,),
      backgroundColor: Colors.black12,
    ),
    title: Text(title,),
    subtitle: Text(subtitle),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SubscriptionPage()),
                );
              },
              icon: const Icon(Icons.radar)
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text('Users',),
            ),
            FutureBuilder<List<User>>(
              future: _listaUsuario,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return _listUserView(snapshot.data!);
                } else if (snapshot.hasError) {
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text('${snapshot.error}', style: TextStyle(color: Theme.of(context).errorColor),),
                  );
                }
                return const LinearProgressIndicator(minHeight: 1.5,);
              }
            ),
          ],
        ),
      ),
    );
  }
}
