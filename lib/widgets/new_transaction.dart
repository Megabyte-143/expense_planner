import 'package:expense_planner/widgets/adaptive_flat_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTx extends StatefulWidget {
  final Function addTx;
  // String titleInput='';
  // String amtInput='';

  NewTx(this.addTx) {
    print("constructor new transaction wodget");
  }

  @override
  _NewTxState createState() {
    print("createstate new transaction wodget");
    return _NewTxState();
  }
}

class _NewTxState extends State<NewTx> {
  final _titleController = TextEditingController();

  final _amtController = TextEditingController();

  DateTime _selectDate = DateTime.now();
  _NewTxState() {
    print("constructor new transaction state");
  }

  @override
  void initState() {
    print("initState ");
    super.initState();
  }

  @override
  void didUpdateWidget(covariant NewTx oldWidget) {
    print("update widget");
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    print("dispose");
    super.dispose();
  }

  void _addData() {
    if (_amtController.text.isEmpty) {
      return;
    }

    final enteredTitle = _titleController.text;
    final enteredAmt = double.parse(_amtController.text);

    if (enteredAmt <= 0 || enteredTitle.isEmpty || _selectDate == null) {
      return;
    }

    widget.addTx(
      enteredTitle,
      enteredAmt,
      _selectDate,
    );

    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      } 
        setState(() {
          _selectDate = pickedDate;
        });
    });
    print('...');
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        color: Colors.grey,
        elevation: 10,
        child: Container(
          padding: EdgeInsets.only(
              top: 10,
              left: 10,
              right: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom + 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextField(
                decoration: const InputDecoration(labelText: 'Item'),
                // onChanged: (val) {
                //   titleInput = val;
                // },
                controller: _titleController,
                onSubmitted: (_) => _addData(),
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                controller: _amtController,
                onSubmitted: (_) => _addData(),
                // onChanged: (val) {
                //   amtInput = val;
                // },
              ),
              SizedBox(
                height: 70,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(_selectDate==null ? "No Date Chosen!":
                        'Picked Date : ${DateFormat.yMd().format(_selectDate)}',
                      ),
                    ),
                    AdaptiveFlatButton('Choose Date', _presentDatePicker)
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: _addData,
                child: const Text(
                  'Add Transaction',
                ),
                style: ElevatedButton.styleFrom(
                  textStyle: TextStyle(
                    color: Theme.of(context).textTheme.button!.color,
                  ),
                  onSurface: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
