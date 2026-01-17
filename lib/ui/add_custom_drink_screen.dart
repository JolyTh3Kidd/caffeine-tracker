import 'package:flutter/material.dart';
import '../models/custom_drink.dart';
import '../services/storage_service.dart';

class AddCustomDrinkScreen extends StatefulWidget {
  final Function(CustomDrink) onSave;

  const AddCustomDrinkScreen({super.key, required this.onSave});

  @override
  State<AddCustomDrinkScreen> createState() => _AddCustomDrinkScreenState();
}

class _AddCustomDrinkScreenState extends State<AddCustomDrinkScreen> {
  late TextEditingController _nameController;
  late TextEditingController _caffeineController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _caffeineController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _caffeineController.dispose();
    super.dispose();
  }

  void _saveDrink() {
    if (_nameController.text.isEmpty || _caffeineController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    final drink = CustomDrink(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text,
      caffeine: int.parse(_caffeineController.text),
    );

    StorageService.addCustomDrink(drink);
    widget.onSave(drink);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Custom Drink'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Drink name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _caffeineController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Caffeine (mg)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveDrink,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Save Drink'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
