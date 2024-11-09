import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() async {
  // Initialize the GraphQL Flutter cache
  await initHiveForFlutter();

  final HttpLink httpLink = HttpLink('https://countries.trevorblades.com/');

  final GraphQLClient client = GraphQLClient(
    cache: GraphQLCache(),
    link: httpLink,
  );

  runApp(MyApp(client: client));
}

class MyApp extends StatelessWidget {
  final GraphQLClient client;

  MyApp({required this.client});

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: ValueNotifier(client),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'SpaceX Launches',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: LaunchesScreen(),
      ),
    );
  }
}

class LaunchesScreen extends StatelessWidget {
  // Use the countries query for testing
  final String countriesQuery = """
    query GetCountries {
      countries {
        code
        name
        emoji
      }
    }
  """;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Countries'),
        backgroundColor: Colors.blue,
      ),
      body: Query(
        options: QueryOptions(
          document: gql(countriesQuery), // Use countriesQuery here
          pollInterval:
              const Duration(seconds: 10), // Refresh data every 10 seconds
        ),
        builder: (QueryResult result,
            {VoidCallback? refetch, FetchMore? fetchMore}) {
          if (result.hasException) {
            return Center(child: Text('Error: ${result.exception.toString()}'));
          }

          if (result.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final List countries = result.data!['countries'];

          return ListView.builder(
            itemCount: countries.length,
            itemBuilder: (context, index) {
              final country = countries[index];
              return Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 7),
                        child: Text(
                          "${index + 1}.",
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          title: Text(
                            "${country['name']}",
                            style: const TextStyle(fontSize: 20),
                          ),
                          subtitle: Text('Code: ${country['code']}'),

                          //leading: Text("${index + 1}."),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 7),
                        child: Text(
                          country['emoji'],
                          style: const TextStyle(fontSize: 50),
                        ),
                      )
                    ],
                  ),
                  const Divider(),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
