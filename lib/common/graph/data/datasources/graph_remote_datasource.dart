import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:polkadex/graphql/subscriptions.dart';
import 'package:polkadex/graphql/queries.dart';

class GraphRemoteDatasource {
  Future<GraphQLResponse> getCoinGraphData(
    String leftTokenId,
    String rightTokenId,
    String timestamp,
    DateTime from,
    DateTime to,
  ) async {
    return await Amplify.API
        .query(
          request: GraphQLRequest(
            document: getKlinesbyMarketInterval,
            variables: {
              'market': '$leftTokenId-$rightTokenId',
              'interval': timestamp,
              'from': from.toUtc().toIso8601String(),
              'to': to.toUtc().toIso8601String(),
            },
          ),
        )
        .response;
  }

  Future<Stream> getCoinGraphStream(
    String leftTokenId,
    String rightTokenId,
    String timestamp,
  ) async {
    return Amplify.API.subscribe(
      GraphQLRequest(
        document: onCandleStickEvents,
        variables: <String, dynamic>{
          'm': '$leftTokenId-$rightTokenId',
          'interval': timestamp,
        },
      ),
      onEstablished: () =>
          print('onCandleStickEvents subscription established'),
    );
  }
}
