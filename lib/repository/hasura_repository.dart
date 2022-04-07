import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hasura_connect/hasura_connect.dart';
import 'package:hasuraflutter/model/user_model.dart';

//import 'hasura_headers.dart';

class HasuraRepository {
  //set HASURA_ADMIN_SECRET or HASURA_TOKEN on /assets/.env
  final HasuraConnect hasura = HasuraConnect(
    dotenv.get('HASURA_ENDPOINT'),
    headers: {
      'content-type': 'application/json',
      'x-hasura-admin-secret': dotenv.get('HASURA_ADMIN_SECRET'),
      //'Authorization': 'Bearer ' + dotenv.get('HASURA_TOKEN'),
    },
  );

  Future<List<User>> getUsersListQuery() async {
    //print('obterUsuarios');
    const query = r'''
      query MyQuery {
        users {
          id
          email
          name
          last_login
          posts {
            id
            title
            description
            insert_date
            comments {
              id
              email
              insert_date
              comment_text
            }
          }
        }
      }
    ''';
    final Map<String, dynamic> result = await hasura.query(query);

    final users = (result['data']['users'] as List).map((item) => User.fromJson(item)).toList();

    return users;
  }

  Future<Snapshot<List<User>>> getUsersListSubscription() async {
    const subscription = r'''
      subscription MySubscription {
        users {
          id
          email
          name
          last_login
          posts {
            id
            title
            description
            insert_date
            comments {
              id
              email
              insert_date
              comment_text
            }
          }
        }
      }
    ''';

    final Snapshot<dynamic> result = await hasura.subscription(
      subscription
    );

    return result.map((event) {
      if (event == null) {
        return <User>[];
      }
      return (event['data']['users'] as List).map((user) => User.fromJson(user)).toList();
    });
  }
}
