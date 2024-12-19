
import 'package:canshuurta/screens/bandhigacanshurta.dart';
import 'package:canshuurta/screens/galinta%20canshurta.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';





class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('canshuurbixinta')),
      body: Center(child: Text('kuso dhawow canshurbixinta')),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: Text('flag'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),

            ListTile(
              title: Text('bixinta canshurta'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => TaxPaymentScreen()),
                );
              },
            ),
            ListTile(
              title: Text('arag canshuta bixisay'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ViewTaxesScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pop(context); // Close the drawer
              },
            ),
          ],
        ),
      ),
    );
  }
}