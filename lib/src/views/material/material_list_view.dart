// import 'package:flutter/material.dart';
// import 'package:lazarus_job_tracker/src/models/material_model.dart';
// import 'package:lazarus_job_tracker/src/services/material_service.dart';
// import 'package:provider/provider.dart';


// class MaterialListScreen extends StatelessWidget {
//   const MaterialListScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final materialService = Provider.of<MaterialService>(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Materials'),
//       ),
//       body: StreamBuilder<List<MaterialModel>>(
//         stream: materialService.getMaterials(),
//         builder: (context, snapshot) {
//           if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           final materials = snapshot.data ?? [];

//           return ListView.builder(
//             itemCount: materials.length,
//             itemBuilder: (context, index) {
//               final material = materials[index];
//               return ListTile(
//                 title: Text(material.name),
//                 subtitle: Text(material.description),
//                 trailing: Text('\$${material.price}'),
//                 onLongPress: () => _deleteMaterial(context, material.id),
//                 onTap: () => _showEditMaterialDialog(context, material),
//               );
//             },
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => _showAddMaterialDialog(context),
//         child: const Icon(Icons.add),
//       ),
//     );
//   }

//   void _showAddMaterialDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => AddEditMaterialDialog(),
//     );
//   }

//   void _showEditMaterialDialog(BuildContext context, Material material) {
//     showDialog(
//       context: context,
//       builder: (context) => AddEditMaterialDialog(material: material),
//     );
//   }

//   void _deleteMaterial(BuildContext context, String id) {
//     Provider.of<FirestoreService>(context, listen: false).deleteMaterial(id);
//   }
// }
