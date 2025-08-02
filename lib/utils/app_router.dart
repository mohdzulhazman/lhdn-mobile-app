import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/expenses/expenses_list_screen.dart';
import '../screens/expenses/expense_detail_screen.dart';
// import '../screens/expenses/add_expense_screen.dart';
// import '../screens/expenses/edit_expense_screen.dart';
import '../screens/sales/sales_list_screen.dart';
import '../screens/sales/sale_detail_screen.dart';
// import '../screens/direct_sales/add_sale_screen.dart';
// import '../screens/direct_sales/edit_sale_screen.dart';
import '../services/storage_service.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: _getInitialRoute(),
    routes: [
      // Auth Routes
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      
      // Main App Routes
      GoRoute(
        path: '/',
        name: 'dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
      
      // Expenses Routes
      GoRoute(
        path: '/expenses',
        name: 'expenses',
        builder: (context, state) => const ExpensesListScreen(),
      ),
      GoRoute(
        path: '/expenses/add',
        name: 'add-expense',
        builder: (context, state) => const AddExpenseScreen(),
      ),
      GoRoute(
        path: '/expenses/:id',
        name: 'expense-detail',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return ExpenseDetailScreen(expenseId: id);
        },
      ),
      GoRoute(
        path: '/expenses/:id/edit',
        name: 'edit-expense',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return EditExpenseScreen(expenseId: id);
        },
      ),
      
      // Direct Sales Routes
      GoRoute(
        path: '/sales',
        name: 'sales',
        builder: (context, state) => const SalesListScreen(),
      ),
      GoRoute(
        path: '/sales/add',
        name: 'add-sale',
        builder: (context, state) => const AddSaleScreen(),
      ),
      GoRoute(
        path: '/sales/:id',
        name: 'sale-detail',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return SaleDetailScreen(saleId: id);
        },
      ),
      GoRoute(
        path: '/sales/:id/edit',
        name: 'edit-sale',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return EditSaleScreen(saleId: id);
        },
      ),
    ],
    redirect: (context, state) {
      final isLoggedIn = StorageService.isLoggedIn();
      final isAuthRoute = state.location.startsWith('/login') || state.location.startsWith('/register');
      
      // If user is not logged in and trying to access protected routes
      if (!isLoggedIn && !isAuthRoute) {
        return '/login';
      }
      
      // If user is logged in and trying to access auth routes
      if (isLoggedIn && isAuthRoute) {
        return '/';
      }
      
      return null;
    },
  );
  
  static String _getInitialRoute() {
    final isLoggedIn = StorageService.isLoggedIn();
    return isLoggedIn ? '/' : '/login';
  }
  
  // Navigation Helper Methods
  static void goToLogin(BuildContext context) {
    context.go('/login');
  }
  
  static void goToRegister(BuildContext context) {
    context.go('/register');
  }
  
  static void goToDashboard(BuildContext context) {
    context.go('/');
  }
  
  static void goToExpenses(BuildContext context) {
    context.go('/expenses');
  }
  
  static void goToAddExpense(BuildContext context) {
    context.go('/expenses/add');
  }
  
  static void goToExpenseDetail(BuildContext context, int id) {
    context.go('/expenses/$id');
  }
  
  static void goToEditExpense(BuildContext context, int id) {
    context.go('/expenses/$id/edit');
  }
  
  static void goToSales(BuildContext context) {
    context.go('/sales');
  }
  
  static void goToAddSale(BuildContext context) {
    context.go('/sales/add');
  }
  
  static void goToSaleDetail(BuildContext context, int id) {
    context.go('/sales/$id');
  }
  
  static void goToEditSale(BuildContext context, int id) {
    context.go('/sales/$id/edit');
  }
  
  // Navigation with replacement
  static void replaceWithLogin(BuildContext context) {
    context.pushReplacement('/login');
  }
  
  static void replaceWithDashboard(BuildContext context) {
    context.pushReplacement('/');
  }
  
  // Pop methods
  static void pop(BuildContext context) {
    context.pop();
  }
  
  static bool canPop(BuildContext context) {
    return context.canPop();
  }
}
