import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../utils/app_router.dart';

class SalesListScreen extends StatefulWidget {
  const SalesListScreen({Key? key}) : super(key: key);

  @override
  State<SalesListScreen> createState() => _SalesListScreenState();
}

class _SalesListScreenState extends State<SalesListScreen> {
  final TextEditingController _searchController = TextEditingController();
  
  // Mock data for demonstration
  final List<Map<String, dynamic>> _mockSales = [
    {
      'id': 1,
      'product': 'Software License',
      'quantity': 5,
      'price': 2500.00,
      'total': 12500.00,
      'sale_date': '2025-08-02',
      'customer': 'ABC Technology Sdn Bhd',
      'invoice_number': 'INV-2025-001',
    },
    {
      'id': 2,
      'product': 'Consulting Services',
      'quantity': 10,
      'price': 150.00,
      'total': 1500.00,
      'sale_date': '2025-08-01',
      'customer': 'XYZ Corporation',
      'invoice_number': 'INV-2025-002',
    },
    {
      'id': 3,
      'product': 'Website Development',
      'quantity': 1,
      'price': 8500.00,
      'total': 8500.00,
      'sale_date': '2025-07-31',
      'customer': 'Digital Solutions Ltd',
      'invoice_number': 'INV-2025-003',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSearchAndFilter(),
        Expanded(
          child: _buildSalesList(),
        ),
      ],
    );
  }

  Widget _buildSearchAndFilter() {
    return Container(
      padding: const EdgeInsets.all(Constants.defaultPadding),
      color: Colors.grey[50],
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search sales...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(Constants.buttonBorderRadius),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(Constants.buttonBorderRadius),
                ),
                child: IconButton(
                  onPressed: _showFilterDialog,
                  icon: const Icon(Icons.filter_list),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildQuickFilters(),
        ],
      ),
    );
  }

  Widget _buildQuickFilters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildFilterChip('All', true),
          _buildFilterChip('This Month', false),
          _buildFilterChip('Software', false),
          _buildFilterChip('Services', false),
          _buildFilterChip('High Value', false),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          // TODO: Handle filter selection
        },
        selectedColor: const Color(Constants.primaryColor).withOpacity(0.2),
        checkmarkColor: const Color(Constants.primaryColor),
      ),
    );
  }

  Widget _buildSalesList() {
    return RefreshIndicator(
      onRefresh: _refreshSales,
      child: ListView.builder(
        padding: const EdgeInsets.all(Constants.defaultPadding),
        itemCount: _mockSales.length,
        itemBuilder: (context, index) {
          final sale = _mockSales[index];
          return _buildSaleCard(sale);
        },
      ),
    );
  }

  Widget _buildSaleCard(Map<String, dynamic> sale) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => AppRouter.goToSaleDetail(context, sale['id']),
        borderRadius: BorderRadius.circular(Constants.cardBorderRadius),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(Constants.successColor).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.shopping_cart,
                      color: Color(Constants.successColor),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          sale['product'],
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          sale['invoice_number'],
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'RM ${sale['total'].toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(Constants.successColor),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                sale['customer'],
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    sale['sale_date'],
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.inventory,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Qty: ${sale['quantity']}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.attach_money,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'RM ${sale['price'].toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _refreshSales() async {
    // TODO: Implement refresh logic
    await Future.delayed(const Duration(seconds: 1));
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Sales'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Filter options will be implemented here'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }
}
