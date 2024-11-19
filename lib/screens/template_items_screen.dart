import 'package:flutter/material.dart';
import '../models/template_item.dart';
import '../db/database_helper.dart';

class TemplateItemsScreen extends StatefulWidget {
  @override
  _TemplateItemsScreenState createState() => _TemplateItemsScreenState();
}

class _TemplateItemsScreenState extends State<TemplateItemsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  List<TemplateItem> _templateItems = [];

  @override
  void initState() {
    super.initState();
    _loadTemplateItems();
  }

  Future<void> _loadTemplateItems() async {
    final items = await DatabaseHelper.instance.getTemplateItems();
    setState(() {
      _templateItems = items;
    });
  }

  Future<void> _addTemplateItem() async {
    if (_formKey.currentState!.validate()) {
      final item = TemplateItem(
        name: _nameController.text,
        price: double.parse(_priceController.text),
      );
      await DatabaseHelper.instance.insertTemplateItem(item);
      _nameController.clear();
      _priceController.clear();
      _loadTemplateItems();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Template Items')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Item Name'),
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Please enter a name' : null,
                  ),
                  TextFormField(
                    controller: _priceController,
                    decoration: InputDecoration(labelText: 'Price'),
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Please enter a price' : null,
                  ),
                  ElevatedButton(
                    onPressed: _addTemplateItem,
                    child: Text('Add Template Item'),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _templateItems.length,
              itemBuilder: (context, index) {
                final item = _templateItems[index];
                return ListTile(
                  title: Text(item.name),
                  subtitle: Text('${item.price.toStringAsFixed(2)} PLN'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () async {
                      await DatabaseHelper.instance
                          .deleteTemplateItem(item.id!);
                      _loadTemplateItems();
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
