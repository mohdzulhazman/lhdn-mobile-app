import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/loading_overlay.dart';

class ExpenseDetailScreen extends StatefulWidget {
  final int expenseId;
  
  const ExpenseDetailScreen({
    Key? key,
    required this.expenseId,
  }) : super(key: key);

  @override
  State<ExpenseDetailScreen> createState() => _ExpenseDetailScreenState();
}

class _ExpenseDetailScreenState extends State<ExpenseDetailScreen> {
  bool _isLoading = false;
  
  // Mock data for demonstration
  late Map<String, dynamic> _expense;

  @override
  void initState() {
    super.initState();
    _loadExpenseData();
  }

  void _loadExpenseData() {
    setState(() {
      _isLoading = true;
    });

    // Mock data based on expense ID
    _expense = {
      'id': widget.expenseId,
      'category': 'Office Supplies',
      'bill_number': 'INV-001',
      'amount': 250.00,
      'bill_date': '2025-08-02',
      'remarks': 'Printer paper and stationery for the office. This includes various office supplies needed for daily operations.',
      'has_attachment': true,
      'attachment_url': 'https://example.com/receipt.pdf',
      'created_at': '2025-08-02 10:30:00',
      'updated_at': '2025-08-02 10:30:00',
    };

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Details'),
        actions: [
          IconButton(
            onPressed: _editExpense,
            icon: const Icon(Icons.edit),
          ),
          PopupMenuButton<String>(
            onSelected: _handleMenuAction,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'duplicate',
                child: Text('Duplicate'),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Text('Delete'),
              ),
            ],
          ),
        ],
      ),
      body: LoadingOverlay(
        isLoading: _isLoading,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(Constants.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildExpenseCard(),
              const SizedBox(height: 24),
              if (_expense['has_attachment']) _buildAttachmentSection(),
              const SizedBox(height: 24),
              _buildActionsSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpenseCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(Constants.errorColor).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Icon(
                    Icons.receipt_long,
                    color: Color(Constants.errorColor),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _expense['category'],
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Bill No: ${_expense['bill_number']}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'RM ${_expense['amount'].toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color(Constants.errorColor),
              ),
            ),
            const SizedBox(height: 16),
            _buildDetailRow('Date:', _expense['bill_date']),
            const SizedBox(height: 12),
            _buildDetailRow('Remarks:', _expense['remarks']),
            const SizedBox(height: 12),
            _buildDetailRow('Created:', _expense['created_at']),
            if (_expense['updated_at'] != _expense['created_at']) ...[
              const SizedBox(height: 12),
              _buildDetailRow('Updated:', _expense['updated_at']),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildAttachmentSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Attachment',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: _viewAttachment,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.picture_as_pdf,
                      color: Colors.red[600],
                      size: 32,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Receipt.pdf',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            'Tap to view',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionsSection() {
    return Column(
      children: [
        CustomButton(
          text: 'Edit Expense',
          onPressed: _editExpense,
          icon: Icons.edit,
        ),
        const SizedBox(height: 12),
        CustomButton(
          text: 'Duplicate Expense',
          onPressed: _duplicateExpense,
          style: CustomButtonStyle.outlined,
          icon: Icons.copy,
        ),
        const SizedBox(height: 12),
        CustomButton(
          text: 'Delete Expense',
          onPressed: _deleteExpense,
          style: CustomButtonStyle.outlined,
          icon: Icons.delete,
          backgroundColor: const Color(Constants.errorColor),
        ),
      ],
    );
  }

  void _editExpense() {
    // TODO: Navigate to edit expense screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Edit expense feature coming soon')),
    );
  }

  void _duplicateExpense() {
    // TODO: Implement duplicate logic
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Duplicate expense feature coming soon')),
    );
  }

  void _deleteExpense() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Expense'),
        content: const Text('Are you sure you want to delete this expense? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement delete logic
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Expense deleted successfully')),
              );
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              foregroundColor: const Color(Constants.errorColor),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _viewAttachment() {
    // TODO: Implement attachment viewer
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Attachment viewer coming soon')),
    );
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'duplicate':
        _duplicateExpense();
        break;
      case 'delete':
        _deleteExpense();
        break;
    }
  }
}
