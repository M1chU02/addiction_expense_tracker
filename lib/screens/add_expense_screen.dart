import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/expense.dart';

class AddExpenseScreen extends StatefulWidget {
  final Expense? expense; // Optional parameter for editing

  AddExpenseScreen({this.expense});

  @override
  _AddExpenseScreenState createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _itemController;
  late TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    _itemController = TextEditingController(text: widget.expense?.item ?? '');
    _priceController = TextEditingController(
        text: widget.expense != null ? widget.expense!.price.toString() : '');
  }

  Future<void> _saveExpense() async {
    final item = _itemController.text;
    final price = double.tryParse(_priceController.text) ?? 0;

    if (item.isEmpty || price <= 0) return;

    if (widget.expense == null) {
      // New expense
      final newExpense =
          Expense(item: item, price: price, date: DateTime.now());
      await DatabaseHelper.instance.insertExpense(newExpense);
    } else {
      // Updating existing expense
      final updatedExpense = Expense(
        id: widget.expense!.id,
        item: item,
        price: price,
        date: widget.expense!.date,
      );
      await DatabaseHelper.instance.updateExpense(updatedExpense);
    }

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _itemController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.expense == null ? 'Add Expense' : 'Edit Expense'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _itemController,
                decoration: InputDecoration(labelText: 'Item'),
              ),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Price (PLN)'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveExpense,
                child: Text(
                    widget.expense == null ? 'Save Expense' : 'Update Expense'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
