import 'package:flutter/material.dart';
import 'package:expense_planner/modals/transaction.dart';
import './transaction_item.dart';

class TxList extends StatelessWidget {
  final List<Tx> txs_list;
  final Function delTx;

  TxList(this.txs_list, this.delTx);

  @override
  Widget build(BuildContext context) {
    print('build() TxList');
    return txs_list.isEmpty
        ? LayoutBuilder(builder: (ctx, constraints) {
            return Column(
              children: <Widget>[
                Text(
                  'NO TXS',
                  style: Theme.of(context).textTheme.headline6,
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: constraints.maxHeight * 0.6,
                  child: Image.asset(
                    'assets/images/waiting.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            );
          })
        : ListView(children: [
            ...txs_list
                .map((tx) => TransactionItem(
                      key: ValueKey(tx.id),
                      tx: tx,
                      delTx: delTx,
                    ))
                .toList()
          ]);
  }
}
