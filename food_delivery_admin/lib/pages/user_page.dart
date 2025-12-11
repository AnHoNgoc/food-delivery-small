import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../services/user_service.dart';
import '../utils/confirmation_dialog.dart';
import '../utils/show_snackbar.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final UserService _userService = UserService();
  List<Map<String, dynamic>> _users = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    setState(() => _isLoading = true);
    _users = await _userService.getUserList();
    setState(() => _isLoading = false);
  }

  Future<void> _deleteUser(String userId) async {
    final confirm = await showConfirmationDialog(
      context,
      title: 'Confirm Deletion',
      message: 'Are you sure you want to delete this user?',
      confirmText: 'Yes',
      cancelText: 'Cancel',
    );
    if (confirm == true) {
      bool success = await _userService.deleteUserById(userId);
      if (success) {
        showAppSnackBar(context, "User deleted successfully", Colors.green);
        _fetchUsers(); // load lại danh sách
      } else {
        showAppSnackBar(context, "Failed to delete user", Colors.redAccent);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'User Management',
          style: TextStyle(fontSize: 20.sp), // scale font
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        padding: EdgeInsets.all(12.w), // scale padding
        itemCount: _users.length,
        itemBuilder: (context, index) {
          final user = _users[index];

          return Card(
            elevation: 2,
            margin: EdgeInsets.symmetric(vertical: 6.h), // scale margin
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r), // scale border radius
            ),
            child: ListTile(
              leading: CircleAvatar(
                radius: 20.r, // scale radius
                backgroundColor: Colors.blue.shade200,
                child: Text(
                  '${index + 1}',
                  style: TextStyle(fontSize: 16.sp), // scale font
                ),
              ),
              title: Text(
                user['email'] ?? '',
                style: TextStyle(fontSize: 16.sp),
              ),
              subtitle: Text(
                'Role: ${user['role'] ?? ''}',
                style: TextStyle(fontSize: 14.sp),
              ),
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.red, size: 24.r),
                tooltip: 'Delete user',
                onPressed: () => _deleteUser(user['id']),
              ),
            ),
          );
        },
      ),
    );
  }
}