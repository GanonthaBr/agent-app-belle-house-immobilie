import 'dart:io';
import 'package:agent_app_belle_house_immobilier/models/house.dart';
import 'package:agent_app_belle_house_immobilier/services/image_services.dart';
import 'package:agent_app_belle_house_immobilier/widgets/reusable_widgets.dart';
import 'package:agent_app_belle_house_immobilier/widgets/validators.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import '../../providers/auth_provider.dart';
import '../../providers/house_provider.dart';
import '../../utils/colors.dart';

class AddHouseScreen extends StatefulWidget {
  const AddHouseScreen({Key? key}) : super(key: key);

  @override
  State<AddHouseScreen> createState() => _AddHouseScreenState();
}

class _AddHouseScreenState extends State<AddHouseScreen> {
  final _formKey = GlobalKey<FormState>();
  final ImageService _imageService = ImageService();

  // Form controllers
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _areaController = TextEditingController();
  final _bedroomsController = TextEditingController();
  final _bathroomsController = TextEditingController();
  final _sizeController = TextEditingController();

  String _contractType = 'sale';
  List<File> _selectedImages = [];
  List<String> _features = [];
  bool _isLoading = false;

  final List<String> _availableFeatures = [
    'Piscine',
    'Jardin',
    'Garage',
    'Balcon',
    'Terrasse',
    'Climatisation',
    'Chauffage',
    'Sécurité',
    'Ascenseur',
    'Internet',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _areaController.dispose();
    _bedroomsController.dispose();
    _bathroomsController.dispose();
    _sizeController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    try {
      final List<XFile> images = await _imageService.pickMultipleImages();
      if (images.isNotEmpty) {
        setState(() {
          _selectedImages = images.map((image) => File(image.path)).toList();
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la sélection des images: $e')),
      );
    }
  }

  Future<void> _removeImage(int index) async {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final houseProvider = Provider.of<HouseProvider>(context, listen: false);

      if (authProvider.token == null) {
        throw Exception('Token d\'authentification manquant');
      }

      // Upload images first
      List<String> imageUrls = [];
      for (File image in _selectedImages) {
        final uploadResult =
            await _imageService.uploadImage(image, authProvider.token!);
        if (uploadResult != null) {
          imageUrls.add(uploadResult);
        }
      }

      // Create house object
      final house = House(
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        price: double.parse(_priceController.text),
        area: _areaController.text.trim(),
        typeOfContract: _contractType,
        images: imageUrls,
        bedrooms: int.tryParse(_bedroomsController.text),
        bathrooms: int.tryParse(_bathroomsController.text),
        size: double.tryParse(_sizeController.text),
        features: _features,
      );

      final success = await houseProvider.addHouse(house, authProvider.token!);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Maison ajoutée avec succès!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        throw Exception(houseProvider.error ?? 'Erreur lors de l\'ajout');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Ajouter une Maison'),
        backgroundColor: AppColors.surface,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Basic Information
                  _buildSectionTitle('Informations de base'),
                  const SizedBox(height: 16),

                  CustomTextField(
                    controller: _nameController,
                    label: 'Nom de la maison',
                    hintText: 'Ex: Villa moderne',
                    validator: Validators.required,
                  ),
                  const SizedBox(height: 16),

                  CustomTextField(
                    controller: _descriptionController,
                    label: 'Description',
                    hintText: 'Décrivez la maison...',
                    maxLines: 3,
                    validator: (value) =>
                        Validators.description(value, minLength: 10),
                  ),
                  const SizedBox(height: 16),

                  CustomTextField(
                    controller: _areaController,
                    label: 'Quartier/Zone',
                    hintText: 'Ex: Plateau, Cocody',
                    validator: Validators.area,
                  ),
                  const SizedBox(height: 24),

                  // Contract Type
                  _buildSectionTitle('Type de contrat'),
                  const SizedBox(height: 16),
                  _buildContractTypeSelector(),
                  const SizedBox(height: 24),

                  // Price and Details
                  _buildSectionTitle('Prix et détails'),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          controller: _priceController,
                          label: 'Prix (FCFA)',
                          hintText: '0',
                          keyboardType: TextInputType.number,
                          validator: Validators.price,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CustomTextField(
                          controller: _sizeController,
                          label: 'Superficie (m²)',
                          hintText: '0',
                          keyboardType: TextInputType.number,
                          validator: Validators.size,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          controller: _bedroomsController,
                          label: 'Chambres',
                          hintText: '0',
                          keyboardType: TextInputType.number,
                          validator: (value) => Validators.number(value,
                              fieldName: 'Nombre de chambres'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CustomTextField(
                          controller: _bathroomsController,
                          label: 'Salles de bain',
                          hintText: '0',
                          keyboardType: TextInputType.number,
                          validator: (value) => Validators.number(value,
                              fieldName: 'Nombre de salles de bain'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Features
                  _buildSectionTitle('Caractéristiques'),
                  const SizedBox(height: 16),
                  _buildFeaturesSelector(),
                  const SizedBox(height: 24),

                  // Images
                  _buildSectionTitle('Images'),
                  const SizedBox(height: 16),
                  _buildImageSection(),
                  const SizedBox(height: 32),

                  // Submit Button
                  CustomButton(
                    text: 'Ajouter la Maison',
                    onPressed: _isLoading ? null : _submitForm,
                    isLoading: _isLoading,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          if (_isLoading) const LoadingWidget(),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildContractTypeSelector() {
    return Row(
      children: [
        Expanded(
          child: RadioListTile<String>(
            title: const Text('Vente'),
            value: 'sale',
            groupValue: _contractType,
            onChanged: (value) => setState(() => _contractType = value!),
            activeColor: AppColors.primary,
          ),
        ),
        Expanded(
          child: RadioListTile<String>(
            title: const Text('Location'),
            value: 'rent',
            groupValue: _contractType,
            onChanged: (value) => setState(() => _contractType = value!),
            activeColor: AppColors.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturesSelector() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _availableFeatures.map((feature) {
        final isSelected = _features.contains(feature);
        return FilterChip(
          label: Text(feature),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              if (selected) {
                _features.add(feature);
              } else {
                _features.remove(feature);
              }
            });
          },
          selectedColor: AppColors.primary.withOpacity(0.2),
          checkmarkColor: AppColors.primary,
        );
      }).toList(),
    );
  }

  Widget _buildImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomButton(
          text: 'Sélectionner des images',
          onPressed: _pickImages,
          icon: Icons.photo_library,
          backgroundColor: AppColors.gray100,
          textColor: AppColors.textPrimary,
          height: 40,
        ),
        const SizedBox(height: 16),
        if (_selectedImages.isNotEmpty) ...[
          Text(
            '${_selectedImages.length} image(s) sélectionnée(s)',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _selectedImages.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(right: 12),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          _selectedImages[index],
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () => _removeImage(index),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}
