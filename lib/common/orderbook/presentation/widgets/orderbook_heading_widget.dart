import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:polkadex/common/configs/app_config.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/common/utils/extensions.dart';
import 'package:polkadex/common/utils/styles.dart';
import 'package:polkadex/features/landing/presentation/dialogs/trade_view_dialogs.dart';

import 'order_book_widget.dart';

/// The heading widget for the order book
class OrderBookHeadingWidget extends StatelessWidget {
  OrderBookHeadingWidget(
      {required this.marketDropDownNotifier,
      required this.priceLengthNotifier});

  final ValueNotifier<EnumMarketDropdownTypes> marketDropDownNotifier;
  final ValueNotifier<int> priceLengthNotifier;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () {
            showPriceLengthDialog(
              context: context,
              selectedIndex: priceLengthNotifier.value,
              onItemSelected: (index) => priceLengthNotifier.value = index,
            );
          },
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 2, right: 4),
                child: ValueListenableBuilder<int>(
                  valueListenable: priceLengthNotifier,
                  builder: (context, selectedPriceLenIndex, child) => Text(
                    dummyPriceLengthData[selectedPriceLenIndex].price,
                    style: tsS15W600CFF.copyWith(
                        color: AppColors.colorFFFFFF.withOpacity(0.30)),
                  ),
                ),
              ),
              Icon(
                Icons.keyboard_arrow_down,
                color: AppColors.colorFFFFFF,
                size: 16,
              ),
            ],
          ),
        ),
        Spacer(),
        ...EnumBuySellAll.values
            .map(
              (e) => Consumer<OrderBookWidgetFilterProvider>(
                builder: (context, provider, child) {
                  String svg;
                  double padding = 8;
                  Color color = AppColors.color2E303C;

                  switch (e) {
                    case EnumBuySellAll.buy:
                      svg = 'orderbookBuy'.asAssetSvg();
                      if (provider.enumBuySellAll == EnumBuySellAll.buy) {
                        svg = 'orderbookBuySel'.asAssetSvg();
                      }
                      break;
                    case EnumBuySellAll.all:
                      svg = 'orderbookAll'.asAssetSvg();

                      break;
                    case EnumBuySellAll.sell:
                      svg = 'orderbookSell'.asAssetSvg();
                      if (provider.enumBuySellAll == EnumBuySellAll.sell) {
                        svg = 'orderbookSellSel'.asAssetSvg();
                      }
                      break;
                  }

                  if (provider.enumBuySellAll == e) {
                    padding = 5;
                    color = Colors.white;
                  }
                  return InkWell(
                    onTap: () {
                      provider.enumBuySellAll = e;
                    },
                    child: AnimatedContainer(
                      duration: AppConfigs.animDurationSmall,
                      padding: EdgeInsets.all(padding),
                      margin: EdgeInsets.only(
                          right: e.index + 1 >= EnumBuySellAll.values.length
                              ? 0
                              : 7),
                      width: 31,
                      height: 31,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Colors.black.withOpacity(0.17),
                            blurRadius: 99,
                            offset: Offset(0.0, 100.0),
                          ),
                        ],
                      ),
                      child: SvgPicture.asset(svg),
                    ),
                  );
                },
              ),
            )
            .toList(),
      ],
    );
  }
}
