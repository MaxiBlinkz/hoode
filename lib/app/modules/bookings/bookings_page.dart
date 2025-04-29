import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'bookings_controller.dart';

class BookingsPage extends GetView<BookingsController> {
  const BookingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookings'),
        centerTitle: true,
      ),
      body: Obx(() => controller.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : controller.bookings.isEmpty
              ? const Center(child: Text('No bookings yet.'))
              : ListView.builder(
                  itemCount: controller.bookings.length,
                  itemBuilder: (context, index) {
                    final booking = controller.bookings[index];
                    return _buildBookingCard(context, booking);
                  },
                ),
        ),
    );
  }

  Widget _buildBookingCard(BuildContext context, booking) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
          decoration: BoxDecoration(
           color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
             boxShadow: [
               BoxShadow(
            color: Theme.of(context).shadowColor.withValues(
                  red: 0,
                  green: 0,
                  blue: 0,
                  alpha: 0.2,
                ),
            spreadRadius: 1,
            blurRadius: 5,
             ),
             ],
          ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                    Text("Date", style: Theme.of(context).textTheme.bodyMedium,),
                   Text("Time", style: Theme.of(context).textTheme.bodyMedium,),
                 ],
               ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                          Text(booking.data["date"] ?? "",  style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.grey),),
                           Text(booking.data["time"] ?? "",   style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.grey),),
                      ],
                  ),
                  const SizedBox(height: 8,),
                  Text(booking.data["property_address"] ?? "", style: Theme.of(context).textTheme.bodyMedium,),
                 const SizedBox(height: 8,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  Text(booking.data["user_name"] ?? "",   style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.grey),),
                     Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                           color: booking.data["status"] == "Confirmed" ? Colors.green.shade100 : Colors.orange.shade100,
                            borderRadius: BorderRadius.circular(5)
                           ),
                           child:  Text(booking.data["status"] ?? "", style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                  color: booking.data["status"] == "Confirmed" ? Colors.green.shade900 : Colors.orange.shade900
                                 )
                           )
                        ),
                  ],
                )
              ],
          ),
        ),
      ),
    );
  }
}