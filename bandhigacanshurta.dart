import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewTaxesScreen extends StatelessWidget {
  void _deleteTaxRecord(String docId) {
    FirebaseFirestore.instance.collection('taxPayments').doc(docId).delete();
  }

  void _updateTaxRecord(BuildContext context, DocumentSnapshot doc) {
    TextEditingController _nameController = TextEditingController(text: doc['name']);
    TextEditingController _phoneController = TextEditingController(text: doc['phone']);
    TextEditingController _districtController = TextEditingController(text: doc['district']);
    TextEditingController _amountController = TextEditingController(text: doc['amount']);

    String _selectedTaxType = doc['taxType'];
    String _selectedCurrency = doc['currency'];

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

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Update Tax Record'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Magaca'),
            ),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Taleefankaaga'),
            ),
            TextField(
              controller: _districtController,
              decoration: InputDecoration(labelText: 'Degmada Degan tahay'),
            ),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Nooca Canshurta'),
              value: _selectedTaxType,
              onChanged: (newValue) {
                _selectedTaxType = newValue!;
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
                _selectedCurrency = newValue!;
              },
              items: _currencies.map((currency) {
                return DropdownMenuItem(
                  value: currency,
                  child: Text(currency),
                );
              }).toList(),
            ),
            TextField(
              controller: _amountController,
              decoration: InputDecoration(labelText: 'Gali Lacagta (\$)'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              FirebaseFirestore.instance.collection('taxPayments').doc(doc.id).update({
                'name': _nameController.text,
                'phone': _phoneController.text,
                'district': _districtController.text,
                'taxType': _selectedTaxType,
                'currency': _selectedCurrency,
                'amount': _amountController.text,
              }).then((_) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Record updated successfully')));
              }).catchError((error) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update record: $error')));
              });
            },
            child: Text('Update'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Arag Canshurta'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('taxPayments').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No data available'));
          }

          final taxData = snapshot.data!.docs;

          return ListView.builder(
            itemCount: taxData.length,
            itemBuilder: (context, index) {
              var taxRecord = taxData[index];

              return ListTile(
                title: Text(taxRecord['name']),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Phone: ${taxRecord['phone']}'),
                    Text('District: ${taxRecord['district']}'),
                    Text('Tax Type: ${taxRecord['taxType']}'),
                    Text('Currency: ${taxRecord['currency']}'),
                    Text('Amount: ${taxRecord['amount']}'),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => _updateTaxRecord(context, taxRecord),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _deleteTaxRecord(taxRecord.id),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
