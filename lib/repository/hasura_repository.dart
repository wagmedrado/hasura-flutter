import 'package:hasura_connect/hasura_connect.dart';
import 'package:hasuraflutter/model/user_model.dart';

import 'hasura_headers.dart';

class HasuraRepository {
  final HasuraConnect hasura = HasuraConnect(
    'http://192.168.0.112:8080/v1/graphql',
    headers: headers,
  );

  Future<List<User>> obterUsuarios() async {
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
    //print(result);

    final users = (result['data']['users'] as List).map((item) => User.fromJson(item)).toList();

    return users;
  }
}
