import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../utils/app_router.dart';

class ExpensesListScreen extends StatefulWidget {
  const ExpensesListScreen({Key? key}) : super(key: key);

  @override
  State<ExpensesListScreen> createState() => _ExpensesListScreenState();
}

class _ExpensesListScreenState extends State<ExpensesListScreen> {
  final TextEditingController _searchController = TextEditingController();
  
  // Mock data for demonstration
  final List<Map<String, dynamic>> _mockExpenses = [
    {
      'id': 1,
      'category': 'Office Supplies',
      'bill_number': 'INV-001',
      'amount': 250.00,
      'bill_date': '2025-08-02',
      'remarks': 'Printer paper and stationery',
      'has_attachment': true,
    },
    {
      'id': 2,
      'category': 'Utilities',
      'bill_number': 'UTIL-002',
      'amount': 180.00,
      'bill_date': '2025-08-01',
      'remarks': 'Monthly electricity bill',
      'has_attachment': false,
    },
    {
      'id': 3,
      'category': 'Travel',
      'bill_number': 'TRV-003',
      'amount': 120.50,
      'bill_date': '2025-07-31',
      'remarks': 'Taxi fare for client meeting',
      'has_attachment': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSearchAndFilter(),
        Expanded(
          child: _buildExpensesList(),
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
                    hintText: 'Search expenses...',
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
          _buildFilterChip('Office Supplies', false),
          _buildFilterChip('Utilities', false),
          _buildFilterChip('Travel', false),
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

  Widget _buildExpensesList() {
    return RefreshIndicator(
      onRefresh: _refreshExpenses,
      child: ListView.builder(
        padding: const EdgeInsets.all(Constants.defaultPadding),
        itemCount: _mockExpenses.length,
        itemBuilder: (context, index) {
          final expense = _mockExpenses[index];
          return _buildExpenseCard(expense);
        },
      ),
    );
  }

  Widget _buildExpenseCard(Map<String, dynamic> expense) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => AppRouter.goToExpenseDetail(context, expense['id']),
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
                      color: const Color(Constants.errorColor).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.receipt_long,
                      color: Color(Constants.errorColor),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          expense['category'],
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          expense['bill_number'] ?? 'No Bill Number',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'RM ${expense['amount'].toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(Constants.errorColor),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                expense['remarks'],
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
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
                    expense['bill_date'],
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  if (expense['has_attachment']) ...[
                    const SizedBox(width: 12),
                    Icon(
                      Icons.attachment,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Attachment',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _refreshExpenses() async {
    // TODO: Implement refresh logic
    await Future.delayed(const Duration(seconds: 1));
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Expenses'),
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
