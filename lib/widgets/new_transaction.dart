import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/widgets/adaptiveButton.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addNewTx;

  NewTransaction(this.addNewTx);

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleInput = TextEditingController();
  final _amountInput = TextEditingController();
  DateTime _selectedDate;

  void submitData() {
    if (_amountInput.text == null) {
      return;
    }

    final enteredTitle = _titleInput.text;
    final enteredAmount = double.parse(_amountInput.text);

    if (enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate == null) {
      return;
    }

    widget.addNewTx(enteredTitle, enteredAmount, _selectedDate);

    Navigator.of(context).pop(); // close the input form after hitting enter
  }

  void _presentDatePick() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate != null) {
        setState(() {
          _selectedDate = pickedDate;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(labelText: "Title"),
                controller: _titleInput,
                onSubmitted: (_) => submitData(),
              ),
              TextField(
                decoration: InputDecoration(labelText: "Amount"),
                controller: _amountInput,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => submitData(),
              ),
              Container(
                height: 70,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        _selectedDate == null ? 'No Date Chosen' : DateFormat.yMd().format(_selectedDate),
                      ),
                    ),
                    AdaptiveButton("Choose Date", _presentDatePick),
                  ],
                ),
              ),
              RaisedButton(
                onPressed: submitData,
                textColor: Theme.of(context).primaryColor,
                color: Theme.of(context).textTheme.button.color,
                child: Text('Add Transaction'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
