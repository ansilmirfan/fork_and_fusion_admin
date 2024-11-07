import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fork_and_fusion_admin/core/shared/constants.dart';
import 'package:fork_and_fusion_admin/features/domain/entity/order_entity.dart';
import 'package:fork_and_fusion_admin/features/presentation/bloc/order_bloc/order_bloc.dart';
import 'package:fork_and_fusion_admin/features/presentation/pages/dashboard/widgets/gridtile.dart';
import 'package:fork_and_fusion_admin/features/presentation/widgets/drawer/custom_drawer.dart';
import 'package:fork_and_fusion_admin/features/presentation/widgets/empty_message.dart';
import 'package:fork_and_fusion_admin/features/presentation/widgets/loading.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<OrderBloc>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      drawer: const CustomDrawer(),
      body: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          if (state is OrderLoadingState) {
            return const Loading();
          } else if (state is OrderCompletedState) {
            return _buildBody(state);
          }
          return const EmptyMessage(message: 'Network Error');
        },
      ),
    );
  }

  SingleChildScrollView _buildBody(OrderCompletedState state) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _gridView(state),
          _title('Weekly Sale'),
          Padding(
            padding: Constants.padding10,
            child: SizedBox(
              height: Constants.dHeight / 3,
              child: BarChart(
                weeklySalesBarChart(state.orders),
              ),
            ),
          ),
          _title('Monthly Sale'),
          Padding(
            padding: Constants.padding10,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                height: Constants.dHeight / 3,
                width: 500,
                child: LineChart(
                  monthlySalesLineChart(state.orders),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding _title(String text) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  GridView _gridView(OrderCompletedState state) {
    return GridView(
      padding: Constants.padding10,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 1.5,
          crossAxisCount: 2,
          mainAxisSpacing: 5,
          crossAxisSpacing: 5),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        Gridtile(
            title: 'Overall Sale',
            icon: Icons.pie_chart_outline,
            value: '₹${state.overallSale}'),
        Gridtile(
            title: "Today's Sale",
            icon: Icons.pie_chart_rounded,
            value: "₹${state.todaysSale}"),
        Gridtile(
          title: "Total Orders",
          icon: Icons.bar_chart,
          value: " ${state.totalOrderCount}",
        ),
        Gridtile(
            title: "Today's Orders",
            icon: Icons.show_chart,
            value: " ${state.todaysOrderCount}"),
      ],
    );
  }

  //--------------- Weekly Sales Bar Chart---------
  BarChartData weeklySalesBarChart(List<OrderEntity> orders) {
    final List<double> weeklySales = getSalesData(orders, 7);

    return BarChartData(
      borderData: FlBorderData(show: false),
      barGroups: List.generate(
        weeklySales.length,
        (index) => BarChartGroupData(
          x: index + 1,
          barRods: [
            BarChartRodData(
              toY: weeklySales[index],
              color: Colors.blue,
              width: 10,
            ),
          ],
        ),
      ),
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 50,
            interval: 1000,
            getTitlesWidget: (value, meta) {
              return Text(
                '${value.toInt()}k',
                style: const TextStyle(
                  fontSize: 12,
                ),
              );
            },
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: (value, meta) {
              return Text(
                'Day ${value.toInt()}',
                style: const TextStyle(fontSize: 10),
              );
            },
          ),
        ),
      ),
      gridData: const FlGridData(show: true),
    );
  }

  //----------- Monthly Sales Line Chart
  LineChartData monthlySalesLineChart(List<OrderEntity> orders) {
    final List<double> monthlySales = getSalesData(orders, 30);

    return LineChartData(
      borderData: FlBorderData(show: false),
      lineBarsData: [
        LineChartBarData(
          spots: List.generate(
            monthlySales.length,
            (index) => FlSpot(index.toDouble(), monthlySales[index]),
          ),
          isCurved: true,
          barWidth: 2,
          belowBarData: BarAreaData(
            show: true,
          ),
          dotData: const FlDotData(
            show: true,
          ),
        ),
      ],
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            interval: 500,
            getTitlesWidget: (value, meta) {
              return Text(
                '${value.toInt()}',
                style: const TextStyle(fontSize: 10),
              );
            },
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 5,
            getTitlesWidget: (value, meta) {
              return Text(
                'Day ${value.toInt()}',
                style: const TextStyle(fontSize: 10),
              );
            },
          ),
        ),
      ),
      gridData: const FlGridData(show: true),
    );
  }

  List<double> getSalesData(List<OrderEntity> orders, int days) {
    List<double> salesData = List.generate(days, (index) => 0.0);

    DateTime now = DateTime.now();
    for (var order in orders) {
      if (order.status == 'Served') {
        DateTime orderDate = order.date;
        int dayDifference = now.difference(orderDate).inDays;

        if (dayDifference < days) {
          salesData[dayDifference] += order.amount;
        }
      }
    }
    return salesData.reversed.toList();
  }
}
