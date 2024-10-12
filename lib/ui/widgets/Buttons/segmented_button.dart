// import 'package:flutter/material.dart';


// class SegmentedWidget extends StatelessWidget {
//   const SegmentedWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//           width: double.infinity,
//           child: SegmentedButton<String>(
//             segments: const <ButtonSegment<String>>[
//               ButtonSegment<String>(
//                 label: Text("Email"),
//                 value: 'email',
//                 icon: Icon(Icons.email_outlined),
//               ),
//               ButtonSegment<String>(
//                 label: Text("Phone"),
//                 value: 'phone',
//                 icon: Icon(Icons.phone_outlined),
//               ),
//             ],
//             selected: {
//               selectedSelection == Selection.email ? 'email' : 'phone'
//             },
//             onSelectionChanged: (newSelection) {
//               if (newSelection.contains('email')) {
//                 context.read<SelectionCubit>().selectEmail();
//               } else {
//                 context.read<SelectionCubit>().selectPhone();
//               }
//             },
//             style: ButtonStyle(
//               backgroundColor: WidgetStateProperty.resolveWith<Color?>(
//                 (Set<WidgetState> states) {
//                   if (states.contains(WidgetState.selected)) {
//                     return AppColors.primaryColor;
//                   }
//                   return AppColors.fieldsColor;
//                 },
//               ),
//               foregroundColor: WidgetStateProperty.resolveWith<Color?>(
//                 (Set<WidgetState> states) {
//                   if (states.contains(WidgetState.selected)) {
//                     return Colors.white;
//                   }
//                   return const Color(0xFF6E6E6E);
//                 },
//               ),
//               shape: WidgetStateProperty.all<RoundedRectangleBorder>(
//                 RoundedRectangleBorder(
//                   side: const BorderSide(
//                     color: AppColors.primaryColor,
//                     width: 1,
//                   ),
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//               ),
//               padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
//                 const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
//               ),
//               minimumSize: WidgetStateProperty.all<Size>(
//                 const Size(150, 40),
//               ),
//             ),
//           ),
//         );
//   }
// }
