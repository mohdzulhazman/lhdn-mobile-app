import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/loading_overlay.dart';

class SaleDetailScreen extends StatefulWidget {
  final int saleId;
  
  const SaleDetailScreen({
    Key? key,
    required this.saleId,
  }) : super(key: key);

  @override
  State<SaleDetailScreen> createState() => _SaleDetailScreenState();
}

class _SaleDetailScreenState extends State<SaleDetailScreen> {
  bool _isLoading = false;
  
  // Mock data for demonstration
  late Map<String, dynamic> _sale;

  @override
  void initState() {
    super.initState();
    _loadSaleData();
  }

  void _loadSaleData() {
    setState(() {
      _isLoading = true;
    });

    // Mock data based on sale ID
    _sale = {
      'id': widget.saleId,
      'product': 'Software License',
      'quantity': 5,
      'price': 2500.00,
      'total': 12500.00,
      'sale_date': '2025-08-02',
      'customer': 'ABC Technology Sdn Bhd',
      'invoice_number': 'INV-2025-001',
      'description': 'Annual software license for business management system including support and updates for 12 months.',
      'created_at': '2025-08-02 14:30:00',
      'updated_at': '2025-08-02 14:30:00',
    };

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sale Details'),
        actions: [
          IconButton(
            onPressed: _editSale,
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
                value: 'invoice',
                child: Text('Generate Invoice'),
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
              _buildSaleCard(),
              const SizedBox(height: 24),
              _buildCalculationCard(),
              const SizedBox(height: 24),
              _buildActionsSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSaleCard() {
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
                    color: const Color(Constants.successColor).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Icon(
                    Icons.shopping_cart,
                    color: Color(Constants.successColor),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _sale['product'],
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Invoice: ${_sale['invoice_number']}',
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
              'RM ${_sale['total'].toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color(Constants.successColor),
              ),
            ),
            const SizedBox(height: 16),
            _buildDetailRow('Customer:', _sale['customer']),
            const SizedBox(height: 12),
            _buildDetailRow('Sale Date:', _sale['sale_date']),
            const SizedBox(height: 12),
            _buildDetailRow('Description:', _sale['description']),
            const SizedBox(height: 12),
            _buildDetailRow('Created:', _sale['created_at']),
            if (_sale['updated_at'] != _sale['created_at']) ...[
              const SizedBox(height: 12),
              _buildDetailRow('Updated:', _sale['updated_at']),
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

  Widget _buildCalculationCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Calculation Breakdown',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildCalculationRow('Quantity:', '${_sale['quantity']} units'),
            const SizedBox(height: 8),
            _buildCalculationRow('Unit Price:', 'RM ${_sale['price'].toStringAsFixed(2)}'),
            const SizedBox(height: 8),
            const Divider(),
            const SizedBox(height: 8),
            _buildCalculationRow(
              'Subtotal:',
              'RM ${(_sale['quantity'] * _sale['price']).toStringAsFixed(2)}',
              isTotal: true,
            ),
            const SizedBox(height: 8),
            _buildCalculationRow('Tax (0%):', 'RM 0.00'),
            const SizedBox(height: 8),
            const Divider(thickness: 2),
            const SizedBox(height: 8),
            _buildCalculationRow(
              'Total Amount:',
              'RM ${_sale['total'].toStringAsFixed(2)}',
              isTotal: true,
              isFinal: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalculationRow(String label, String value, {bool isTotal = false, bool isFinal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            fontSize: isFinal ? 16 : null,
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            fontSize: isFinal ? 16 : null,
            color: isFinal ? const Color(Constants.successColor) : null,
          ),
        ),
      ],
    );
  }

  Widget _buildActionsSection() {
    return Column(
      children: [
        CustomButton(
          text: 'Edit Sale',
          onPressed: _editSale,
          icon: Icons.edit,
        ),
        const SizedBox(height: 12),
        CustomButton(
          text: 'Generate Invoice',
          onPressed: _generateInvoice,
          style: CustomButtonStyle.outlined,
          icon: Icons.description,
        ),
        const SizedBox(height: 12),
        CustomButton(
          text: 'Duplicate Sale',
          onPressed: _duplicateSale,
          style: CustomButtonStyle.outlined,
          icon: Icons.copy,
        ),
        const SizedBox(height: 12),
        CustomButton(
          text: 'Delete Sale',
          onPressed: _deleteSale,
          style: CustomButtonStyle.outlined,
          icon: Icons.delete,
          backgroundColor: const Color(Constants.errorColor),
        ),
      ],
    );
  }

  void _editSale() {
    // TODO: Navigate to edit sale screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Edit sale feature coming soon')),
    );
  }

  void _generateInvoice() {
    // TODO: Implement invoice generation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Invoice generation feature coming soon')),
    );
  }

  void _duplicateSale() {
    // TODO: Implement duplicate logic
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Duplicate sale feature coming soon')),
    );
  }

  void _deleteSale() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Sale'),
        content: const Text('Are you sure you want to delete this sale? This action cannot be undone.'),
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
                const SnackBar(content: Text('Sale deleted successfully')),
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

  void _handleMenuAction(String action) {
    switch (action) {
      case 'duplicate':
        _duplicateSale();
        break;
      case 'invoice':
        _generateInvoice();
        break;
      case 'delete':
        _deleteSale();
        break;
    }
  }
}
