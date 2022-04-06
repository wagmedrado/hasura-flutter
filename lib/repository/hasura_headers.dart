import 'package:flutter_dotenv/flutter_dotenv.dart';

Map<String, String> headers = {
  'content-type': 'application/json',
  //'x-hasura-admin-secret': 'HASURA_ADMIN_SECRET',
  'Authorization': 'Bearer ' + dotenv.get('HASURA_TOKEN'),
};