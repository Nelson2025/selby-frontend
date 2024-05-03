/*This is the Add New Autos Screen*/
// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';
import 'package:selby/core/configuration.dart';
import 'package:selby/core/constants.dart';
import 'package:selby/presentation/home/home_screen.dart';
import 'package:selby/presentation/widgets/gap_widget.dart';
import 'package:selby/presentation/widgets/primary_button.dart';
import 'package:selby/presentation/widgets/primary_dropdownbutton.dart';
import 'package:selby/presentation/widgets/secondary_textfield.dart';
import 'package:selby/services/preferences.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class AddAutosScreen extends StatefulWidget {
  final dynamic category;
  final dynamic subcategory;
  final String city;
  final String state;
  final String country;
  const AddAutosScreen({
    Key? key,
    this.category,
    this.subcategory,
    required this.city,
    required this.state,
    required this.country,
  }) : super(key: key);

  @override
  State<AddAutosScreen> createState() => _AddAutosScreenState();
}

class _AddAutosScreenState extends State<AddAutosScreen> {
  List<File> images = [];
  void selectedMultipleImages() async {
    var imagePicker = ImagePicker();

    List<XFile>? file = await imagePicker.pickMultiImage();

    for (XFile items in file) {
      final bytes = await items.readAsBytes();
      final kb = bytes.length / 1024;
      final mb = kb / 1024;

      if (kDebugMode) {
        print('original image size:$mb');
      }

      final dir = await path_provider.getTemporaryDirectory();
      final targetPath =
          '${dir.absolute.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final result = await FlutterImageCompress.compressAndGetFile(
        items.path,
        targetPath,
        quality: 70, // keep this high to get the original quality of image
      );

      final data = await result!.readAsBytes();
      final newKb = data.length / 1024;
      final newMb = newKb / 1024;

      if (kDebugMode) {
        print('compress image size:$newMb');
      }

      images.add(File(result.path));
    }

