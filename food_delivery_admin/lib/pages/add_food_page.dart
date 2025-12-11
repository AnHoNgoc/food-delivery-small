import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:uuid/uuid.dart';
import '../components/my_button.dart';
import '../components/my_text_field.dart';
import '../models/food.dart';
import '../routes/app_routes.dart';
import '../services/food_service.dart';
import '../utils/show_snackbar.dart';


class AddFoodPage extends StatefulWidget {
  const AddFoodPage({Key? key}) : super(key: key);

  @override
  State<AddFoodPage> createState() => _AddFoodPageState();
}

class _AddFoodPageState extends State<AddFoodPage> {
  final foodService = FoodService();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  FoodCategory _selectedCategory = FoodCategory.burgers;
  List<Addon> _addons = [];
  final TextEditingController _addonNameController = TextEditingController();
  final TextEditingController _addonPriceController = TextEditingController();

  File? _pickedImage;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  void _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _pickedImage = File(image.path);
      });
    }
  }

  void _addAddon() {
    final name = _addonNameController.text.trim();
    final price = double.tryParse(_addonPriceController.text.trim());
    if (name.isNotEmpty && price != null) {
      setState(() {
        _addons.add(Addon(name: name, price: price));
        _addonNameController.clear();
        _addonPriceController.clear();
      });
    }
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_pickedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 1. Upload ảnh
      final downloadURL = await foodService.uploadFoodImage(_pickedImage!);

      // 2. Tạo Food với imagePath là downloadURL
      final food = Food(
        id: const Uuid().v4(),
        name: _nameController.text.trim(),
        description: _descController.text.trim(),
        imagePath: downloadURL, // URL thay vì local path
        price: double.parse(_priceController.text.trim()),
        category: _selectedCategory,
        availableAddons: _addons,
      );

      // 3. Lưu vào Firestore
      await foodService.addFood(food);
      showAppSnackBar(
        context,
        "Food added successfully!",
        Colors.green,
      );

      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.home,
            (route) => false,
      );
      // Reset form
      _formKey.currentState!.reset();
      setState(() {
        _addons.clear();
        _pickedImage = null;
        _selectedCategory = FoodCategory.burgers;
      });
    } catch (e) {
      showAppSnackBar(
        context,
        "Error: $e",
        Colors.redAccent,
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Product',
          style: TextStyle(fontSize: 18.sp),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(10.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Khung chọn ảnh
                GestureDetector(
                  onTap: _pickImage,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.r),
                    child: Container(
                      height: 200.h,
                      width: double.infinity ,
                      decoration: BoxDecoration(
                        border: Border.all(color: Theme.of(context).colorScheme.secondary),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: _pickedImage != null
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child: Image.file(_pickedImage!, fit: BoxFit.cover),
                      )
                          : Center(
                        child: Text(
                          'Tap to select image',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 16.h),

                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      MyTextField(
                        hintText: 'Food Name',
                        obscureText: false,
                        controller: _nameController,
                        validator: (val) => val!.isEmpty ? 'Enter food name' : null,
                      ),
                      SizedBox(height: 12.h),
                      MyTextField(
                        hintText: 'Description',
                        obscureText: false,
                        controller: _descController,
                      ),
                      SizedBox(height: 12.h),
                      MyTextField(
                        hintText: 'Price',
                        obscureText: false,
                        controller: _priceController,
                        validator: (val) => val!.isEmpty ? 'Enter price' : null,
                      ),
                      SizedBox(height: 16.h),

                      // Category dropdown
                      SizedBox(
                        width: 320.w, // hoặc giá trị bạn muốn
                        child: DropdownButtonFormField<FoodCategory>(
                          value: _selectedCategory,
                          items: FoodCategory.values
                              .map((cat) => DropdownMenuItem(
                            value: cat,
                            child: Text(cat.name),
                          ))
                              .toList(),
                          onChanged: (val) {
                            if (val != null) setState(() => _selectedCategory = val);
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                              borderSide: BorderSide(color: Theme.of(context).colorScheme.tertiary),
                            ),
                            filled: true,
                            fillColor: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ),

                      SizedBox(height: 16.h),

                      Padding(
                        padding: EdgeInsets.all(12.r),
                        child: Text('Add Addons',
                            style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),

                      SizedBox(height: 8.h),

                      Row(
                        children: [
                          Expanded(
                            child: MyTextField(
                              hintText: 'Addon Name',
                              obscureText: false,
                              controller: _addonNameController,
                            ),
                          ),
                          Expanded(
                            child: MyTextField(
                              hintText: 'Price',
                              obscureText: false,
                              controller: _addonPriceController,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: _addAddon,
                          ),
                        ],
                      ),

                      SizedBox(height: 10.h),

                      Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: 320.w,
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _addons.length,
                            itemBuilder: (context, index) {
                              final addon = _addons[index];
                              return ListTile(
                                title: Text('${addon.name} - \$${addon.price.toStringAsFixed(2)}'),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => setState(() => _addons.removeAt(index)),
                                ),
                                contentPadding: EdgeInsets.symmetric(horizontal: 8.w),
                                dense: true,
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 24.h),

                      MyButton(
                        text: 'Add Food',
                        onTap: _submit,
                        isLoading: _isLoading,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}