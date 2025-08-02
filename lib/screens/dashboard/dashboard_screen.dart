import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../utils/app_router.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_button.dart';
import '../expenses/expenses_list_screen.dart';
import '../sales/sales_list_screen.dart';
import 'dashboard_home_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  
  late final List<Widget> _screens;
  late final List<BottomNavigationBarItem> _bottomNavItems;

  @override
  void initState() {
    super.initState();
    
    _screens = [
      const DashboardHomeScreen(),
      const ExpensesListScreen(),
      const SalesListScreen(),
    ];
    
    _bottomNavItems = const [
      BottomNavigationBarItem(
        icon: Icon(Icons.dashboard_outlined),
        activeIcon: Icon(Icons.dashboard),
        label: 'Dashboard',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.receipt_long_outlined),
        activeIcon: Icon(Icons.receipt_long),
        label: 'Expenses',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.shopping_cart_outlined),
        activeIcon: Icon(Icons.shopping_cart),
        label: 'Sales',
      ),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _handleLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          CustomButton(
            text: 'Logout',
            onPressed: () => Navigator.of(context).pop(true),
            backgroundColor: Theme.of(context).colorScheme.error,
            width: 80,
            height: 36,
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final authService = context.read<AuthService>();
      await authService.logout();
      if (mounted) {
        AppRouter.replaceWithLogin(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getAppBarTitle()),
        automaticallyImplyLeading: false,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'profile':
                  // TODO: Navigate to profile screen
                  break;
                case 'settings':
                  // TODO: Navigate to settings screen
                  break;
                case 'logout':
                  _handleLogout();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'profile',
                child: ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Profile'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem(
                value: 'settings',
                child: ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Settings'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'logout',
                child: ListTile(
                  leading: Icon(Icons.exit_to_app, color: Colors.red),
                  title: Text('Logout', style: TextStyle(color: Colors.red)),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              child: Consumer<AuthService>(
                builder: (context, authService, child) {
                  final user = authService.currentUser;
                  return CircleAvatar(
                    radius: 18,
                    backgroundColor: const Color(Constants.primaryColor),
                    child: Text(
                      user?.name.substring(0, 1).toUpperCase() ?? 'U',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: _bottomNavItems,
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  String _getAppBarTitle() {
    switch (_selectedIndex) {
      case 0:
        return 'Dashboard';
      case 1:
        return 'Expenses';
      case 2:
        return 'Direct Sales';
      default:
        return Constants.appName;
    }
  }

  Widget? _buildFloatingActionButton() {
    if (_selectedIndex == 0) return null; // No FAB for dashboard
    
    return FloatingActionButton(
      onPressed: () {
        if (_selectedIndex == 1) {
          // TODO: Navigate to add expense screen
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Add expense feature coming soon')),
          );
        } else if (_selectedIndex == 2) {
          // TODO: Navigate to add sale screen
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Add sale feature coming soon')),
          );
        }
      },
      child: const Icon(Icons.add),
    );
  }
}
