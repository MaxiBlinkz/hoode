import 'package:cool_alert/cool_alert.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:hoode/app/data/enums/enums.dart';
import 'package:hoode/app/modules/home/home_page.dart';
import 'package:hoode/app/modules/nav_bar/nav_bar_page.dart';
// import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:latlong2/latlong.dart';
import '../../core/theme/colors.dart';
import 'profile_setup_controller.dart';

class ProfileSetupPage extends GetView<ProfileSetupController> {
  ProfileSetupPage({super.key});


  @override
  Widget build(BuildContext context) {
    //final id = Get.arguments.id;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primary, AppColors.primary.withOpacity(0.7)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Complete Your Profile",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    width: 350,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 15,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Obx(() {
                          return CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.grey[200],
                            backgroundImage:
                                controller.selectedImage.value != null
                                    ? FileImage(controller.selectedImage.value!)
                                    : null,
                            child: controller.selectedImage.value == null
                                ? IconButton(
                                    icon: Icon(Icons.camera_alt),
                                    iconSize: 40,
                                    color: AppColors.primary,
                                    onPressed: () => controller.getImage(),
                                  )
                                : null,
                          );
                        }),
                        const SizedBox(height: 10),
                        TextButton(
                          onPressed: () => controller.getImage(),
                          child: Text(
                            controller.selectedImage.value == null
                                ? "Select Image"
                                : "Change Image",
                            style: TextStyle(color: AppColors.primary),
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          controller: controller.firstnameController,
                          hintText: "First Name",
                          prefixIcon: Icons.person,
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          controller: controller.lastnameController,
                          hintText: "Last Name",
                          prefixIcon: Icons.person,
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          controller: controller.contactInfoController,
                          hintText: "Contact Info",
                          prefixIcon: Icons.description,
                        ),
                        const SizedBox(height: 20),
                        CSCPicker(
                          showCities: true,
                          showStates: true,
                          onCountryChanged: (value) =>
                              controller.setCountry(value),
                          onStateChanged: (value) =>
                              controller.setState(value),
                          onCityChanged: (value) => controller.setTown(value),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                controller: controller.locationController,
                                hintText: "Location",
                                prefixIcon: Icons.location_on,
                                readOnly: true,
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.my_location),
                              onPressed: () => controller.getCurrentLocation(),
                            ),
                            IconButton(
                              icon: Icon(Icons.map),
                              onPressed: () => Get.dialog(
                                Dialog(
                                  child: SizedBox(
                                    height: 400,
                                    child: FlutterMap(
                                      options: MapOptions(
                                        initialCenter:
                                            controller.selectedLocation.value ??
                                                LatLng(0, 0),
                                        initialZoom: 13,
                                        onTap: (tapPosition, point) {
                                          controller.selectedLocation.value =
                                              point;
                                          controller.locationController.text =
                                              "${point.latitude}, ${point.longitude}";
                                          Get.back();
                                        },
                                      ),
                                      children: [
                                        TileLayer(
                                          urlTemplate:
                                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                        ),
                                        MarkerLayer(
                                          markers: [
                                            if (controller
                                                    .selectedLocation.value !=
                                                null)
                                              Marker(
                                                key: UniqueKey(),
                                                point: controller
                                                    .selectedLocation.value!,
                                                width: 30,
                                                height: 30,
                                                alignment: Alignment.center,
                                                rotate: true,
                                                child: Icon(
                                                  Icons.location_pin,
                                                  color: AppColors.primary,
                                                  size: 30,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: () async {
                            await controller.saveProfile();
                              if (controller.status.value == Status.success) {
                              Get.offAll(() => const NavBarPage());
                              } else if (controller.status.value ==
                                  Status.error) {
                                CoolAlert.show(
                                    context: context,
                                    type: CoolAlertType.error,
                                    title: "Oops!!",
                                    text: "Error Updating profile...");
                              }
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 50, vertical: 15),
                            textStyle: const TextStyle(fontSize: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text("Save Profile"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon, bool readOnly = false,
  }) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(prefixIcon, color: AppColors.primary),
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 15),
      ),
    );
  }
}
