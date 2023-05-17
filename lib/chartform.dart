import 'package:bloodpressure/pressureclass.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

enum ChartType { LINE, SCATTER }

class ChartForm extends StatefulWidget {
  List<PressureClass> originList = List.empty(growable: true);

  ChartForm({super.key, required this.originList});

  @override
  State<StatefulWidget> createState() {
    return ChartFormState();
  }
}

class ChartFormState extends State<ChartForm> {
  List<CartesianSeries> _getLineSeries(List<PressureClass> items) {
    return <CartesianSeries>[
      LineSeries<PressureClass, String>(
          dataSource: items,
          xValueMapper: (PressureClass pressure, _) => pressure.time,
          yValueMapper: (PressureClass pressure, _) => pressure.high,
          name: "수축기",
          markerSettings: const MarkerSettings(isVisible: true)),
      LineSeries<PressureClass, String>(
          dataSource: items,
          xValueMapper: (PressureClass pressure, _) => pressure.time,
          yValueMapper: (PressureClass pressure, _) => pressure.low,
          name: "이완기",
          markerSettings: const MarkerSettings(isVisible: true))
    ];
  }

  List<CartesianSeries> _getScatterSeries(List<PressureClass> items) {
    List<PressureClass> chartItems = List.from(items);
    chartItems.sort((a, b) => a.high.compareTo(b.high));

    return <CartesianSeries>[
      ScatterSeries<PressureClass, String>(
          dataSource: chartItems,
          xValueMapper: (PressureClass pressure, _) => pressure.high.toString(),
          yValueMapper: (PressureClass pressure, _) => pressure.low,
          name: "수축/이완기",
          markerSettings: const MarkerSettings(isVisible: true)),
    ];
  }

  Widget _getChartWidget(ChartType chartType) {
    var seriesItem;

    String chartName = "Line 차트";

    switch (chartType) {
      case ChartType.LINE:
        seriesItem = _getLineSeries(widget.originList);
        break;
      case ChartType.SCATTER:
        seriesItem = _getScatterSeries(widget.originList);
        chartName = "분포도 차트";
        break;
      default:
    }

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SfCartesianChart(
        title: ChartTitle(text: chartName),
        legend: Legend(isVisible: true),
        primaryXAxis: CategoryAxis(
            majorGridLines: const MajorGridLines(width: 0), labelRotation: -45),
        primaryYAxis: NumericAxis(
            axisLine: const AxisLine(width: 0),
            labelFormat: r'{value}',
            majorTickLines: const MajorTickLines(size: 0)),
        tooltipBehavior: TooltipBehavior(enable: true),
        series: seriesItem,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          
          _getChartWidget(ChartType.LINE),
          _getChartWidget(ChartType.SCATTER),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
                onPressed: () => {Navigator.pop(context)},
                child: const Text("닫기")),
          ),
        ],
      ),
    );
  }
}
