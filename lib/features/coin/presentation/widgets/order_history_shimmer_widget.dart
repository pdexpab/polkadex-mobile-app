import 'package:flutter/material.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/styles.dart';
import 'package:shimmer/shimmer.dart';

class OrderHistoryShimmerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      highlightColor: AppColors.color8BA1BE,
      baseColor: AppColors.color2E303C,
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 24),
        itemBuilder: (context, index) => Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          padding: const EdgeInsets.fromLTRB(14, 17, 14, 17),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.2),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: AppColors.colorFFFFFF,
                ),
                width: 42,
                height: 42,
                padding: const EdgeInsets.all(3),
              ),
              SizedBox(width: 9),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'DOT/BTC',
                      style: tsS16W500CFF,
                    ),
                  ),
                  SizedBox(height: 4),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '10:12:07 AM',
                      style:
                          tsS13W500CFF.copyWith(color: AppColors.colorABB2BC),
                    ),
                  ),
                ],
              ),
              Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '0.451 DOT / 0.451 DOT',
                      style: tsS16W500CFF,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        itemCount: 3,
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
      ),
    );
  }
}
