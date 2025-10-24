import 'package:attappv1/data/constants.dart';
import 'package:attappv1/ui/views/pages/login_page.dart';
import 'package:attappv1/ui/views/widgets/class_card.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        actions: [
          IconButton(onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
              return LoginPage();
            },));
          }, icon: Icon(Icons.logout))
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Welcome back,'),
            Text('Mr. Zahoor Ul Haq', style: TextStyle(fontSize: 24),),
            SizedBox(height: 20,),
            Text('Your Classes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),),
            SizedBox(height: 20,),
            Column(
              children: Constants.classes.map((e){
                return ClassCard(assignedClass: e);
              }).toList(),
            )
          ],
        ),
      ),
    );
  }
}