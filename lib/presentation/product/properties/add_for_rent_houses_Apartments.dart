/* This is Add New Properties - For Rent: Houses & Apartments Screen*/
import 'dart:developer';
import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http_parser/http_parser.dart';
import 'package:ionicons/ionicons.dart';
import 'package:selby/core/configuration.dart';
import 'package:selby/core/constants.dart';
import 'package:selby/presentation/home/home_screen.dart';
import 'package:selby/presentation/notification_controller.dart';
import 'package:selby/presentation/widgets/gap_widget.dart';
import 'package:selby/presentation/widgets/primary_button.dart';
import 'package:selby/presentation/widgets/primary_dropdownbutton.dart';
import 'package:selby/presentation/widgets/secondary_textfield.dart';
import 'package:image_picker/image_picker.dart';
import 'package:selby/services/preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class AddForRentHousesApartmentsScreen extends StatefulWidget {
  final dynamic category;
  final dynamic subcategory;
  final String city;
  final String state;
  final String country;
  const AddForRentHousesApartmentsScreen(
      {super.key,
      this.category,
      this.subcategory,
      required this.city,
      required this.state,
      required this.country});

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static const String name = 'Awesome Notifications - Example App';
  static const Color mainColor = Colors.deepPurple;

  @override
  State<AddForRentHousesApartmentsScreen> createState() =>
      _AddForRentHousesApartmentsScreenState();
}

