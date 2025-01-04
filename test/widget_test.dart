import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:sample/main.dart';  // Ensure this path points to your main.dart

void main() {
  testWidgets('Test MyApp widget', (WidgetTester tester) async {
    // Initialize the GraphQL Flutter cache
    await initHiveForFlutter();

    final HttpLink httpLink = HttpLink('https://countries.trevorblades.com/');

    final GraphQLClient client = GraphQLClient(
      cache: GraphQLCache(),
      link: httpLink,
    );

    // Provide the mock GraphQLClient to MyApp (without 'const' keyword)
    await tester.pumpWidget(MyApp(client: client));

    // Add test expectations
    expect(find.byType(MyApp), findsOneWidget);
  });
}
