import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/expense.dart';
import 'add_expense_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Expense> _expenses = [];

  @override
  void initState() {
    super.initState();
    _fetchExpenses();
  }

  Future<void> _fetchExpenses() async {
    final expenses = await DatabaseHelper.instance.getExpenses();
    setState(() {
      _expenses = expenses;
    });
  }

  double _calculateTotal(List<Expense> expenses) {
    return expenses.fold(0, (sum, expense) => sum + expense.price);
  }

  Future<void> _editExpense(Expense expense) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddExpenseScreen(expense: expense),
      ),
    );
    _fetchExpenses(); // Refresh list after editing
  }

  Future<void> _deleteExpense(int id) async {
    // Show confirmation dialog
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Expense'),
        content: Text('Are you sure you want to delete this expense?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    // If user confirms deletion
    if (shouldDelete ?? false) {
      await DatabaseHelper.instance.deleteExpense(id);
      _fetchExpenses(); // Refresh list after deletion
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Addiction Expense Tracker'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _fetchExpenses,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _expenses.length,
              itemBuilder: (context, index) {
                final expense = _expenses[index];
                return ListTile(
                  title: Text(expense.item),
                  subtitle: Text('${expense.date.toLocal()}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('${expense.price.toStringAsFixed(2)} PLN'),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteExpense(expense.id!),
                      ),
                    ],
                  ),
                  onTap: () => _editExpense(expense),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Total Monthly: ${_calculateTotal(_expenses).toStringAsFixed(2)} PLN',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddExpenseScreen()),
          );
          _fetchExpenses(); // Refresh list after adding
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
