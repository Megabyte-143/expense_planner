import '../modals/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import './chart_bar.dart';

class Chart extends StatelessWidget {
  final List<Tx> recentTxs;

  Chart(this.recentTxs) {
    print('constructor char');
  }

  List<dynamic> get groupedTx {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));
      var totalSum = 0.0;

      for (var i = 0; i < recentTxs.length; i++) {
        if (recentTxs[i].date.day == weekDay.day &&
            recentTxs[i].date.month == weekDay.month &&
            recentTxs[i].date.year == weekDay.year) {
          totalSum += recentTxs[i].amount;
        }
      }

      return {
        'day': DateFormat.E().format(weekDay).substring(0, 1),
        'amt': totalSum
      };
    }).reversed.toList();
  }

  double get maxSpending {
    return groupedTx.fold(0.0, (sum, item) {
      return sum + item['amt'];
    });
  }

  @override
  Widget build(BuildContext context) {
    print('build() Chart');
    return Card(
      elevation: 10,
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTx.map((data) {
            return Flexible(
              fit: FlexFit.loose,
              child: ChartBar(
                data['day'],
                data['amt'],
                maxSpending == 0.0
                    ? 0.0
                    : ((data['amt'] as double) / maxSpending),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
