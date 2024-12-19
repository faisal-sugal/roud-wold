import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TaxPaymentScreen extends StatefulWidget {
  @override
  _TaxPaymentScreenState createState() => _TaxPaymentScreenState();
}

class _TaxPaymentScreenState extends State<TaxPaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  String _selectedTaxType = 'Canshuurta Guriga';
  String _selectedCurrency = 'Dollar';

  final List<String> _taxTypes = [
    'Canshuurta Guriga',
    'Canshuurta Gariga',
    'Canshuurta Ganacsiga',
    'Canshuurta Badda',
    'Canshuurta Hawada'
  ];

  final List<String> _currencies = [
    'Dollar',
    'Shilin Somali'
  ];

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      FirebaseFirestore.instance.collection('taxPayments').add({
        'name': _nameController.text,
        'phone': _phoneController.text,
        'district': _districtController.text,
        'taxType': _selectedTaxType,
        'currency': _selectedCurrency,
        'amount': _amountController.text,
      }).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('canshurbixintada wala xaqijiyay')),
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add data: $error')),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Caanshurbixinta')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Magaca'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Taleefankaaga'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _districtController,
                decoration: InputDecoration(labelText: 'Degmada Degan tahay'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your district';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Nooca Canshurta'),
                value: _selectedTaxType,
                onChanged: (newValue) {
                  setState(() {
                    _selectedTaxType = newValue!;
                  });
                },
                items: _taxTypes.map((taxType) {
                  return DropdownMenuItem(
                    value: taxType,
                    child: Text(taxType),
                  );
                }).toList(),
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Nooca Lacagta'),
                value: _selectedCurrency,
                onChanged: (newValue) {
                  setState(() {
                    _selectedCurrency = newValue!;
                  });
                },
                items: _currencies.map((currency) {
                  return DropdownMenuItem(
                    value: currency,
                    child: Text(currency),
                  );
                }).toList(),
              ),
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(labelText: 'Gali Lacagta (\$)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the amount';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('BIXI CANSHURTA'),

              ),
            ],
          ),
        ),
      ),
    );
  }
}
