// import 'package:flutter/material.dart';
// import 'package:whatsapp/whatsapp.dart';

// class Home extends StatefulWidget {
//   const Home({super.key});

//   @override
//   State<Home> createState() => _HomeState();
// }

// class _HomeState extends State<Home> {
//   WhatsApp whatsapp = WhatsApp();
//   int phoneNumber = 6384886472;
//   @override
//   void initState() {
//     whatsapp.setup(
//       accessToken: "YOUR_ACCESS_TOKEN_HERE",
//       fromNumberId: 000000000000000,
//     );
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: ListView(
//         children: [
//           TextButton(
//             onPressed: () async {
//               print(await whatsapp.messagesText(
//                 to: phoneNumber,
//                 message: "Hello Flutter",
//                 previewUrl: true,
//               ));
//             },
//             child: const Text("Send Message"),
//           ),
//         ],
//       ),
//     );
//   }
// }
