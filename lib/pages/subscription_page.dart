import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hasura_connect/hasura_connect.dart';

import '../model/user_model.dart';
import '../repository/hasura_repository.dart';

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({Key? key}) : super(key: key);

  @override
  State<SubscriptionPage> createState() => _SubscriptionPage();
}

class _SubscriptionPage extends State<SubscriptionPage> {
  final HasuraRepository _hasuraRepository = HasuraRepository();

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

  final _streamController = StreamController<List<User>>();

  _loadUsers() async {
    //List<User> users = await _hasuraRepository.getUsersListSubscription();
    //_streamController.add(users);
  }

  @override
  Widget build(BuildContext context) {
    var stream = StreamBuilder(
      stream: _hasuraRepository.getUsersListSubscription().asStream(),
      builder: (context, AsyncSnapshot<Snapshot<List<User>>> snapshot) {
        if (snapshot.hasData) {
          return _listUserView(snapshot.data!.value!);
        } else if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Text('${snapshot.error}', style: TextStyle(color: Theme.of(context).errorColor),),
          );
        }
        return const LinearProgressIndicator(minHeight: 1.5,);
      }
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hasura Subscription Page'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text('Users',),
            ),
            stream,
          ],
        ),
      ),
    );
  }
}
