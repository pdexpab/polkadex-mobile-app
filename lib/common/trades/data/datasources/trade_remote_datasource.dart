import 'dart:convert';
import 'package:http/http.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:polkadex/common/network/blockchain_rpc_helper.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:polkadex/common/web_view_runner/web_view_runner.dart';
import 'package:polkadex/injection_container.dart';
import 'package:polkadex/common/network/mysql_client.dart';

class TradeRemoteDatasource {
  final _baseUrl = dotenv.env['POLKADEX_HOST_URL']!;

  Future<String?> placeOrder(
    int nonce,
    String baseAsset,
    String quoteAsset,
    String orderType,
    String orderSide,
    String price,
    String amount,
    String address,
    String signature,
  ) async {
    try {
      final dbClient = dependency<MysqlClient>();
      final mainAddress = await dbClient.getMainAddress(address);

      final nonce = await BlockchainRpcHelper.sendRpcRequest(
          'enclave_getNonce', [mainAddress]);

      final String _callPlaceOrderJSON =
          "polkadexWorker.placeOrderJSON(keyring.getPair('$address'), ${nonce + 1}, '$baseAsset', '$quoteAsset', '$orderType', '$orderSide', $price, $amount)";
      final List<dynamic> payloadResult = await dependency<WebViewRunner>()
          .evalJavascript(_callPlaceOrderJSON, isSynchronous: true);

      return (await BlockchainRpcHelper.sendRpcRequest(
          'enclave_placeOrder', payloadResult)) as String?;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<Response> cancelOrder(
    int nonce,
    String address,
    int orderUuid,
    String signature,
  ) async {
    return await post(
      Uri.parse('$_baseUrl/cancel_order'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'signature': {'Sr25519': signature},
        'payload': {
          'account': address,
          'order_id': orderUuid,
        },
      }),
    );
  }

  Future<IResultSet> fetchOrders(String address) async {
    final dbClient = dependency<MysqlClient>();

    return dbClient.getOrderHistory(address);
  }

  Future<IResultSet> fetchTrades(String address) async {
    final dbClient = dependency<MysqlClient>();

    return dbClient.getTradeHistory(address);
  }
}