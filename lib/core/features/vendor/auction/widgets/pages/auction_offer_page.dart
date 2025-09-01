// import 'package:ecarrgo/core/features/customer/home/send_package_flow/data/model/shipment_model.dart';
// import 'package:ecarrgo/core/features/vendor/auction/data/models/details/auction_detail.dart';
// import 'package:ecarrgo/core/features/vendor/auction/widgets/pages/auction_confirmation_page.dart';
// import 'package:ecarrgo/core/features/vendor/auction/widgets/service/offer_auction_service.dart';
// import 'package:ecarrgo/core/features/vendor/auction/widgets/widgets/reusable_button_action.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';

// class OfferPage extends StatefulWidget {
//   const OfferPage({super.key});

//   @override
//   State<OfferPage> createState() => _OfferPageState();
// }

// class _OfferPageState extends State<OfferPage> {
//   int currentStep = 1;
//   int? selectedIndex;
//   late final AuctionDetail detail;

//   @override
//   void initState() {
//     super.initState();
//     final shipment = Shipment;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text("Buat Penawaran",
//             style: TextStyle(
//                 fontSize: 16, fontVariations: [FontVariation.weight(700)])),
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black,
//         elevation: 0,
//         automaticallyImplyLeading: false,
//         leading: IconButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             icon: Icon(Icons.arrow_back_ios_new, size: 20)),
//       ),
//       body: Expanded(
//         child:
//           Column(
//             children: [
//               // Step Indicator
//               Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Row(
//                   children: [
//                     _buildStepCircle("1", isActive: currentStep >= 1),
//                     Expanded(
//                       child: Divider(
//                         color: currentStep >= 2
//                             ? Color(0xFF01518D)
//                             : Colors.grey.shade300,
//                         thickness: 2,
//                       ),
//                     ),
//                     _buildStepCircle("2", isActive: currentStep >= 2),
//                   ],
//                 ),
//               ),
          
//               // Info Box (Kapasitas dan Volume)
//               Container(
//                 margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Color(0xFFF6F8F9),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: const [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         Text("Kapasitas:",
//                             style: TextStyle(
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.normal,
//                                 color: Colors.black)),
//                         Text("Volume (P x L x T):",
//                             style: TextStyle(
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.normal,
//                                 color: Colors.black)),
//                       ],
//                     ),
//                     SizedBox(height: 8),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         Text("1.2 Ton",
//                             style: TextStyle(
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.bold,
//                                 color: Color(0xFF01518D))),
//                         Text("400 cm x 400 cm x 300 cm",
//                             style: TextStyle(
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.bold,
//                                 color: Color(0xFF01518D))),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
          
//               // List Driver
//               Expanded(
//                 child: FutureBuilder<List<Shipment>>(
//                   future: shipment,
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return const Center(child: CircularProgressIndicator());
//                     }
//                     if (snapshot.hasError) {
//                       return const Center(child: Text("Gagal memuat data"));
//                     }
          
//                     final data = snapshot.data ?? [];
//                     return ListView.builder(
//                       padding: const EdgeInsets.all(16),
//                       itemCount: data.length,
//                       itemBuilder: (context, index) {
//                         final offer = data[index];
//                         return Container(
//                           margin: const EdgeInsets.only(bottom: 12),
//                           decoration: BoxDecoration(
//                             color: Color(0xFFF6F8F9),
//                             borderRadius: BorderRadius.circular(12),
//                             border: Border.all(
//                               color: selectedIndex == index
//                                   ? Color(0xFF01518D)
//                                   : Color(0xFFF6F8F9),
//                               width: 2,
//                             ),
//                           ),
//                           child: RadioListTile<int>(
//                             value: index,
//                             groupValue: selectedIndex,
//                             activeColor: Color(0xFF01518D),
//                             onChanged: (val) {
//                               setState(() => selectedIndex = val);
//                             },
//                             title: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               crossAxisAlignment: CrossAxisAlignment.end,
//                               children: [
//                                 // Icon Box Car dengan background rounded rectangle
//                                 Container(
//                                   padding: const EdgeInsets.symmetric(
//                                       vertical: 8,
//                                       horizontal: 3), // kasih ruang dalam
//                                   decoration: BoxDecoration(
//                                     gradient: const LinearGradient(
//                                       colors: [
//                                         Color(0xFF9BAAB7),
//                                         Color(0XFFE8EEF4)
//                                       ],
//                                       begin: Alignment.topLeft,
//                                       end: Alignment.bottomRight,
//                                     ),
//                                     borderRadius: BorderRadius.circular(
//                                         8), // rounded rectangle
//                                     boxShadow: [
//                                       BoxShadow(
//                                         // ignore: deprecated_member_use
//                                         color: Colors.black.withOpacity(0.05),
//                                         blurRadius: 4,
//                                         offset: const Offset(0, 2),
//                                       ),
//                                     ],
//                                   ),
//                                   child: SvgPicture.asset(
//                                     'assets/images/vendor/box_car.svg',
//                                     width: 36,
//                                     height: 36,
//                                   ),
//                                 ),
//                                 const SizedBox(width: 12),
          
//                                 // Plat Nomor + Nama Driver
//                                 Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     Text(
//                                       "${offer.userId}",
//                                       style: const TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 16,
//                                       ),
//                                     ),
//                                     const SizedBox(height: 4),
//                                     Text(
//                                       offer.userId,
//                                       style: const TextStyle(
//                                         color: Color(0xFFA68B13),
//                                         fontSize: 12,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
          
//                             subtitle: Column(
//                               children: [
//                                 const Divider(thickness: 0.7),
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   children: [
//                                     Row(
//                                       children: [
//                                         const Divider(),
//                                         Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.start,
//                                           children: [
//                                             Text("Kapasitas Maks: ",
//                                                 style: TextStyle(
//                                                     fontSize: 12,
//                                                     fontWeight: FontWeight.normal)),
//                                             Text("${offer.maxCapacity} Ton")
//                                           ],
//                                         ),
//                                         const SizedBox(width: 20),
//                                         Column(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.start,
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Text("Volume Maks: ",
//                                                 style: TextStyle(
//                                                     fontSize: 12,
//                                                     fontWeight: FontWeight.normal)),
//                                             Text("${offer.maxVolume} m³")
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                             // secondary: const Icon(Icons.local_shipping,
//                             //     color: Color(0xFF01518D)),
//                           ),
//                         );
//                       },
//                     );
//                   },
//                 ),
//               ),
          
//               // Kategori Penawaran
//               BottomActionSection(
//                 buttonLabel: "Selanjutnya",
//                 categoryLabel: "🔥 Terbaik",
//                 categoryIcon: Icons.local_fire_department,
//                 onPressed: selectedIndex != null
//                     ? () {
//                         setState(() => currentStep = 2);
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => const OfferConfirmationPage(),
//                           ),
//                         );
//                       }
//                     : null,
//               ),
//             ],
//           ),
//       ),
//     );
//   }

//   Widget _buildStepCircle(String number, {bool isActive = false}) {
//     return Container(
//       width: 32,
//       height: 32,
//       decoration: BoxDecoration(
//         color: isActive ? Color(0xFF01518D) : Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(
//           color: isActive ? Color(0xFF01518D) : Colors.grey.shade300,
//           width: 2,
//         ),
//       ),
//       alignment: Alignment.center,
//       child: Text(
//         number,
//         style: TextStyle(
//           color: isActive ? Colors.white : Colors.black,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     );
//   }
// }