    setState(() {
      // images.addAll(file);
    });
  }

  bool isLoading = false;
  String error = "";

  bool uploading = false, next = false;
  final ImagePicker picker = ImagePicker();

  String brandController = "";
  String modelController = "";
  String fuelController = "";
  String transmissionController = "";
  String ownerController = "";
  final TextEditingController variantController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  final TextEditingController totalKmsController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  List<XFile> selectedImages = [];
  List<String> listImagePath = [];

  @override
  void initState() {
    cityController.text = widget.city;
    stateController.text = widget.state;
    countryController.text = widget.country;
    super.initState();
  }

  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Add New ${widget.category.title}"),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * 0.02,
              horizontal: MediaQuery.of(context).size.width * 0.04),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                (error != "")
                    ? Text(
                        error,
                        style: const TextStyle(color: Colors.red),
                      )
                    : const SizedBox(),
                PrimaryDropdownButton(
                    label: "Brand",
                    icon: const Icon(
                      Ionicons.add,
                      size: 18,
                    ),
                    dropdownValue: brandController,
                    brand: carBrandList,
                    onChanged: (val) {
                      setState(() {
                        brandController = val!;
                      });
                    }),
                // Text(brandController),
                const GapWidget(),
                PrimaryDropdownButton(
                  label: "Model",
                  icon: const Icon(
                    Ionicons.add,
                    size: 18,
                  ),
                  dropdownValue: modelController,
                  brand: carModelList,
                  onChanged: (val) {
                    setState(() {
                      modelController = val!;
                    });
                  },
                ),
                // Text(modelController),
                const GapWidget(),
                SecondaryTextField(
                  controller: variantController,
                  labelText: "Variant",
                  icon: const Icon(
                    Ionicons.return_down_forward,
                    color: Colors.black,
                    size: 18,
                  ),
                ),
                const GapWidget(),
                Row(
                  children: [
                    Flexible(
                      child: SecondaryTextField(
                        controller: yearController,
                        labelText: "Year",
                        icon: const Icon(
                          Ionicons.return_down_forward,
                          color: Colors.black,
                          size: 18,
                        ),
                      ),
                    ),
                    const GapWidget(),
                    Flexible(
                      child: PrimaryDropdownButton(
                        label: "Owner",
                        icon: const Icon(
                          Ionicons.add,
                          size: 18,
                        ),
                        dropdownValue: ownerController,
                        brand: ownerList,
                        onChanged: (val) {
                          setState(() {
                            ownerController = val!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const GapWidget(),
                Row(
                  children: [
                    Flexible(
                      child: PrimaryDropdownButton(
                        label: "Fuel",
                        icon: const Icon(
                          Ionicons.add,
                          size: 18,
                        ),
                        dropdownValue: fuelController,
                        brand: fuelModelList,
                        onChanged: (val) {
                          setState(() {
                            fuelController = val!;
                          });
                        },
                      ),
                    ),
                    const GapWidget(),
                    Flexible(
                      child: SecondaryTextField(
                        controller: totalKmsController,
                        labelText: "Kms Driven",
                        icon: const Icon(
                          Ionicons.return_down_forward_outline,
                          color: Colors.black,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
                const GapWidget(),
                PrimaryDropdownButton(
                  label: "Select Transmission",
                  icon: const Icon(
                    Ionicons.add,
                    size: 18,
                  ),
                  dropdownValue: transmissionController,
                  brand: transmissionModelList,
                  onChanged: (val) {
                    setState(() {
                      transmissionController = val!;
                    });
                  },
                ),
                const GapWidget(),
                SizedBox(
                  child: SecondaryTextField(
                    controller: titleController,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Title is Required";
                      }
                      return null;
                    },
                    labelText: "Ad Title",
                    icon: const Icon(
                      Ionicons.return_down_forward_outline,
                      color: Colors.black,
                      size: 18,
                    ),
                  ),
                ),
                const GapWidget(),
                SizedBox(
                  height: 130,
                  child: TextField(
                    controller: descriptionController,
                    maxLines: null,
                    expands: true,
                    maxLength: 4096,
                    keyboardType: TextInputType.multiline,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(top: 30, bottom: 2),
                      labelText: 'Describe what are you selling',
                      alignLabelWithHint: true,
                      hintText: 'Describe what are you selling',
                      hintStyle: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14.0,
                      ),
                      labelStyle: const TextStyle(
                        color: Color.fromARGB(255, 10, 10, 10),
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                      ),
                      prefixIcon: const Icon(
                        Ionicons.add,
                        color: Colors.black,
                        size: 18,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.grey.shade200, width: 2),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      floatingLabelStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.black, width: 1.5),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
                const GapWidget(),
                SizedBox(
                  child: SecondaryTextField(
                    controller: priceController,
                    labelText: "Price",
                    icon: const Icon(
                      Ionicons.return_down_forward_outline,
                      color: Colors.black,
                      size: 18,
                    ),
                  ),
                ),
                const GapWidget(),
                SizedBox(
                  child: SecondaryTextField(
                    controller: cityController,
                    labelText: "City",
                  ),
                ),
                const GapWidget(),
                SizedBox(
                  child: SecondaryTextField(
                    controller: stateController,
                    labelText: "State",
                  ),
                ),
                const GapWidget(),
                SizedBox(
                  child: SecondaryTextField(
                    controller: countryController,
                    labelText: "Country",
                  ),
                ),
                const GapWidget(),
                next
                    ? const SingleChildScrollView()
                    : Stack(children: [
                        GridView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: images.length + 1,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisSpacing: 4, crossAxisCount: 3),
                            itemBuilder: (context, index) {
                              return index == 0
                                  ? Container(
                                      color: Colors.grey.shade200,
                                      child: Center(
                                          child: IconButton(
                                        icon: const Icon(Ionicons.add),
                                        onPressed: () {
                                          !uploading
                                              ? selectedMultipleImages()
                                              : null;
                                        },
                                      )),
                                    )
                                  : InkWell(
                                      onDoubleTap: () {
                                        setState(() {
                                          images.removeAt(index - 1);
                                        });
                                      },
                                      child: Image.file(
                                        (images[index - 1]),
                                        height: 50,
                                      ),
                                    );
                            }),
                      ]),
                const GapWidget(),
                PrimaryButton(
                  text: "Submit",
                  onPressed: () {
                    _submit(context);
                  },
                ),
              ],
            ),
          ),
        ));
  }

  Future<void> _submit(BuildContext context) async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      return;
    }

    formKey.currentState!.save();

    final userDetails = await Preferences.fetchUserDetails();
    String? userId = userDetails['userId'];
    FormData formData = FormData.fromMap({
      'categoryId': widget.category.sId,
      'subcategoryId': widget.subcategory,
      'userId': userId,
      'features': {
        'brand': brandController.trim(),
        'model': modelController.trim(),
        'variant': variantController.text.trim(),
        'year': yearController.text.trim(),
        'owner': ownerController.trim(),
        'fuel': fuelController.trim(),
        'kms': totalKmsController.text.trim(),
        'transmission': transmissionController.trim(),
      },
      'title': titleController.text.trim(),
      'description': descriptionController.text.trim(),
      'price': priceController.text.trim(),
      'favourite': "NO",
      "city": cityController.text.trim(),
      "state": stateController.text.trim(),
      "status": "Active",
    });

    for (var file in images) {
      formData.files.addAll([
        MapEntry(
            "image[]",
            await MultipartFile.fromFile(file.path,
                contentType: MediaType('image', 'jpeg')))
      ]);
    }

    Dio dio = Dio();
    Response response;
    try {
      response = await dio.post(
        '${Configuration.baseUrl}${Configuration.createProductUrl}',
        options: Options(headers: {
          "Accept": "*",
          "content-type": "application/json",
        }),
        data: formData,
      );

      if (response.statusCode == 200) {
        if (response.data['success'] == true) {
          if (!mounted) return;
          Navigator.pushAndRemoveUntil(
              // ignore: use_build_context_synchronously
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
              (route) => false);
        } else {
          log(response.data['message']);
        }
      }
    } catch (ex) {
      log(ex.toString());
    }
  }
}
