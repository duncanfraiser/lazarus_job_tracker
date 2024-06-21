import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lazarus_job_tracker/src/services/auth_service.dart';

class UserListView extends StatelessWidget {
  const UserListView({Key? key}) : super(key: key);

  Future<List<Map<String, dynamic>>> _getUsers() async {
    final QuerySnapshot result = await FirebaseFirestore.instance.collection('employees').get();
    return result.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _getUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No users found'));
          }

          final users = snapshot.data!;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text('${user['firstName']} ${user['lastName']}'),
                  subtitle: Text(user['email']),
                  trailing: Text(user['company']),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
