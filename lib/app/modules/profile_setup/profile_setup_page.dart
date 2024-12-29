import 'package:country_state_city_pro/country_state_city_pro.dart';
// import 'package:csc_picker/csc_picker.dart';
import 'package:country_state_city_picker_2/country_state_city_picker.dart';
import 'package:csc_picker_plus/csc_picker_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:hoode/app/data/enums/enums.dart';
import 'package:hoode/app/modules/nav_bar/nav_bar_page.dart';
import 'package:latlong2/latlong.dart';
import '../../core/theme/colors.dart';
import 'profile_setup_controller.dart';

class ProfileSetupPage extends GetView<ProfileSetupController> {
  ProfileSetupPage({super.key});


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primary, AppColors.primary.withValues(blue: 0.7)],
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
                        CSCPickerPlus(
                          showCities: true,
                          showStates: true,
                          onCountryChanged: (value) =>
                              controller.setCountry(value),
                          onStateChanged: (value) =>
                              controller.setState(value),
                          onCityChanged: (value) => controller.setCity(value),
                        ),
                        // TODO Setup Country picker
                        // CountryStateCityPicker(
                        //   country: controller.countryController, 
                        //   state: controller.stateController, 
                        //   city: controller.cityController,
                        //   textFieldDecoration: InputDecoration(

                        //   ),),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Row(
                              children: [
                                Text(
                                "Location:"
                              ),
                              IconButton(
                              icon: Icon(Icons.my_location),
                              onPressed: () => controller.setCurrentLocation(),
                            ),
                              ]
                            ),
                          ],
),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: () async {
                            await controller.saveProfile();
                              if (controller.status.value == Status.success) {
                              Get.offAll(() => const NavBarPage());
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
