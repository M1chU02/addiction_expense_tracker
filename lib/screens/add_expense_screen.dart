import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/expense.dart';
import '../models/template_item.dart';
import 'template_items_screen.dart';

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
  late TextEditingController _quantityController;
  List<TemplateItem> _templateItems = [];
  TemplateItem? _selectedTemplate;

  @override
  void initState() {
    super.initState();
    _itemController = TextEditingController(text: widget.expense?.item ?? '');
    _priceController = TextEditingController(
        text: widget.expense != null ? widget.expense!.price.toString() : '');
    _quantityController = TextEditingController(text: '1');
    _loadTemplateItems();
  }

  Future<void> _loadTemplateItems() async {
    final items = await DatabaseHelper.instance.getTemplateItems();
    setState(() {
      _templateItems = items;
    });
  }

  void _onTemplateSelected(TemplateItem? item) {
    setState(() {
      _selectedTemplate = item;
      if (item != null) {
        _itemController.text = item.name;
        _priceController.text = item.price.toString();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.expense == null ? 'Add Expense' : 'Edit Expense'),
        actions: [
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TemplateItemsScreen()),
              ).then((_) => _loadTemplateItems());
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<TemplateItem>(
                value: _selectedTemplate,
                items: _templateItems
                    .map((item) => DropdownMenuItem(
                          value: item,
                          child: Text('${item.name} - ${item.price} PLN'),
                        ))
                    .toList(),
                onChanged: _onTemplateSelected,
                decoration: InputDecoration(labelText: 'Select Template Item'),
              ),
              TextFormField(
                controller: _itemController,
                decoration: InputDecoration(labelText: 'Item'),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter an item' : null,
              ),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter a price' : null,
              ),
              TextFormField(
                controller: _quantityController,
                decoration: InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter a quantity' : null,
              ),
              ElevatedButton(
                onPressed: _saveExpense,
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveExpense() async {
    if (_formKey.currentState!.validate()) {
      final item = _itemController.text;
      final price = double.parse(_priceController.text);
      final quantity = int.parse(_quantityController.text);
      final totalPrice = price * quantity;

      final expense = Expense(
        id: widget.expense?.id,
        item: item,
        price: totalPrice,
        date: DateTime.now().toIso8601String(),
      );

      if (widget.expense == null) {
        await DatabaseHelper.instance.insertExpense(expense);
      } else {
        await DatabaseHelper.instance.updateExpense(expense);
      }

      Navigator.pop(context);
    }
  }
}
