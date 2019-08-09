import 'package:hasura_connect/hasura_connect.dart';

main() async {
  HasuraConnect conn =
      HasuraConnect('https://mvp-rtc-project.herokuapp.com/v1/graphql');

  // var r = await conn.query(docQuery);
  // print(r);

  Map<String,dynamic> data = await conn.query(docQuery, variables: {"limit": 3});
  print(data);

  Snapshot snap = await conn.subscription(docSubscription, variables: {"limit": 3});
  snap.stream.listen((data) {
    print(data);
    print("==================");
  }).onError((err) {
    print(err);
  });

  await Future.delayed(Duration(seconds: 4));
  snap.changeVariable({"limit": 6});
}

String docSubscription = """
  subscription algumaCoisa(\$limit:Int!){
  users(limit: \$limit, order_by: {user_id: desc}) {
    user_id
    user_email
    user_password
  }
}
""";

String docQuery = """
query userList(\$limit: Int!) {
  users(limit: \$limit) {
    user_id
  }
}
""";