class _AddForRentHousesApartmentsScreenState
    extends State<AddForRentHousesApartmentsScreen> {
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

  String typeController = "";
  String bedroomsController = "";
  String bathroomsController = "";
  String furnishingController = "";
  String constuctionStatusController = "";
  String listedByController = "";
  String bachelorsController = "";
  String carParkingController = "";
  String facingController = "";
  final TextEditingController superBuiltupAreaController =
      TextEditingController();
  final TextEditingController carpetAreaController = TextEditingController();
  final TextEditingController maintenanceController = TextEditingController();
  final TextEditingController totalFloorsController = TextEditingController();
  final TextEditingController floorNoController = TextEditingController();
  final TextEditingController projectNameController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController landmarkController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  List<XFile> selectedImages = [];
  List<String> listImagePath = [];

  String? notificationUserId;

  getPhone() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    notificationUserId = preferences.get('userId').toString();
    setState(() {
      notificationUserId;
    });
  }

  @override
  void initState() {
    getPhone();
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationController.onActionReceivedMethod,
      onNotificationCreatedMethod:
          NotificationController.onNotificationCreatedMethod,
      onNotificationDisplayedMethod:
          NotificationController.onNotificationDisplayedMethod,
      onDismissActionReceivedMethod:
          NotificationController.onDismissActionReceivedMethod,
    );

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
          title: Text("Add New ${widget.subcategory}"),
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
                    label: "Type",
                    icon: const Icon(
                      Ionicons.add,
                      size: 18,
                    ),
                    dropdownValue: typeController,
                    brand: typeList1,
                    onChanged: (val) {
                      setState(() {
                        typeController = val!;
                      });
                    }),
                // Text(brandController),
                const GapWidget(),
                PrimaryDropdownButton(
                  label: "Bedrooms",
                  icon: const Icon(
                    Ionicons.add,
                    size: 18,
                  ),
                  dropdownValue: bedroomsController,
                  brand: bedroomsList,
                  onChanged: (val) {
                    setState(() {
                      bedroomsController = val!;
                    });
                  },
                ),
                const GapWidget(),
                PrimaryDropdownButton(
                  label: "Bathrooms",
                  icon: const Icon(
                    Ionicons.add,
                    size: 18,
                  ),
                  dropdownValue: bathroomsController,
                  brand: bathroomsList,
                  onChanged: (val) {
                    setState(() {
                      bathroomsController = val!;
                    });
                  },
                ),
                const GapWidget(),
                PrimaryDropdownButton(
                  label: "Furnishing",
                  icon: const Icon(
                    Ionicons.add,
                    size: 18,
                  ),
                  dropdownValue: furnishingController,
                  brand: furnishingList,
                  onChanged: (val) {
                    setState(() {
                      furnishingController = val!;
                    });
                  },
                ),

                const GapWidget(),
                PrimaryDropdownButton(
                  label: "Listed By",
                  icon: const Icon(
                    Ionicons.add,
                    size: 18,
                  ),
                  dropdownValue: listedByController,
                  brand: listedByList,
                  onChanged: (val) {
                    setState(() {
                      listedByController = val!;
                    });
                  },
                ),
                // Text(modelController),
                const GapWidget(),
                SecondaryTextField(
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Super Builtup Area is Required";
                    }
                    return null;
                  },
                  controller: superBuiltupAreaController,
                  labelText: "Super Builtup Area (ft\u00b2)",
                  icon: const Icon(
                    Ionicons.return_down_forward,
                    color: Colors.black,
                    size: 18,
                  ),
                ),
                const GapWidget(),

                SecondaryTextField(
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Carpet Area (Monthly) is Required";
                    }
                    return null;
                  },
                  controller: carpetAreaController,
                  labelText: "Carpet Area (ft\u00b2)",
                  icon: const Icon(
                    Ionicons.return_down_forward,
                    color: Colors.black,
                    size: 18,
                  ),
                ),
                const GapWidget(),
                PrimaryDropdownButton(
                  label: "Bachelors",
                  icon: const Icon(
                    Ionicons.add,
                    size: 18,
                  ),
                  dropdownValue: bachelorsController,
                  brand: bachelorsList,
                  onChanged: (val) {
                    setState(() {
                      furnishingController = val!;
                    });
                  },
                ),
                const GapWidget(),
                SecondaryTextField(
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Maintenance (Monthly) is Required";
                    }
                    return null;
                  },
                  controller: maintenanceController,
                  labelText: "Maintenance (Monthly)",
                  icon: const Icon(
                    Ionicons.return_down_forward,
                    color: Colors.black,
                    size: 18,
                  ),
                ),
                const GapWidget(),
                SecondaryTextField(
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Total Floors is Required";
                    }
                    return null;
                  },
                  controller: totalFloorsController,
                  labelText: "Total Floors",
                  icon: const Icon(
                    Ionicons.return_down_forward,
                    color: Colors.black,
                    size: 18,
                  ),
                ),
                const GapWidget(),
                SecondaryTextField(
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Floor No. is Required";
                    }
                    return null;
                  },
                  controller: floorNoController,
                  labelText: "Floor No.",
                  icon: const Icon(
                    Ionicons.return_down_forward,
                    color: Colors.black,
                    size: 18,
                  ),
                ),
                const GapWidget(),
                PrimaryDropdownButton(
                  label: "Car Parking",
                  icon: const Icon(
                    Ionicons.add,
                    size: 18,
                  ),
                  dropdownValue: carParkingController,
                  brand: carParkingList,
                  onChanged: (val) {
                    setState(() {
                      carParkingController = val!;
                    });
                  },
                ),
                const GapWidget(),
                PrimaryDropdownButton(
                  label: "Facing",
                  icon: const Icon(
                    Ionicons.add,
                    size: 18,
                  ),
                  dropdownValue: facingController,
                  brand: facingList,
                  onChanged: (val) {
                    setState(() {
                      facingController = val!;
                    });
                  },
                ),
                const GapWidget(),
                SecondaryTextField(
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Project Name is Required";
                    }
                    return null;
                  },
                  controller: projectNameController,
                  labelText: "Project Name",
                  icon: const Icon(
                    Ionicons.return_down_forward,
                    color: Colors.black,
                    size: 18,
                  ),
                ),

                const GapWidget(),

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
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Description is Required";
                      }
                      return null;
                    },
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
                        color: Colors.black,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                      ),
                      prefixIcon: const Icon(
                        Ionicons.return_down_forward_outline,
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
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Price is Required";
                      }
                      return null;
                    },
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
                    readOnly: true,
                  ),
                ),
                const GapWidget(),
                SizedBox(
                  child: SecondaryTextField(
                    controller: stateController,
                    labelText: "State",
                    readOnly: true,
                  ),
                ),
                const GapWidget(),
                SizedBox(
                  child: SecondaryTextField(
                    controller: countryController,
                    labelText: "Country",
                    readOnly: true,
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
                const Text(
                  "Double tap to remove photos",
                  style: TextStyle(fontSize: 12),
                ),
                const GapWidget(),
                isLoading == true
                    ? const CircularProgressIndicator()
                    : PrimaryButton(
                        text: "Submit",
                        onPressed: () {
                          setState(() {
                            isLoading = true;
                          });
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
      setState(() {
        isLoading = false;
      });
      return;
    }

    if (images.isEmpty) {
      setState(() {
        isLoading = false;
      });
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
        'type': typeController.trim(),
        'bedrooms': bedroomsController.trim(),
        'bathrooms': bathroomsController.trim(),
        'furnishing': furnishingController.trim(),
        'listedBy': listedByController.trim(),
        'bachelors': bachelorsController.trim(),
        'superBuiltupArea': superBuiltupAreaController.text.trim(),
        'carpetArea': carpetAreaController.text.trim(),
        'maintenanceMonthly': maintenanceController.text.trim(),
        'totalFloors': totalFloorsController.text.trim(),
        'carParking': carParkingController.trim(),
        'facing': facingController.trim(),
        'projectName': projectNameController.text.trim(),
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
          if (userId == notificationUserId) {
            AwesomeNotifications().createNotification(
                content: NotificationContent(
                    id: 1,
                    channelKey: "basic_channel",
                    actionType: ActionType.Default,
                    title: "Great!",
                    body: "You ad is live now."));
          }
          setState(() {
            isLoading = false;
          });
          Navigator.pushAndRemoveUntil(
              // ignore: use_build_context_synchronously
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
              (route) => false);
        } else {
          setState(() {
            isLoading = false;
          });
        }
      }
    } catch (ex) {
      log(ex.toString());
      setState(() {
        isLoading = false;
      });
    }
  }
}
