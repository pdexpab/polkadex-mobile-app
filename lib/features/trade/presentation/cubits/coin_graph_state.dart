import 'package:equatable/equatable.dart';
import 'package:polkadex/common/graph/domain/entities/line_chart_entity.dart';
import 'package:polkadex/common/utils/enums.dart';

abstract class CoinGraphState extends Equatable {
  const CoinGraphState({
    required this.timestampSelected,
  });

  final EnumAppChartTimestampTypes timestampSelected;

  @override
  List<Object?> get props => [timestampSelected];
}

class CoinGraphInitial extends CoinGraphState {
  CoinGraphInitial({
    required EnumAppChartTimestampTypes timestampSelected,
  }) : super(
          timestampSelected: timestampSelected,
        );
}

class CoinGraphLoading extends CoinGraphState {
  CoinGraphLoading({
    required EnumAppChartTimestampTypes timestampSelected,
  }) : super(
          timestampSelected: timestampSelected,
        );
}

class CoinGraphError extends CoinGraphState {
  CoinGraphError({
    required EnumAppChartTimestampTypes timestampSelected,
    required this.errorMessage,
  }) : super(
          timestampSelected: timestampSelected,
        );

  final String errorMessage;
}

class CoinGraphLoaded extends CoinGraphState {
  CoinGraphLoaded({
    required EnumAppChartTimestampTypes timestampSelected,
    required this.dataList,
    required this.indexPointSelected,
  }) : super(
          timestampSelected: timestampSelected,
        );

  final Map<String, List<LineChartEntity>> dataList;
  final int? indexPointSelected;

  CoinGraphLoaded copyWith({
    EnumAppChartTimestampTypes? timestampSelected,
    Map<String, List<LineChartEntity>>? dataList,
    int? indexPointSelected,
  }) {
    return CoinGraphLoaded(
      timestampSelected: timestampSelected ?? this.timestampSelected,
      dataList: dataList ?? this.dataList,
      indexPointSelected: indexPointSelected ?? this.indexPointSelected,
    );
  }

  double? get selectedOpen =>
      indexPointSelected != null && dataList['open'] != null
          ? dataList['open']![indexPointSelected!].pointY
          : null;
  double? get selectedLow =>
      indexPointSelected != null && dataList['low'] != null
          ? dataList['low']![indexPointSelected!].pointY
          : null;
  double? get selectedHigh =>
      indexPointSelected != null && dataList['high'] != null
          ? dataList['high']![indexPointSelected!].pointY
          : null;
  double? get selectedClose =>
      indexPointSelected != null && dataList['close'] != null
          ? dataList['close']![indexPointSelected!].pointY
          : null;

  @override
  List<Object?> get props => [
        timestampSelected,
        dataList,
        indexPointSelected,
      ];
}
