import 'package:flutter/material.dart';
import 'package:pfe_salim/api/view_model/line_view_model.dart';
import 'package:pfe_salim/utils/custom_date_utils.dart';
import 'package:pfe_salim/utils/language/localization.dart';
import 'package:pfe_salim/utils/theme/theme_styles.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../../../../../model/line.dart';
import '../../../../../utils/dimensions.dart';
import '../../../../api/response/status.dart';
import '../../../widgets/custom_error_widget.dart';
import '../../../widgets/loading_widget.dart';

class LineDetailsView extends StatelessWidget {
  final Line line;

  const LineDetailsView({
    super.key,
    required this.line,
  });

  @override
  Widget build(BuildContext context) {
    // API
    LineViewModel lineViewModel = LineViewModel();
    lineViewModel.setItem(item: line, notifyChanges: false);

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/bg.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Styles.primaryColor.withOpacity(0.5),
              Colors.black.withOpacity(0.6),
              Styles.primaryColor.withOpacity(0.3),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(title: Text("${intl.line} ${intl.details}")),
          body: Container(
            width: double.maxFinite,
            padding: Dimensions.mediumPadding,
            child: ChangeNotifierProvider<LineViewModel>(
              create: (context) => lineViewModel,
              child: Consumer<LineViewModel>(
                builder: (context, viewModel, child) {
                  if (viewModel.apiResponse.status == Status.completed) {
                    return _buildLineDetailsWidget(
                      context: context,
                      lineViewModel: viewModel,
                      line: viewModel.item,
                    );
                  } else if (viewModel.apiResponse.status == Status.loading) {
                    return const LoadingWidget();
                  } else {
                    return const CustomErrorWidget();
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLineDetailsWidget({
    required BuildContext context,
    required LineViewModel lineViewModel,
    required Line line,
  }) {
    return SingleChildScrollView(
      child: Card(
        margin: const EdgeInsets.all(5),
        shape: const RoundedRectangleBorder(
          borderRadius: Dimensions.roundedBorderBig,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Builder(
                builder: (context) {
                  DateTime now = DateTime.now();
                  int currentHour = now.hour;

                  String shift;

                  if (currentHour >= 6 && currentHour < 14) {
                    shift = "Equipe Matin";
                  } else if (currentHour >= 14 && currentHour < 22) {
                    shift = "Equipe Après-midi";
                  } else {
                    shift = "Equipe Soir";
                  }

                  return Text(shift);
                },
              ),
              _buildProgressCircle(progress: line.quantity.toDouble()),
              const SizedBox(height: 30),
              Text(
                "${intl.date} : "
                "${CustomDateUtils.getStringFromDate(DateTime.now())}",
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "${intl.doubleDotPlaceholder(intl.quantity)} "
                      "${line.quantity}",
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "Reference : ${line.reference}",
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // CADENCE
  Widget _buildProgressCircle({required double progress}) {
    progress = progress * 10;

    return SfRadialGauge(
      axes: <RadialAxis>[
        RadialAxis(
          minimum: 0,
          maximum: 100,
          showLabels: false,
          showTicks: false,
          axisLineStyle: const AxisLineStyle(
            thickness: 80,
            gradient: SweepGradient(
              colors: [
                dangerColor,
                warningColor,
                successColor,
                noticeColor,
              ],
            ),
          ),
          pointers: <GaugePointer>[
            RangePointer(
              value: progress,
              width: 65,
              sizeUnit: GaugeSizeUnit.logicalPixel,
              gradient: progress < 25
                  ? const SweepGradient(colors: [dangerColor])
                  : progress < 50
                      ? const SweepGradient(colors: [dangerColor, warningColor])
                      : progress < 75
                          ? const SweepGradient(
                              colors: [dangerColor, warningColor, successColor],
                            )
                          : const SweepGradient(
                              colors: [
                                dangerColor,
                                warningColor,
                                successColor,
                                noticeColor,
                              ],
                            ),
            ),
          ],
          annotations: <GaugeAnnotation>[
            GaugeAnnotation(
              angle: 90,
              axisValue: 5,
              positionFactor: 0.2,
              widget: Text(
                "${progress.toInt()} %",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Styles.textColor,
                ),
              ),
            ),
            GaugeAnnotation(
              angle: 90,
              axisValue: 5,
              positionFactor: 1,
              widget: Text(
                "Cadence",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Styles.textColor,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
